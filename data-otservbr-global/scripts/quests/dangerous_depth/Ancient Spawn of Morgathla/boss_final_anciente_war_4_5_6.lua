local config = {
    bossName = "Ancient Spawn of Morgathla",
    requiredLevel = 250,
    timeToFightAgain = 20, -- Tempo de espera entre batalhas (em horas)
    destination = Position(33719, 32379, 15), -- Posição de destino dentro da sala do boss
    exitPosition = Position(33696, 32390, 15), -- Posição de saída caso não atenda aos requisitos
}

-- Definição da área de verificação para saber se há jogadores presentes
local areaFromPosition = Position(33703, 32325, 15)
local areaToPosition = Position(33800, 32387, 15)

-- Definição das posições de entrada para o evento
local entrancesTiles = {
    { x = 33693, y = 32385, z = 15 },
}

-- Configuração da zona do boss e encontro
local zone = Zone("boss." .. toKey(config.bossName))
local encounter = Encounter("Ancient Spawn of Morgathla", {
    zone = zone,
    timeToSpawnMonsters = "50ms", -- Intervalo de tempo para criação de monstros
})

zone:blockFamiliars()
zone:setRemoveDestination(config.exitPosition)

local locked = false -- Inicialmente desbloqueado

-- Função para verificar se há jogadores na área especificada
local function arePlayersInArea()
    local playersInArea = Game.getPlayersInArea(areaFromPosition, areaToPosition)
    return #playersInArea > 0 -- Retorna true se houver jogadores, false caso contrário
end

-- Adiciona os estágios do encontro
encounter:addRemoveMonsters():autoAdvance()
encounter:addBroadcast("You've entered the Ancient Spawn of Morgathla's lair. Prepare yourself!"):autoAdvance()

-- Primeiro estágio: Bloqueia a entrada de novos jogadores durante a batalha e espera 20 segundos
encounter:addStage({
    start = function()
        locked = true -- Bloqueia a entrada de outros jogadores durante a batalha
        --print("A sala foi bloqueada.")
    end,
}):autoAdvance("20s") -- Espera 20 segundos antes de avançar para o próximo estágio

-- Segundo estágio: Criar os Burrowing Beetles após 20 segundos
encounter:addSpawnMonsters({
    {
        name = "Burrowing Beetle",
        positions = {
            Position(33718, 32372, 15),
        },
    },
}):autoAdvance("40s") -- Aguarda mais 40 segundos antes de avançar para o próximo estágio (total de 60 segundos)

-- Terceiro estágio: Criar o boss "Ancient Spawn of Morgathla" após 60 segundos no total
encounter:addSpawnMonsters({
    {
        name = "Ancient Spawn of Morgathla", -- Nome do boss principal
        positions = {
            Position(33719, 32379, 15), -- Posição central onde ele vai aparecer
        },
    },
}):autoAdvance("10s") -- Aguarda 270 segundos antes de avançar para a remoção dos jogadores

-- Remoção de jogadores no fim do encontro, com o reset do estado do encontro
encounter:addRemovePlayers({
    onEnd = function()
        -- Libera a entrada novamente e reseta o estado do encontro
        locked = false -- Garantia de destrancar
      --  print("A sala foi destrancada após o fim do encontro.")
        encounter:reset()
    end
}):autoAdvance()

-- Verificação automática de jogadores na área e destrancamento da sala se estiver vazia


-- Inicia o encontro ao entrar na zona
encounter:startOnEnter()
encounter:register()

-- Função de teleporte para verificar condições e iniciar o encontro
local teleportBoss = MoveEvent()
function teleportBoss.onStepIn(creature, item, position, fromPosition)
    if not creature or not creature:isPlayer() then
        return false
    end
    local player = creature
    if player:getLevel() < config.requiredLevel then
        player:teleportTo(config.exitPosition, true)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be level " .. config.requiredLevel .. " or higher.")
        return true
    end


    -- Verifica se há jogadores demais na sala
    if zone:countPlayers(IgnoredByMonsters) >= 50 then
        player:teleportTo(config.exitPosition, true)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The boss room is full.")
        return false
    end

    -- Verifica o cooldown do boss
    local timeLeft = player:getBossCooldown(config.bossName) - os.time()
    if timeLeft > 0 then
        player:teleportTo(config.exitPosition, true)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. getTimeInWords(timeLeft) .. " to face " .. config.bossName .. " again!")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    -- Teleporta o jogador e inicia o encontro
    player:teleportTo(config.destination)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    player:setBossCooldown(config.bossName, os.time() + config.timeToFightAgain * 3600)
    player:sendBosstiaryCooldownTimer()
    encounter:start()  -- Inicia o encontro, criando os monstros
end

-- Registrando as posições de entrada para o novo boss
for _, registerPosition in ipairs(entrancesTiles) do
    teleportBoss:position(Position(registerPosition.x, registerPosition.y, registerPosition.z))
end

teleportBoss:type("stepin")
teleportBoss:register()
