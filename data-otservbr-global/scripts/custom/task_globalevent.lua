local taskLog = GlobalEvent("TaskLog")

function taskLog.onStartup()
	local newmissions = {}

	for i, data in pairs(taskConfiguration) do
		if data.name and data.storage and data.storagecount and data.total then
			newmissions[#newmissions + 1] = {
				name = "Task: " .. data.name,
				storageId = data.storage,
				missionId = #newmissions + 1,
				startValue = 0,
				endValue = os.time() * 10,
				description = function(player)
					local kills = player:getTaskKills(data.storagecount)
					if kills == -1 then
						return "You have completed this task."
					elseif kills == data.total then
						return "You have completed this task, but you still need to collect your reward use !task."
					else
						return "You killed [" .. kills .. "/" .. data.total .. "] " .. data.name
					end
				end,
			}
		else
			print("[WARNING] Task inválida detectada na configuração. Verifique a entrada de índice:", i)
		end
	end

	Quests[#Quests + 1] = {
		name = "Tasks",
		startStorageId = taskQuestLog,
		startStorageValue = 1,
		missions = newmissions
	}

	return true
end

taskLog:register()

-- Evento que registra TaskCreature ao login
local taskEvents = CreatureEvent("TaskEvents")

function taskEvents.onLogin(player)
	local events = {
		"TaskCreature"
	}

	for i = 1, #events do
		player:registerEvent(events[i])
	end

	return true
end

taskEvents:register()
