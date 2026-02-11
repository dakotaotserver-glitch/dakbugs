local talk = TalkAction("!ajudapontos")

function talk.onSay(player, words, param)
  local count = player:getStorageValue(91000)
  if count < 0 then count = 0 end

  local msg = "Voce ja ajudou " .. count .. " jogador" .. (count == 1 and "" or "es") .. " no canal de ajuda."

  if count >= 300 then
    msg = msg .. " Sua insignia atual e: [Lendario]."
  elseif count >= 200 then
    msg = msg .. " Sua insignia atual e: [Veterano]."
  elseif count >= 100 then
    msg = msg .. " Sua insignia atual e: [Mentor]."
  elseif count >= 50 then
    msg = msg .. " Sua insignia atual e: [Ativo]."
  else
    msg = msg .. " Continue ajudando para subir de patente!"
  end

  player:sendTextMessage(MESSAGE_EVENT_ADVANCE, msg)
  return false
end

talk:separator(" ")
talk:groupType("normal")
talk:register()
