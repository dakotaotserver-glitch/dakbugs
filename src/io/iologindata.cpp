/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/iologindata.hpp"

#include "account/account.hpp"
#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "io/functions/iologindata_load_player.hpp"
#include "io/functions/iologindata_save_player.hpp"
#include "game/game.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/players/player.hpp"
#include "lib/metrics/metrics.hpp"
#include "enums/account_type.hpp"
#include "enums/account_errors.hpp"

// Anti-Flood Protection System
// Início da implementação do sistema anti-flood
#include <chrono>
#include <mutex>
#include <shared_mutex>
#include <unordered_map>
#include <list>
#include <array>
#include <string>
#include <algorithm>
#include <memory>

// Implementações dos métodos da classe IPAddress
IPAddress::IPAddress(uint32_t ipv4) : isIPv6(false) {
    ipv4Address = ipv4;
}

IPAddress::IPAddress(const std::array<uint8_t, 16>& ipv6) : isIPv6(true) {
    ipv6Address = ipv6;
}

IPAddress::IPAddress(const std::string& ipString) {
    // Verifica se é IPv6 (contém ':')
    if (ipString.find(':') != std::string::npos) {
        isIPv6 = true;
        // Implementação simplificada - em produção, use uma biblioteca robusta
        // para parsing de IPv6
        std::fill(ipv6Address.begin(), ipv6Address.end(), 0);
    } else {
        isIPv6 = false;
        // Parsing de IPv4
        std::vector<std::string> parts;
        size_t start = 0;
        size_t end = ipString.find('.');
        while (end != std::string::npos) {
            parts.push_back(ipString.substr(start, end - start));
            start = end + 1;
            end = ipString.find('.', start);
        }
        parts.push_back(ipString.substr(start));

        if (parts.size() != 4) {
            ipv4Address = 0;
            return;
        }

        ipv4Address = 0;
        for (size_t i = 0; i < 4; ++i) {
            ipv4Address = (ipv4Address << 8) | static_cast<uint8_t>(std::stoi(parts[i]));
        }
    }
}

bool IPAddress::operator==(const IPAddress& other) const {
    if (isIPv6 != other.isIPv6) {
        return false;
    }

    if (isIPv6) {
        return ipv6Address == other.ipv6Address;
    } else {
        return ipv4Address == other.ipv4Address;
    }
}

bool IPAddress::operator!=(const IPAddress& other) const {
    return !(*this == other);
}

std::string IPAddress::toString() const {
    if (isIPv6) {
        // Implementação simplificada para IPv6
        std::stringstream ss;
        ss << std::hex;
        for (size_t i = 0; i < ipv6Address.size(); i += 2) {
            if (i > 0) {
                ss << ":";
            }
            ss << static_cast<int>(ipv6Address[i] << 8 | ipv6Address[i + 1]);
        }
        return ss.str();
    } else {
        // IPv4
        std::stringstream ss;
        ss << ((ipv4Address >> 24) & 0xFF) << "."
           << ((ipv4Address >> 16) & 0xFF) << "."
           << ((ipv4Address >> 8) & 0xFF) << "."
           << (ipv4Address & 0xFF);
        return ss.str();
    }
}

size_t IPAddress::Hash::operator()(const IPAddress& ip) const {
    if (ip.isIPv6) {
        // Hash simples para IPv6
        size_t hash = 0;
        for (size_t i = 0; i < ip.ipv6Address.size(); ++i) {
            hash = hash * 31 + ip.ipv6Address[i];
        }
        return hash;
    } else {
        // Hash para IPv4
        return std::hash<uint32_t>()(ip.ipv4Address);
    }
}

// Implementações dos métodos da estrutura LoginAttemptInfo
bool FloodProtection::LoginAttemptInfo::isBlocked(int64_t currentTime) const {
    return blockStartTime > 0 && blockDuration > 0 && currentTime < blockStartTime + blockDuration;
}

int FloodProtection::LoginAttemptInfo::getRemainingBlockTime(int64_t currentTime) const {
    if (!isBlocked(currentTime)) {
        return 0;
    }
    
    return static_cast<int>(blockStartTime + blockDuration - currentTime);
}

bool FloodProtection::LoginAttemptInfo::exceedsRateLimit(int64_t currentTime, int windowSeconds, int maxAttempts) const {
    int count = 0;
    for (auto it = recentAttempts.begin(); it != recentAttempts.end(); ++it) {
        if (currentTime - *it <= windowSeconds) {
            count++;
            if (count >= maxAttempts) {
                return true;
            }
        }
    }
    return false;
}

// Variáveis estáticas da classe FloodProtection
std::unordered_map<IPAddress, FloodProtection::LoginAttemptInfo, IPAddress::Hash> FloodProtection::ipCache;
std::unordered_map<std::string, FloodProtection::LoginAttemptInfo> FloodProtection::accountCache;
std::shared_mutex FloodProtection::cacheMutex;

