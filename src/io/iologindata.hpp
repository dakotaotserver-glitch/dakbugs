/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <array>
#include <chrono>
#include <list>
#include <mutex>
#include <shared_mutex>
#include <string>
#include <unordered_map>

class Player;
class Item;
class DBResult;

struct VIPEntry;
struct VIPGroupEntry;

using ItemBlockList = std::list<std::pair<int32_t, std::shared_ptr<Item>>>;

/**
 * @class IPAddress
 * @brief Classe unificada para representar endereços IPv4 e IPv6
 */
class IPAddress {
public:
	// Construtor para IPv4
	explicit IPAddress(uint32_t ipv4);
	
	// Construtor para IPv6
	explicit IPAddress(const std::array<uint8_t, 16>& ipv6);
	
	// Construtor a partir de string
	explicit IPAddress(const std::string& ipString);
	
	// Operadores de comparação
	bool operator==(const IPAddress& other) const;
	bool operator!=(const IPAddress& other) const;
	
	// Converte para string
	std::string toString() const;
	
	// Função de hash para uso em unordered_map
	struct Hash {
		size_t operator()(const IPAddress& ip) const;
	};
	
private:
	bool isIPv6;
	uint32_t ipv4Address;
	std::array<uint8_t, 16> ipv6Address;
};

/**
 * @class FloodProtection
 * @brief Sistema avançado de proteção contra flood de login
 * 
 * Implementa proteção contra ataques de força bruta e tentativas excessivas de login,
 * com bloqueio progressivo, múltiplas janelas de rate limiting e persistência em banco de dados.
 */
class FloodProtection {
public:
	// Estrutura para armazenar informações de tentativas de login
	struct LoginAttemptInfo {
		int failCount = 0;
		int64_t lastAttemptTime = 0;
		int64_t blockStartTime = 0;
		int blockDuration = 0;
		std::list<int64_t> recentAttempts;
		
		// Verifica se o IP está bloqueado
		bool isBlocked(int64_t currentTime) const;
		
		// Calcula o tempo restante de bloqueio em segundos
		int getRemainingBlockTime(int64_t currentTime) const;
		
		// Verifica se excede o limite de tentativas em uma janela de tempo
		bool exceedsRateLimit(int64_t currentTime, int windowSeconds, int maxAttempts) const;
	};
	
	// Inicializa o sistema
	static void initialize();
	
	// Verifica se um IP está bloqueado
	static bool isIPBlocked(const IPAddress& ip);
	
	// Verifica se uma conta está bloqueada
	static bool isAccountBlocked(const std::string& accountName);
	
	// Registra uma tentativa de login falha
	static void recordFailedAttempt(const IPAddress& ip, const std::string& accountName);
	
	// Registra um login bem-sucedido
	static void recordSuccessfulLogin(const IPAddress& ip, const std::string& accountName);
	
	// Obtém mensagem de bloqueio para o usuário
	static std::string getBlockMessage(const IPAddress& ip);
	
	// Sobrecarga para contas
	static std::string getBlockMessage(const std::string& accountName, bool isAccount);
	
	// Limpa entradas antigas do cache
	static void cleanupOldEntries();
	
	// Obtém estatísticas do sistema
	static std::string getStatistics();
	
private:
	// Cache de informações de tentativas de login
	static std::unordered_map<IPAddress, LoginAttemptInfo, IPAddress::Hash> ipCache;
	static std::unordered_map<std::string, LoginAttemptInfo> accountCache;
	static std::shared_mutex cacheMutex;
	
	// Obtém o tempo atual em segundos
	static int64_t getCurrentTime();
	
	// Atualiza informações de tentativa de login
	static void updateLoginAttemptInfo(LoginAttemptInfo& info, int64_t currentTime, bool success);
	
	// Garante que o cache não exceda o tamanho máximo
	static void ensureCacheSize();
	
	// Cria tabelas necessárias se não existirem
	static void createTablesIfNotExist();
	
	// Carrega bloqueios existentes do banco de dados
	static void loadBlocksFromDatabase();
	
	// Salva um bloqueio no banco de dados
	static void saveBlockToDatabase(const std::string& identifier, const std::string& type, const LoginAttemptInfo& info);
	
	// Salva um log de tentativa de login
	static void saveLoginAttemptLog(const std::string& ip, const std::string& account, const std::string& characterName, int64_t attemptTime, bool success, bool blockApplied, int blockDuration);
	
