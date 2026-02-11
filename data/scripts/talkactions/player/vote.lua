-- data/talkactions/scripts/player/vote.lua
-- Sistema de Votacao: Double XP, Double Loot, Double Skill com comandos /votar, /statusvoto e /endvote

-- local CHECK_INTERVAL = 2 * 60 * 60    -- checa a cada 2 horas (em segundos)

-- Configuracoes
local DATA_FILE      = "data/vote_data.json"
local CHECK_INTERVAL = 4 * 60 * 60    -- checa a cada 4 horas (em segundos)
local EVENTS = {
  [1] = { name = "Double XP",    rateVar = "SCHEDULE_EXP_RATE",   duration = 1800 },  -- 30 min
  [2] = { name = "Double Loot",  rateVar = "SCHEDULE_LOOT_RATE",  duration = 900  },  -- 15 min
  [3] = { name = "Double Skill", rateVar = "SCHEDULE_SKILL_RATE", duration = 3600 },  -- 1 hora
}

-- Estado interno
local state = {
  votes         = {},
  counts        = {},
  totalVotes    = 0,
  active        = false,
  activeEventId = nil,
  endTime       = nil,
}

for id in pairs(EVENTS) do
  state.counts[id] = 0
end

-- JSON minimo para persistencia
local function serialize(o)
  if type(o) == "number" or type(o) == "boolean" then
    return tostring(o)
  elseif type(o) == "string" then
    return string.format('%q', o)
  elseif type(o) == "table" then
    local s = "{"
    for k, v in pairs(o) do
      s = s .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
    end
    return s .. "}"
  end
  return "null"
end

local function deserialize(s)
  local f = load("return " .. s)
  if not f then return nil end
  return f()
end

-- Persistencia
local function saveState()
  local f = io.open(DATA_FILE, "w")
  if f then
    f:write(serialize(state))
    f:close()
  end
end

-- Ao terminar um boost, restaura estado e rates
local function endCurrentBoost()
  if not state.activeEventId or not state.endTime then return end
  local ev = EVENTS[state.activeEventId]

  -- Restaura todas as rates para 100%
  for _, e in pairs(EVENTS) do
    _G[e.rateVar] = 100
  end

  Game.broadcastMessage(
    ("Evento %s finalizado."):format(ev.name),
    MESSAGE_GAME_HIGHLIGHT
  )

  -- Reseta estado
  state.active        = false
  state.activeEventId = nil
  state.endTime       = nil
  state.votes         = {}
  state.totalVotes    = 0
  for k in pairs(state.counts) do
    state.counts[k] = 0
  end

  saveState()
  Game.broadcastMessage(
    "Nova votacao disponivel! Use /votar para participar.",
    MESSAGE_GAME_HIGHLIGHT
  )
end

-- Carrega estado e, se houver boost ativo, reprograma seu fim
local function loadState()
  local f = io.open(DATA_FILE, "r")
  if f then
    local content = f:read("*a")
    f:close()
    local tbl = deserialize(content)
    if type(tbl) == "table" then
      state = tbl
    end
  end
  for id in pairs(EVENTS) do
    state.counts[id] = state.counts[id] or 0
  end

  if state.active and state.endTime then
    local remaining = state.endTime - os.time()
    if remaining > 0 then
      addEvent(endCurrentBoost, remaining * 1000)
    else
      endCurrentBoost()
    end
  end
end

-- Formata tempo legivel
local function formatTime(sec)
  return math.floor(sec / 60) .. "m"
end

-- Aplica boost e agenda termino
local function applyBoost(eventId)
  local ev       = EVENTS[eventId]
  local duration = ev.duration

  state.active        = true
  state.activeEventId = eventId
  state.endTime       = os.time() + duration

  _G[ev.rateVar] = 200
  Game.broadcastMessage(
    ("Evento %s ativado! Dura %s."):format(ev.name, formatTime(duration)),
    MESSAGE_GAME_HIGHLIGHT
  )

  saveState()
  addEvent(endCurrentBoost, duration * 1000)
end

-- Escolhe vencedor (com desempate aleatorio)
local function chooseWinner()
  if state.active or state.totalVotes < 1 then return end

  local bestCount = -1
  for _, cnt in pairs(state.counts) do
    if cnt > bestCount then
      bestCount = cnt
    end
  end

  local winners = {}
  for id, cnt in pairs(state.counts) do
    if cnt == bestCount then
      table.insert(winners, id)
    end
  end

  local bestId = winners[math.random(#winners)]
  applyBoost(bestId)
end

-- Loop periodico
local function periodicCheck()
  chooseWinner()
  addEvent(periodicCheck, CHECK_INTERVAL * 1000)
end

-- Registro de voto
local function registerVote(player, eventId)
  if state.active then
    return false, "Evento em andamento, aguarde ate encerrar."
  end
  local pid = player:getId()
  if state.votes[pid] then
    return false, "Voce ja votou nesta rodada."
  end
  state.votes[pid]       = eventId
  state.counts[eventId]  = state.counts[eventId] + 1
  state.totalVotes       = state.totalVotes + 1
  saveState()
  return true, ("Voto para %s registrado!"):format(EVENTS[eventId].name)
end

-- Interface modal de votacao
local MODAL_ID = 2000
local function showVoteWindow(player)
  local mw = ModalWindow(MODAL_ID, "Votacao de Evento", "Escolha o evento desejado:")
  for id, ev in pairs(EVENTS) do
    mw:addChoice(id, ev.name)
  end
  mw:addButton(100, "Votar")
  mw:addButton(101, "Cancelar")
  mw:sendToPlayer(player)
  player:registerEvent("ModalWindowChoice")
end

local modalEvt = CreatureEvent("ModalWindowChoice")
function modalEvt.onModalWindow(player, windowId, buttonId, choiceId)
  if windowId ~= MODAL_ID then return false end
  if buttonId == 100 and EVENTS[choiceId] then
    local ok, msg = registerVote(player, choiceId)
    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, msg)
  end
  return true
end
modalEvt:register()

-- Comando /votar
local voteAction = TalkAction("/votar")
voteAction:separator(" ")
voteAction:groupType("normal")
function voteAction.onSay(player)
  showVoteWindow(player)
  return true
end
voteAction:register()

-- Comando /statusvoto
local statusAction = TalkAction("/statusvoto")
statusAction:separator(" ")
statusAction:groupType("normal")
function statusAction.onSay(player)
  local msg = ("Total de votos: %d\n"):format(state.totalVotes)
  for id, ev in pairs(EVENTS) do
    msg = msg .. (ev.name .. ": " .. state.counts[id] .. "\n")
  end
  player:popupFYI(msg)
  return true
end
statusAction:register()

-- Comando /endvote (god)
local endAction = TalkAction("/endvote")
endAction:separator(" ")
endAction:groupType("god")
function endAction.onSay(player)
  if not state.active then
    player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Nao ha evento ativo.")
    return true
  end

  -- Restaura rates e limpa estado
  for _, e in pairs(EVENTS) do
    _G[e.rateVar] = 100
  end
  state.active        = false
  state.activeEventId = nil
  state.endTime       = nil
  state.votes         = {}
  state.totalVotes    = 0
  for k in pairs(state.counts) do
    state.counts[k] = 0
  end
  saveState()

  Game.broadcastMessage(
    "Evento encerrado manualmente! Nova votacao disponivel.",
    MESSAGE_GAME_HIGHLIGHT
  )
  return true
end
endAction:register()

-- Inicializacao
loadState()
addEvent(periodicCheck, CHECK_INTERVAL * 1000)