// Implementações dos métodos da classe FloodProtection
void FloodProtection::initialize() {
    // Inicializa o sistema anti-flood
    createTablesIfNotExist();
    loadBlocksFromDatabase();
}

bool FloodProtection::isIPBlocked(const IPAddress& ip) {
    std::shared_lock<std::shared_mutex> lock(cacheMutex);
    
    auto it = ipCache.find(ip);
    if (it == ipCache.end()) {
        return false;
    }
    
    return it->second.isBlocked(getCurrentTime());
}

bool FloodProtection::isAccountBlocked(const std::string& accountName) {
    std::shared_lock<std::shared_mutex> lock(cacheMutex);
    
    auto it = accountCache.find(accountName);
    if (it == accountCache.end()) {
        return false;
    }
    
    return it->second.isBlocked(getCurrentTime());
}

void FloodProtection::recordFailedAttempt(const IPAddress& ip, const std::string& accountName) {
    std::unique_lock<std::shared_mutex> lock(cacheMutex);
    
    int64_t currentTime = getCurrentTime();
    
    // Atualiza informações do IP
    auto& ipInfo = ipCache[ip];
    updateLoginAttemptInfo(ipInfo, currentTime, false);
    
    // Atualiza informações da conta (se fornecida)
    if (!accountName.empty()) {
        auto& accountInfo = accountCache[accountName];
        updateLoginAttemptInfo(accountInfo, currentTime, false);
    }
    
    // Garante que o cache não exceda o tamanho máximo
    ensureCacheSize();
    
    // Salva bloqueio no banco de dados se aplicado
    if (ipInfo.blockStartTime > 0 && ipInfo.blockDuration > 0) {
        saveBlockToDatabase(ip.toString(), "ip", ipInfo);
    }
    
    if (!accountName.empty() && accountCache[accountName].blockStartTime > 0 && accountCache[accountName].blockDuration > 0) {
        saveBlockToDatabase(accountName, "account", accountCache[accountName]);
    }
    
    // Salva log da tentativa
    saveLoginAttemptLog(ip.toString(), accountName, "", currentTime, false, 
                       ipInfo.blockStartTime > 0, ipInfo.blockDuration);
}

void FloodProtection::recordSuccessfulLogin(const IPAddress& ip, const std::string& accountName) {
    std::unique_lock<std::shared_mutex> lock(cacheMutex);
    
    int64_t currentTime = getCurrentTime();
    
    // Atualiza informações do IP
    auto ipIt = ipCache.find(ip);
    if (ipIt != ipCache.end()) {
        updateLoginAttemptInfo(ipIt->second, currentTime, true);
    }
    
    // Atualiza informações da conta
    if (!accountName.empty()) {
        auto accountIt = accountCache.find(accountName);
        if (accountIt != accountCache.end()) {
            updateLoginAttemptInfo(accountIt->second, currentTime, true);
        }
    }
    
    // Salva log da tentativa bem-sucedida
    saveLoginAttemptLog(ip.toString(), accountName, "", currentTime, true, false, 0);
}

std::string FloodProtection::getBlockMessage(const IPAddress& ip) {
    std::shared_lock<std::shared_mutex> lock(cacheMutex);
    
    auto it = ipCache.find(ip);
    if (it == ipCache.end() || !it->second.isBlocked(getCurrentTime())) {
        return "";
    }
    
    int remainingTime = it->second.getRemainingBlockTime(getCurrentTime());
    int minutes = remainingTime / 60;
    int seconds = remainingTime % 60;
    
    std::stringstream ss;
    ss << "Seu IP foi temporariamente bloqueado por excesso de tentativas de login. ";
    ss << "Tente novamente em " << minutes << " minutos e " << seconds << " segundos.";
    
    return ss.str();
}

std::string FloodProtection::getBlockMessage(const std::string& accountName, bool isAccount) {
    if (!isAccount) {
        return "";
    }
    
    std::shared_lock<std::shared_mutex> lock(cacheMutex);
    
    auto it = accountCache.find(accountName);
    if (it == accountCache.end() || !it->second.isBlocked(getCurrentTime())) {
        return "";
    }
    
    int remainingTime = it->second.getRemainingBlockTime(getCurrentTime());
    int minutes = remainingTime / 60;
    int seconds = remainingTime % 60;
    
    std::stringstream ss;
    ss << "Esta conta foi temporariamente bloqueada por excesso de tentativas de login. ";
    ss << "Tente novamente em " << minutes << " minutos e " << seconds << " segundos.";
    
    return ss.str();
}

void FloodProtection::cleanupOldEntries() {
    std::unique_lock<std::shared_mutex> lock(cacheMutex);
    
    int64_t currentTime = getCurrentTime();
    const int64_t maxAge = LONG_WINDOW_SECONDS;
    
    // Remove entradas de IP expiradas
    for (auto it = ipCache.begin(); it != ipCache.end();) {
        if (!it->second.isBlocked(currentTime) && currentTime - it->second.lastAttemptTime > maxAge) {
            it = ipCache.erase(it);
        } else {
            ++it;
        }
    }
    
    // Remove entradas de conta expiradas
    for (auto it = accountCache.begin(); it != accountCache.end();) {
        if (!it->second.isBlocked(currentTime) && currentTime - it->second.lastAttemptTime > maxAge) {
            it = accountCache.erase(it);
        } else {
            ++it;
        }
    }
}