	// Configurações do sistema
	static constexpr int SHORT_WINDOW_SECONDS = 60;
	static constexpr int SHORT_WINDOW_MAX_ATTEMPTS = 10;
	
	static constexpr int MEDIUM_WINDOW_SECONDS = 300; // 5 minutos
	static constexpr int MEDIUM_WINDOW_MAX_ATTEMPTS = 20;
	
	static constexpr int LONG_WINDOW_SECONDS = 3600; // 1 hora
	static constexpr int LONG_WINDOW_MAX_ATTEMPTS = 50;
	
	static constexpr int INITIAL_BLOCK_DURATION = 300; // 5 minutos
	static constexpr int MAX_BLOCK_DURATION = 86400; // 24 horas
	static constexpr float BLOCK_DURATION_MULTIPLIER = 3.0f;
	
	// Tamanho máximo do cache
	static constexpr size_t MAX_CACHE_SIZE = 10000;
};

class IOLoginData {
public:
	static bool gameWorldAuthentication(const std::string &accountDescriptor, const std::string &sessionOrPassword, std::string &characterName, uint32_t &accountId, bool oldProcotol, const uint32_t ip);
	static uint8_t getAccountType(uint32_t accountId);
	static bool loadPlayerById(const std::shared_ptr<Player> &player, uint32_t id, bool disableIrrelevantInfo = true);
	static bool loadPlayerByName(const std::shared_ptr<Player> &player, const std::string &name, bool disableIrrelevantInfo = true);
	static bool loadPlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<DBResult> &result, bool disableIrrelevantInfo = false);
	
	/**
	 * @brief Loads data components that are only relevant when the player is online.
	 *
	 * This function is responsible for initializing systems that are not needed when the player is offline,
	 * such as the forge history, bosstiary, and various runtime systems.
	 *
	 * If the player is offline, this function returns early and avoids loading these systems.
	 * This helps optimize memory usage and prevents unnecessary initialization of unused features.
	 *
	 * @param player A shared pointer to the Player instance. Must not be nullptr.
	 * @param result The database result containing the player's data.
	 */
	static void loadOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<DBResult> &result);

	static bool savePlayer(const std::shared_ptr<Player> &player);

	/**
	 * @brief Saves data components that are only relevant when the player is online.
	 *
	 * This function is responsible for persisting player-related systems that are only loaded
	 * when the player is online, such as the forge history, bosstiary progress, and wheel data.
	 *
	 * If the player is offline, this function will return immediately without performing any save operations.
	 * This prevents overwriting existing database values with empty or uninitialized data that may result
	 * from partial player loading (common during offline operations).
	 *
	 * @note This function throws DatabaseException if any of the internal save operations fail.
	 * It should be called after all always-loaded data has been saved.
	 *
	 * @param player A shared pointer to the Player instance. Must not be nullptr.
	 */
	static void saveOnlyDataForOnlinePlayer(const std::shared_ptr<Player> &player);
	static uint32_t getGuidByName(const std::string &name);
	static bool getGuidByNameEx(uint32_t &guid, bool &specialVip, std::string &name);
	static std::string getNameByGuid(uint32_t guid);
	static bool formatPlayerName(std::string &name);
	static void increaseBankBalance(uint32_t guid, uint64_t bankBalance);

	static std::vector<VIPEntry> getVIPEntries(uint32_t accountId);
	static void addVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify);
	static void editVIPEntry(uint32_t accountId, uint32_t guid, const std::string &description, uint32_t icon, bool notify);
	static void removeVIPEntry(uint32_t accountId, uint32_t guid);

	static std::vector<VIPGroupEntry> getVIPGroupEntries(uint32_t accountId, uint32_t guid);
	static void addVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable);
	static void editVIPGroupEntry(uint8_t groupId, uint32_t accountId, const std::string &groupName, bool customizable);
	static void removeVIPGroupEntry(uint8_t groupId, uint32_t accountId);
	static void addGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId, uint32_t guid);
	static void removeGuidVIPGroupEntry(uint32_t accountId, uint32_t guid);
	static void removeGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId, uint32_t guid);
	static std::vector<uint32_t> getGuidVIPGroupEntry(uint8_t groupId, uint32_t accountId);
	static uint8_t getVIPGroupID(uint32_t accountId, uint32_t guid);

private:
	static bool savePlayerGuard(const std::shared_ptr<Player> &player);
};
