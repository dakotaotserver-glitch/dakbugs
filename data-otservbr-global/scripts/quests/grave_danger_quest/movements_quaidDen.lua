local quaidDen = MoveEvent()

function quaidDen.onStepIn(creature, item, position, fromPosition)
	if creature:isMonster() then
		return true
	end

	if creature:getStorageValue(Storage.Quest.U12_20.GraveDanger.CustodianKilled) < 1 then
		creature:teleportTo(Position(33401, 32658, 3))
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Você acionou uma armadilha e foi afastado do caminho. O Custodian está bem protegido—apenas quem sabe o momento certo conseguirá passar. Tente novamente, mas não tropece, ou será devolvido aqui.")
	end

	return true
end

quaidDen:id(31636)
quaidDen:register()