std::string FloodProtection::getStatistics() {
    std::shared_lock<std::shared_mutex> lock(cacheMutex);
    
    int64_t currentTime = getCurrentTime();
    int blockedIPs = 0;
    int blockedAccounts = 0;
    
    for (const auto& pair : ipCache) {
        if (pair.second.isBlocked(currentTime)) {
            blockedIPs++;
        }
    }
    
    for (const auto& pair : accountCache) {
        if (pair.second.isBlocked(currentTime)) {
            blockedAccounts++;
        }
    }
    
    std::stringstream ss;
    ss << "Estatísticas do sistema anti-flood:\n";
    ss << "- IPs em cache: " << ipCache.size() << "\n";
    ss << "- Contas em cache: " << accountCache.size() << "\n";
    ss << "- IPs bloqueados: " << blockedIPs << "\n";
    ss << "- Contas bloqueadas: " << blockedAccounts;
    
    return ss.str();
}

int64_t FloodProtection::getCurrentTime() {
    return std::chrono::duration_cast<std::chrono::seconds>(
        std::chrono::steady_clock::now().time_since_epoch()
    ).count();
}

void FloodProtection::updateLoginAttemptInfo(LoginAttemptInfo& info, int64_t currentTime, bool success) {
    // Atualiza o timestamp da última tentativa
    info.lastAttemptTime = currentTime;
    
    // Adiciona a tentativa à lista de tentativas recentes
    info.recentAttempts.push_front(currentTime);
    
    // Mantém apenas as tentativas dentro da janela mais longa
    while (!info.recentAttempts.empty() && currentTime - info.recentAttempts.back() > LONG_WINDOW_SECONDS) {
        info.recentAttempts.pop_back();
    }
    
    if (success) {
        // Login bem-sucedido, reseta contagem de falhas
        info.failCount = 0;
        info.blockStartTime = 0;
        info.blockDuration = 0;
    } else {
        // Login falhou
        info.failCount++;
        
        // Verifica se excede o limite de tentativas em qualquer janela de tempo
        bool shouldBlock = false;
        
        if (info.exceedsRateLimit(currentTime, SHORT_WINDOW_SECONDS, SHORT_WINDOW_MAX_ATTEMPTS)) {
            shouldBlock = true;
        } else if (info.exceedsRateLimit(currentTime, MEDIUM_WINDOW_SECONDS, MEDIUM_WINDOW_MAX_ATTEMPTS)) {
            shouldBlock = true;
        } else if (info.exceedsRateLimit(currentTime, LONG_WINDOW_SECONDS, LONG_WINDOW_MAX_ATTEMPTS)) {
            shouldBlock = true;
        }
        
        if (shouldBlock) {
            // Calcula duração do bloqueio com base no número de falhas
            int blockDuration = INITIAL_BLOCK_DURATION;
            for (int i = 1; i < info.failCount; i++) {
                blockDuration = static_cast<int>(blockDuration * BLOCK_DURATION_MULTIPLIER);
                if (blockDuration > MAX_BLOCK_DURATION) {
                    blockDuration = MAX_BLOCK_DURATION;
                    break;
                }
            }
            
            info.blockStartTime = currentTime;
            info.blockDuration = blockDuration;
        }
    }
}

void FloodProtection::ensureCacheSize() {
    // Se o cache de IPs exceder o tamanho máximo, remove as entradas mais antigas
    if (ipCache.size() > MAX_CACHE_SIZE) {
        std::vector<std::pair<IPAddress, int64_t>> entries;
        entries.reserve(ipCache.size());
        
        for (const auto& pair : ipCache) {
            entries.emplace_back(pair.first, pair.second.lastAttemptTime);
        }
        
        // Ordena por timestamp (mais antigo primeiro)
        std::sort(entries.begin(), entries.end(), [](const auto& a, const auto& b) {
            return a.second < b.second;
        });
        
        // Remove 20% das entradas mais antigas
        size_t removeCount = ipCache.size() / 5;
        for (size_t i = 0; i < removeCount && i < entries.size(); i++) {
            ipCache.erase(entries[i].first);
        }
    }
    
    // Se o cache de contas exceder o tamanho máximo, remove as entradas mais antigas
    if (accountCache.size() > MAX_CACHE_SIZE) {
        std::vector<std::pair<std::string, int64_t>> entries;
        entries.reserve(accountCache.size());
        
        for (const auto& pair : accountCache) {
            entries.emplace_back(pair.first, pair.second.lastAttemptTime);
        }
        
        // Ordena por timestamp (mais antigo primeiro)
        std::sort(entries.begin(), entries.end(), [](const auto& a, const auto& b) {
            return a.second < b.second;
        });
        
        // Remove 20% das entradas mais antigas
        size_t removeCount = accountCache.size() / 5;
        for (size_t i = 0; i < removeCount && i < entries.size(); i++) {
            accountCache.erase(entries[i].first);
        }
    }
}

