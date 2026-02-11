local config = {
    teleportId = 10842,
    days = {
        ["Monday"] = {Position(32628, 32329, 7), Position(32636, 32307, 8)},
    },
    bossPosition = Position(32636, 32307, 8),
    bossName     = 'Anmothra',
    maxPlayers   = 1, -- Máximo de jogadores permitidos (1 jogador)
    portalDuration = 60 * 60 * 1000 -- Duração do portal em milissegundos (30 minutos)
}

local playerCount = 0
local teleport = nil
local randomSpawnTime = nil

local spawnAnmothraEvent = GlobalEvent("SpawnAnmothraEvent")

-- Função para gerar um horário aleatório
local function generateRandomTime()
    local hour = math.random(0, 23)
    local minute = math.random(0, 59)
    return string.format("%02d:%02d", hour, minute)
end

-- Gera o horário aleatório ao iniciar o servidor
randomSpawnTime = generateRandomTime()
--print("[Anmothra Event] Horário aleatório definido para: " .. randomSpawnTime)

function spawnAnmothraEvent.onTime(interval, lastExecution)
    local currentDay = os.date("%A")
    local currentTime = os.date("%H:%M")

    if currentDay == "Monday" and currentTime == randomSpawnTime then
        local day = config.days["Monday"]

        -- Cria o teleporte na posição especificada
        teleport = Game.createItem(config.teleportId, 1, day[1])
        if teleport then
            teleport:setActionId(60000) -- Define o Action ID para controle de acesso

            -- Mensagem para todos os jogadores informando sobre o portal
            Game.broadcastMessage('O Portal da Anmothra Esta Aberto!', MESSAGE_EVENT_ADVANCE)

            -- Remove o teleporte após 30 minutos se ainda não tiver sido removido
            addEvent(function()
                if teleport then
                    teleport:remove()
                    Game.broadcastMessage('O Portal da Anmothra Desapareceu!', MESSAGE_EVENT_ADVANCE)
                    playerCount = 0 -- Reinicia o contador de jogadores
                end
            end, config.portalDuration)
        end

        -- Cria o boss após 5 segundos
        addEvent(function()
            Game.createMonster(config.bossName, config.bossPosition, false, true)
            Game.broadcastMessage(config.bossName .. ' I have returned to reclaim my domain!', MESSAGE_EVENT_ADVANCE)
        end, 5000)

        -- Reseta o horário aleatório para a próxima segunda-feira
        randomSpawnTime = generateRandomTime()
       -- print("[Anmothra Event] Novo horario aleatorio definido para a próxima segunda-feira: " .. randomSpawnTime)
    end
    return true
end

spawnAnmothraEvent:interval(60000) -- Verifica a cada minuto
spawnAnmothraEvent:register()

-- Função para controlar o acesso ao teleporte

local tele = MoveEvent()

function tele.onStepIn(player, item, position, fromPosition)
    if item:getActionId() == 60000 then
        if playerCount < config.maxPlayers then
            playerCount = playerCount + 1
            player:teleportTo(config.days["Monday"][2]) -- Teleporta o jogador para o destino correto
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

            -- Remove o teleporte após o primeiro jogador passar
            item:remove()
            Game.broadcastMessage('O Portal da Anmothra Foi Selado!', MESSAGE_EVENT_ADVANCE)
        else
            player:teleportTo(fromPosition)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only one player can enter this portal!")
        end
        return true
    end
    return false
end

tele:type("stepin")
tele:aid(60000)
tele:register()
