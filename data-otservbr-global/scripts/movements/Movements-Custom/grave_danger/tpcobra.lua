local function handleTeleport(player, aid, position)
    local dir = player:getDirection()
    local targetPos = Position(position.x, position.y, position.z)

    if aid == 33201 or aid == 33202 then
        -- 1 SQM para trás (sem efeito)
        if dir == DIRECTION_NORTH then
            targetPos.y = targetPos.y + 1
        elseif dir == DIRECTION_SOUTH then
            targetPos.y = targetPos.y - 1
        elseif dir == DIRECTION_WEST then
            targetPos.x = targetPos.x + 1
        elseif dir == DIRECTION_EAST then
            targetPos.x = targetPos.x - 1
        end

        player:teleportTo(targetPos)
        return true

    elseif aid == 33203 or aid == 33204 then
        -- 2 SQMs para frente (com efeito de fogo)
        if dir == DIRECTION_NORTH then
            targetPos.y = targetPos.y - 2
        elseif dir == DIRECTION_SOUTH then
            targetPos.y = targetPos.y + 2
        elseif dir == DIRECTION_WEST then
            targetPos.x = targetPos.x - 2
        elseif dir == DIRECTION_EAST then
            targetPos.x = targetPos.x + 2
        end

        player:teleportTo(targetPos)
        return true
    end

    return false
end

-- Handler único
local function onTeleportStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then return false end
    return handleTeleport(player, item:getActionId(), position)
end

-- Registro explícito para cada AID
local aidList = {33201, 33202, 33203, 33204}
for _, aid in ipairs(aidList) do
    local event = MoveEvent()
    event:type("stepin")
    event:aid(aid)
    event:onStepIn(onTeleportStepIn)
    event:register()
end