void FloodProtection::createTablesIfNotExist() {
    try {
        Database& db = Database::getInstance();
        
        // Tabela para armazenar bloqueios
        db.executeQuery("CREATE TABLE IF NOT EXISTS `flood_blocks` ("
                       "`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, "
                       "`identifier` VARCHAR(45) NOT NULL, "
                       "`type` ENUM('ip', 'account') NOT NULL, "
                       "`block_start` BIGINT NOT NULL, "
                       "`block_duration` INT NOT NULL, "
                       "`fail_count` INT NOT NULL, "
                       "`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                       "PRIMARY KEY (`id`), "
                       "INDEX `identifier_type_idx` (`identifier`, `type`)"
                       ") ENGINE=InnoDB DEFAULT CHARSET=utf8;");
        
        // Tabela para logs de tentativas
        db.executeQuery("CREATE TABLE IF NOT EXISTS `flood_attempts_log` ("
                       "`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, "
                       "`ip` VARCHAR(45) NOT NULL, "
                       "`account` VARCHAR(32) NULL, "
                       "`character` VARCHAR(32) NULL, "
                       "`attempt_time` BIGINT NOT NULL, "
                       "`success` TINYINT(1) NOT NULL, "
                       "`block_applied` TINYINT(1) NOT NULL, "
                       "`block_duration` INT NOT NULL, "
                       "`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                       "PRIMARY KEY (`id`), "
                       "INDEX `ip_idx` (`ip`), "
                       "INDEX `account_idx` (`account`)"
                       ") ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    } catch (const std::exception& e) {
        std::cerr << "Erro ao criar tabelas para o sistema anti-flood: " << e.what() << std::endl;
    }
}

void FloodProtection::loadBlocksFromDatabase() {
    try {
        Database& db = Database::getInstance();
        std::ostringstream query;
        
        // Carrega apenas bloqueios ativos (que ainda não expiraram)
        int64_t currentTime = getCurrentTime();
        query << "SELECT `identifier`, `type`, `block_start`, `block_duration`, `fail_count` "
              << "FROM `flood_blocks` "
              << "WHERE `block_start` + `block_duration` > " << currentTime;
        
        DBResult_ptr result = db.storeQuery(query.str());
        if (!result) {
            return;
        }
        
        std::unique_lock<std::shared_mutex> lock(cacheMutex);
        
        do {
            std::string identifier = result->getString("identifier");
            std::string type = result->getString("type");
            int64_t blockStart = result->getNumber<int64_t>("block_start");
            int blockDuration = result->getNumber<int>("block_duration");
            int failCount = result->getNumber<int>("fail_count");
            
            LoginAttemptInfo info;
            info.failCount = failCount;
            info.lastAttemptTime = blockStart;
            info.blockStartTime = blockStart;
            info.blockDuration = blockDuration;
            
            if (type == "ip") {
                ipCache[IPAddress(identifier)] = info;
            } else if (type == "account") {
                accountCache[identifier] = info;
            }
        } while (result->next());
    } catch (const std::exception& e) {
        std::cerr << "Erro ao carregar bloqueios do banco de dados: " << e.what() << std::endl;
    }
}

void FloodProtection::saveBlockToDatabase(const std::string& identifier, const std::string& type, const LoginAttemptInfo& info) {
    try {
        Database& db = Database::getInstance();
        std::ostringstream query;
        
        query << "INSERT INTO `flood_blocks` (`identifier`, `type`, `block_start`, `block_duration`, `fail_count`) "
              << "VALUES (" << db.escapeString(identifier) << ", "
              << db.escapeString(type) << ", "
              << info.blockStartTime << ", "
              << info.blockDuration << ", "
              << info.failCount << ")";
        
        db.executeQuery(query.str());
    } catch (const std::exception& e) {
        std::cerr << "Erro ao salvar bloqueio no banco de dados: " << e.what() << std::endl;
    }
}

void FloodProtection::saveLoginAttemptLog(const std::string& ip, const std::string& account, const std::string& characterName, int64_t attemptTime, bool success, bool blockApplied, int blockDuration) {
    try {
        Database& db = Database::getInstance();
        std::ostringstream query;
        
        query << "INSERT INTO `flood_attempts_log` (`ip`, `account`, `character`, `attempt_time`, `success`, `block_applied`, `block_duration`) "
              << "VALUES (" << db.escapeString(ip) << ", "
              << (account.empty() ? "NULL" : db.escapeString(account)) << ", "
              << (characterName.empty() ? "NULL" : db.escapeString(characterName)) << ", "
              << attemptTime << ", "
              << (success ? "1" : "0") << ", "
              << (blockApplied ? "1" : "0") << ", "
              << blockDuration << ")";
        
        db.executeQuery(query.str());
    } catch (const std::exception& e) {
        std::cerr << "Erro ao salvar log de tentativa de login: " << e.what() << std::endl;
    }
}

// Implementação do método IOLoginData::gameWorldAuthentication com proteção anti-flood
/* bool IOLoginData::gameWorldAuthentication(const std::string &accountDescriptor, const std::string &sessionOrPassword, std::string &characterName, uint32_t &accountId, bool oldProcotol, const uint32_t ip) { */
    
	bool IOLoginData::gameWorldAuthentication(const std::string &accountDescriptor, const std::string &sessionOrPassword, std::string &characterName, uint32_t &accountId, bool oldProcotol, const uint32_t ip) {
    // Inicializa o sistema anti-flood se ainda não foi inicializado
    static bool initialized = false;
    if (!initialized) {
        FloodProtection::initialize();
        initialized = true;
    }
    
    // Resto do código...

	
	// Converte o IP para a classe IPAddress
    IPAddress ipAddress(ip);
    
    // Verifica se o IP está bloqueado
    if (FloodProtection::isIPBlocked(ipAddress)) {
        std::string blockMessage = FloodProtection::getBlockMessage(ipAddress);
        std::cout << "Login bloqueado: " << blockMessage << std::endl;
        return false;
    }
    
    // Verifica se a conta está bloqueada
    if (FloodProtection::isAccountBlocked(accountDescriptor)) {
        std::string blockMessage = FloodProtection::getBlockMessage(accountDescriptor, true);
        std::cout << "Login bloqueado: " << blockMessage << std::endl;
        return false;
    }
    
    Account account(accountDescriptor);
    account.setProtocolCompat(oldProcotol);

    if (AccountErrors_t::Ok != account.load()) {
        g_logger().error("Couldn't load account [{}].", account.getDescriptor());
        // Registra tentativa falha
        FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
        return false;
    }


/* ///comentar daqui
    if (g_configManager().getString(AUTH_TYPE) == "session") {
        if (!account.authenticate()) {
            // Registra tentativa falha
            FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
            return false;
        }
    } else {
        if (!account.authenticate(sessionOrPassword)) {
            // Registra tentativa falha
            FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
            return false;
        }
    }
//////ate aqui */	
	
	    // Verifica a autenticação (senha ou sessão)
    bool authenticated = false;
    if (g_configManager().getString(AUTH_TYPE) == "session") {
        authenticated = account.authenticate();
    } else {
        authenticated = account.authenticate(sessionOrPassword);
    }
    
    // Se a autenticação falhou, registra a tentativa falha
    if (!authenticated) {
        g_logger().error("Authentication failed for account [{}]", accountDescriptor);
        FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
        return false;
    }
	
	
	

    if (!g_accountRepository().getCharacterByAccountIdAndName(account.getID(), characterName)) {
        g_logger().warn("IP [{}] trying to connect into another account character", convertIPToString(ip));
        // Registra tentativa falha
        FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
        return false;
    }

    if (AccountErrors_t::Ok != account.load()) {
        g_logger().error("Failed to load account [{}]", accountDescriptor);
        // Registra tentativa falha
        FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
        return false;
    }

    auto [players, result] = account.getAccountPlayers();
    if (AccountErrors_t::Ok != result) {
        g_logger().error("Failed to load account [{}] players", accountDescriptor);
        // Registra tentativa falha
        FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
        return false;
    }

    if (players[characterName] != 0) {
        g_logger().error("Account [{}] player [{}] not found or deleted.", accountDescriptor, characterName);
        // Registra tentativa falha
        FloodProtection::recordFailedAttempt(ipAddress, accountDescriptor);
        return false;
    }

    accountId = account.getID();
    
    // Registra login bem-sucedido
    FloodProtection::recordSuccessfulLogin(ipAddress, accountDescriptor);
    return true;
}

uint8_t IOLoginData::getAccountType(uint32_t accountId) {
    std::ostringstream query;
    query << "SELECT `type` FROM `accounts` WHERE `id` = " << accountId;
    DBResult_ptr result = Database::getInstance().storeQuery(query.str());
    if (!result) {
        return ACCOUNT_TYPE_NORMAL;
    }

    return result->getNumber<uint8_t>("type");
}

// The boolean "disableIrrelevantInfo" will deactivate the loading of information that is not relevant to the preload, for example, forge, bosstiary, etc. None of this we need to access if the player is offline
bool IOLoginData::loadPlayerById(const std::shared_ptr<Player> &player, uint32_t id, bool disableIrrelevantInfo /* = true*/) {
    Database &db = Database::getInstance();
    std::ostringstream query;
    query << "SELECT * FROM `players` WHERE `id` = " << id;
    return loadPlayer(player, db.storeQuery(query.str()), disableIrrelevantInfo);
}

bool IOLoginData::loadPlayerByName(const std::shared_ptr<Player> &player, const std::string &name, bool disableIrrelevantInfo /* = true*/) {
    Database &db = Database::getInstance();
    std::ostringstream query;
    query << "SELECT * FROM `players` WHERE `name` = " << db.escapeString(name);
    return loadPlayer(player, db.storeQuery(query.str()), disableIrrelevantInfo);
}

bool IOLoginData::loadPlayer(const std::shared_ptr<Player> &player, const DBResult_ptr &result, bool disableIrrelevantInfo /* = false*/) {
    if (!result || !player) {
        std::string nullptrType = !result ? "Result" : "Player";
        g_logger().warn("[{}] - {} is nullptr", __FUNCTION__, nullptrType);
        return false;
    }

    try {
        // First
        if (!IOLoginDataLoad::loadPlayerBasicInfo(player, result)) {
            g_logger().warn("[{}] - Failed to load player basic info", __FUNCTION__);
            return false;
        }

        // Experience load
        IOLoginDataLoad::loadPlayerExperience(player, result);

        // Blessings load
        IOLoginDataLoad::loadPlayerBlessings(player, result);

        // load conditions
        IOLoginDataLoad::loadPlayerConditions(player, result);

        // load animus mastery
        IOLoginDataLoad::loadPlayerAnimusMastery(player, result);

        // load default outfit
        IOLoginDataLoad::loadPlayerDefaultOutfit(player, result);

        // skull system load
        IOLoginDataLoad::loadPlayerSkullSystem(player, result);

        // skill load
        IOLoginDataLoad::loadPlayerSkill(player, result);

        // kills load
        IOLoginDataLoad::loadPlayerKills(player, result);

        // guild load
        IOLoginDataLoad::loadPlayerGuild(player, result);

        // stash load items
        IOLoginDataLoad::loadPlayerStashItems(player, result);

        // bestiary charms
        IOLoginDataLoad::loadPlayerBestiaryCharms(player, result);

        // load inventory items
        IOLoginDataLoad::loadPlayerInventoryItems(player, result);

        // store Inbox
        IOLoginDataLoad::loadPlayerStoreInbox(player);

        // load depot items
        IOLoginDataLoad::loadPlayerDepotItems(player, result);

        // load reward items
        IOLoginDataLoad::loadRewardItems(player);

        // load inbox items
        IOLoginDataLoad::loadPlayerInboxItems(player, result);

        // load storage map
        IOLoginDataLoad::loadPlayerStorageMap(player, result);

        // load vip
        IOLoginDataLoad::loadPlayerVip(player, result);

        // load prey class
        IOLoginDataLoad::loadPlayerPreyClass(player, result);

        // Load task hunting class
        IOLoginDataLoad::loadPlayerTaskHuntingClass(player, result);

        // Load instant spells list
        IOLoginDataLoad::loadPlayerInstantSpellList(player, result);
		// load weapon proficiency
		IOLoginDataLoad::loadPlayerWeaponProficiency(player, result); // Summer Update 2025

        if (!disableIrrelevantInfo) {
            // Load additional data only if the player is online (e.g., forge, bosstiary)
            loadOnlyDataForOnlinePlayer(player, result);
        }

        return true;
    } catch (const std::system_error &error) {
        g_logger().warn("[{}] Error while load player: {}", __FUNCTION__, error.what());
        return false;
    } catch (const std::exception &e) {
        g_logger().warn("[{}] Error while load player: {}", __FUNCTION__, e.what());
        return false;
    }
}

void IOLoginData::loadOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player, const DBResult_ptr &result) {
    IOLoginDataLoad::loadPlayerForgeHistory(player, result);
    IOLoginDataLoad::loadPlayerBosstiary(player, result);
    IOLoginDataLoad::loadPlayerInitializeSystem(player);
    IOLoginDataLoad::loadPlayerUpdateSystem(player);
}

