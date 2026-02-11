local npcPosition = Position(32368, 32233, 7)

local npcTestServer = GlobalEvent("npcTestServer")

function npcTestServer.onStartup()
	local npc = Game.createNpc("Test Server", npcPosition)
	if npc then
		npc:setMasterPos(npcPosition)
		npc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

npcTestServer:register()
