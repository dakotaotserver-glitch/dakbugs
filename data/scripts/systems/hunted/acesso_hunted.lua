local UNIQUE_IDS = { [33200] = true, [33201] = true }
local MODAL_ID_MAIN = 3320201
local MODAL_ID_TUTORIAL = 3320202

local function openHuntedFlow(player)
    if type(_G.openPlayerListModal) == "function" then
        _G.openPlayerListModal(player)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sistema de hunted nao encontrado.")
    end
end

local function showBlacklist(player)
    if type(_G.showBlacklistDialog) == "function" then
        _G.showBlacklistDialog(player)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Blacklist: Use o item correto ou peca ao administrador.")
    end
end

local function showKillWindow(player)
    if type(_G.getPlayerIdByName) == "function" and type(_G.loadPlayerPoints) == "function" and type(_G.sendKillModalWindow) == "function" then
        local playerId = _G.getPlayerIdByName(player:getName())
        if playerId then
            local points, totalKills, totalDeaths = _G.loadPlayerPoints(playerId)
            _G.sendKillModalWindow(player, points, totalKills, totalDeaths)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nao foi possivel localizar seu personagem para exibir as kills.")
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sistema de kills nao disponivel.")
    end
end

local function showTutorialModal(player)
    local tutorialWindow = ModalWindow{
        id = MODAL_ID_TUTORIAL,
        title = "Tutorial",
        message = "Requisitos e exigencias:\n\n" ..
                  "   - Taxa 10 Coins\n" ..
				  "   - Valor Minimo 1kk por ALVO\n" ..
                  "   - Level 300 +\n" ..
                  "   - Conta Premium\n" ..
                  "   - Conta VIP\n" ..
                  "   - 1 lance por Player em 24H\n" ..
                  "   - Player alvo Level 300 +\n\n\n" ..
				  "Obs: O jogador que matar o alvo da BLACKLIST recebera todo o valor acumulado pela recompensa de sua cabeca, mais 5 coins por cada lance registrado pelo ALVO. \n\n" ..
                  "Obs: Em 24 horas, se o Player nao for morto por outro jogador, ele sera removido da BLACKLIST e apenas os GOLDs serao reembolsados.\n\n" ..
				  "Obs: Voce tambem recebe pontos extras conforme o LVL do alvo eliminado, podendo obter no maximo de 100 pontos por alvo da BLACKLIST. Ex: \n - Level 300 = 30 pontos. \n - Level 500 = 50 pontos. \n - Level 1000 + = 100. pontos\n\n" ..
				  "Obs: Troque seus pontos no menu Kill Points, na aba Reward, por boosts e items exclusivos.\n\n"
				  
                  
    }
    tutorialWindow:addButton("Entendi")
    tutorialWindow:addButton("Voltar", function(player)
        openMultiFunctionModal(player)
    end)

    tutorialWindow:sendToPlayer(player)
end


local function openMultiFunctionModal(player)
    local window = ModalWindow{
        id = MODAL_ID_MAIN,
        title = "Taxa de 10 Coins",
        message = "SISTEMA DE HUNTED:"
    }
    window:addChoice("Hunted")
    window:addChoice("Blacklist")
    window:addChoice("Kill Points")
    window:addChoice("Tutorial Hunted")

    window:addButton("Selecionar", function(player, button, choice)
        if not choice or not choice.id then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nenhuma opcao selecionada.")
            return
        end

        if choice.id == 1 then
            openHuntedFlow(player)
        elseif choice.id == 2 then
            showBlacklist(player)
        elseif choice.id == 3 then
            showKillWindow(player)
        elseif choice.id == 4 then
            showTutorialModal(player)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Escolha invalida.")
        end
    end)
    window:addButton("Cancelar")
    window:sendToPlayer(player)
end

-- Action para uso via uniqueid
local multiAction = Action()
function multiAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if UNIQUE_IDS[item.uid] then
	player:getPosition():sendMagicEffect(CONST_ME_TREASURE_MAP)
        openMultiFunctionModal(player)
        return true
    end
    return false
end

-- Registra cada uniqueid
for uid in pairs(UNIQUE_IDS) do
    multiAction:uid(uid)
end
multiAction:register()

-- Torna o menu global para ser chamado de outros scripts
_G.openMultiFunctionModal = openMultiFunctionModal