bool IOLoginData::savePlayer(const std::shared_ptr<Player> &player) {
    try {
        bool success = DBTransaction::executeWithinTransaction([player]() {
            return savePlayerGuard(player);
        });

        if (!success) {
            g_logger().error("[{}] Error occurred saving player", __FUNCTION__);
        }

        return success;
    } catch (const DatabaseException &e) {
        g_logger().error("[{}] Exception occurred: {}", __FUNCTION__, e.what());
    }

    return false;
}

bool IOLoginData::savePlayerGuard(const std::shared_ptr<Player> &player) {
    if (!player) {
        throw DatabaseException("Player nullptr in function: " + std::string(__FUNCTION__));
    }

    if (!IOLoginDataSave::savePlayerFirst(player)) {
        throw DatabaseException("[" + std::string(__FUNCTION__) + "] - Failed to save player first: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerStash(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerFirst] - Failed to save player stash: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerSpells(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerSpells] - Failed to save player spells: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerKills(player)) {
        throw DatabaseException("IOLoginDataSave::savePlayerKills] - Failed to save player kills: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerBestiarySystem(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerBestiarySystem] - Failed to save player bestiary system: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerItem(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerItem] - Failed to save player item: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerDepotItems(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerDepotItems] - Failed to save player depot items: " + player->getName());
    }

    if (!IOLoginDataSave::saveRewardItems(player)) {
        throw DatabaseException("[IOLoginDataSave::saveRewardItems] - Failed to save player reward items: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerInbox(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerInbox] - Failed to save player inbox: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerPreyClass(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerPreyClass] - Failed to save player prey class: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerTaskHuntingClass(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerTaskHuntingClass] - Failed to save player task hunting class: " + player->getName());
    }

    // Saves data components that are only valid if the player is online.
    // Skips execution entirely if the player is offline to avoid overwriting unloaded data.
    saveOnlyDataForOnlinePlayer(player);

    return true;
}

void IOLoginData::saveOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player) {
    if (player->isOffline()) {
        return;
    }

    if (!IOLoginDataSave::savePlayerForgeHistory(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerForgeHistory] - Failed to save player forge history: " + player->getName());
    }

    if (!IOLoginDataSave::savePlayerBosstiary(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerBosstiary] - Failed to save player bosstiary: " + player->getName());
    }

    if (!player->wheel().saveDBPlayerSlotPointsOnLogout()) {
        throw DatabaseException("[PlayerWheel::saveDBPlayerSlotPointsOnLogout] - Failed to save player wheel info: " + player->getName());
    }

    player->wheel().saveRevealedGems();
    player->wheel().saveActiveGems();
    player->wheel().saveKVModGrades();
    player->wheel().saveKVPromotionScrolls();

    if (!IOLoginDataSave::savePlayerStorage(player)) {
        throw DatabaseException("[IOLoginDataSave::savePlayerStorage] - Failed to save player storage: " + player->getName());
    }
}

std::string IOLoginData::getNameByGuid(uint32_t guid) {
    std::ostringstream query;
    query << "SELECT `name` FROM `players` WHERE `id` = " << guid;
    DBResult_ptr result = Database::getInstance().storeQuery(query.str());
    if (!result) {
        return {};
    }
    return result->getString("name");
}

uint32_t IOLoginData::getGuidByName(const std::string &name) {
    Database &db = Database::getInstance();

    std::ostringstream query;
    query << "SELECT `id` FROM `players` WHERE `name` = " << db.escapeString(name);
    DBResult_ptr result = db.storeQuery(query.str());
    if (!result) {
        return 0;
    }
    return result->getNumber<uint32_t>("id");
}

bool IOLoginData::getGuidByNameEx(uint32_t &guid, bool &specialVip, std::string &name) {
    Database &db = Database::getInstance();

    std::ostringstream query;
    query << "SELECT `name`, `id`, `group_id`, `account_id` FROM `players` WHERE `name` = " << db.escapeString(name);
    DBResult_ptr result = db.storeQuery(query.str());
    if (!result) {
        return false;
    }

    name = result->getString("name");
    guid = result->getNumber<uint32_t>("id");
    if (auto group = g_game().groups.getGroup(result->getNumber<uint16_t>("group_id"))) {
        specialVip = group->flags[Groups::getFlagNumber(PlayerFlags_t::SpecialVIP)];
    } else {
        specialVip = false;
    }
    return true;
}

bool IOLoginData::formatPlayerName(std::string &name) {
    Database &db = Database::getInstance();

    std::ostringstream query;
    query << "SELECT `name` FROM `players` WHERE `name` = " << db.escapeString(name);

    DBResult_ptr result = db.storeQuery(query.str());
    if (!result) {
        return false;
    }

    name = result->getString("name");
    return true;
}

void IOLoginData::increaseBankBalance(uint32_t guid, uint64_t bankBalance) {
    std::ostringstream query;
    query << "UPDATE `players` SET `balance` = `balance` + " << bankBalance << " WHERE `id` = " << guid;
    Database::getInstance().executeQuery(query.str());
}

std::vector<VIPEntry> IOLoginData::getVIPEntries(uint32_t accountId) {
    std::string query = fmt::format("SELECT `player_id`, (SELECT `name` FROM `players` WHERE `id` = `player_id`) AS `name`, `description`, `icon`, `notify` FROM `account_viplist` WHERE `account_id` = {}", accountId);
    std::vector<VIPEntry> entries;

    if (const auto &result = Database::getInstance().storeQuery(query)) {
        entries.reserve(result->countResults());
        do {
            entries.emplace_back(
                result->getNumber<uint32_t>("player_id"),
                result->getString("name"),
                result->getString("description"),
                result->getNumber<uint32_t>("icon"),
                result->getNumber<uint16_t>("notify") != 0
            );
        } while (result->next());
    }

    return entries;
}

void IOLoginData::addVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
    std::string query = fmt::format("INSERT INTO `account_viplist` (`account_id`, `player_id`, `description`, `icon`, `notify`) VALUES ({}, {}, {}, {}, {})", accountId, guid, g_database().escapeString(description), icon, notify);
    if (!g_database().executeQuery(query)) {
        g_logger().error("Failed to add VIP entry for account {}. QUERY: {}", accountId, query.c_str());
    }
}

void IOLoginData::editVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify) {
    std::string query = fmt::format("UPDATE `account_viplist` SET `description` = {}, `icon` = {}, `notify` = {} WHERE `account_id` = {} AND `player_id` = {}", g_database().escapeString(description), icon, notify, accountId, guid);
    if (!g_database().executeQuery(query)) {
        g_logger().error("Failed to edit VIP entry for account {}. QUERY: {}", accountId, query.c_str());
    }
}

void IOLoginData::removeVIPEntry(uint32_t accountId, uint32_t guid) {
    std::string query = fmt::format("DELETE FROM `account_viplist` WHERE `account_id` = {} AND `player_id` = {}", accountId, guid);
    g_database().executeQuery(query);
}

std::vector<VIPGroupEntry> IOLoginData::getVIPGroupEntries(uint32_t accountId, uint32_t guid) {
    std::string query = fmt::format("SELECT `id`, `name`, `customizable` FROM `account_vipgroups` WHERE `account_id` = {}", accountId);

    std::vector<VIPGroupEntry> entries;

    if (const auto &result = g_database().storeQuery(query)) {
        entries.reserve(result->countResults());

        do {
            entries.emplace_back(
                result->getNumber<uint8_t>("id"),
                result->getString("name"),
                result->getNumber<uint8_t>("customizable") == 0 ? false : true
            );
        } while (result->next());
    }
    return entries;
}

void IOLoginData::addVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
    std::string query = fmt::format("INSERT INTO `account_vipgroups` (`id`, `account_id`, `name`, `customizable`) VALUES ({}, {}, {}, {})", groupId, accountId, g_database().escapeString(groupName), customizable);
    if (!g_database().executeQuery(query)) {
        g_logger().error("Failed to add VIP Group entry for account {} and group {}. QUERY: {}", accountId, groupId, query.c_str());
    }
}

void IOLoginData::editVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable) {
    std::string query = fmt::format("UPDATE `account_vipgroups` SET `name` = {}, `customizable` = {} WHERE `id` = {} AND `account_id` = {}", g_database().escapeString(groupName), customizable, groupId, accountId);
    if (!g_database().executeQuery(query)) {
        g_logger().error("Failed to update VIP Group entry for account {} and group {}. QUERY: {}", accountId, groupId, query.c_str());
    }
}

void IOLoginData::removeVIPGroupEntry(uint8_t groupId, uint32_t accountId) {
    std::string query = fmt::format("DELETE FROM `account_vipgroups` WHERE `id` = {} AND `account_id` = {}", groupId, accountId);
    g_database().executeQuery(query);
}

void IOLoginData::addGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId, uint32_t guid) {
    std::string query = fmt::format("INSERT INTO `account_vipgroups_players` (`account_id`, `player_id`, `group_id`) VALUES ({}, {}, {})", accountId, guid, groupId);
    if (!g_database().executeQuery(query)) {
        g_logger().error("Failed to add VIP Group player entry for account {} and group {}. QUERY: {}", accountId, groupId, query.c_str());
    }
}

// Implementação da versão com 2 parâmetros (compatibilidade retroativa)
void IOLoginData::removeGuidVIPGroupEntry(uint32_t accountId, uint32_t guid) {
    // Chama a versão com 3 parâmetros, usando 0 como valor padrão para groupId
    removeGuidVIPGroupEntry(0, accountId, guid);
}

// Implementação da versão com 3 parâmetros
void IOLoginData::removeGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId, uint32_t guid) {
    std::string query = fmt::format("DELETE FROM `account_vipgroups_players` WHERE `account_id` = {} AND `player_id` = {}", accountId, guid);
    if (groupId > 0) {
        query += fmt::format(" AND `group_id` = {}", static_cast<uint32_t>(groupId));
    }
    g_database().executeQuery(query);
}

std::vector<uint32_t> IOLoginData::getGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId) {
    std::string query = fmt::format("SELECT `player_id` FROM `account_vipgroups_players` WHERE `account_id` = {} AND `group_id` = {}", accountId, groupId);

    std::vector<uint32_t> entries;

    if (const auto &result = g_database().storeQuery(query)) {
        entries.reserve(result->countResults());

        do {
            entries.push_back(result->getNumber<uint32_t>("player_id"));
        } while (result->next());
    }

    return entries;
}

uint8_t IOLoginData::getVIPGroupID(uint32_t accountId, uint32_t guid) {
    std::string query = fmt::format("SELECT `group_id` FROM `account_vipgroups_players` WHERE `account_id` = {} AND `player_id` = {}", accountId, guid);

    if (const auto &result = g_database().storeQuery(query)) {
        return result->getNumber<uint8_t>("group_id");
    }
    return 0;
}

// Inicializa o sistema anti-flood quando o servidor é iniciado
/* struct FloodProtectionInitializer {
    FloodProtectionInitializer() {
        FloodProtection::initialize();
    }
}; */

// Instância estática para garantir inicialização
/* static FloodProtectionInitializer g_floodProtectionInitializer; */
