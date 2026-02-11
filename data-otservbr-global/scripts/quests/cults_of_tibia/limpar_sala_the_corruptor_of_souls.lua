local yalaharesome = CreatureEvent("yalaharesome")

function yalaharesome.onDeath(creature, corpse, deathList)
    -- Verifica se a criatura que morreu é um monstro específico
    if creature:isMonster() and creature:getName() == "The Corruptor of Souls" then
        -- Obtém a posição da criatura que morreu
        local position = creature:getPosition()
        -- Define a posição no andar de cima (z-1)
        local positionAbove = Position(position.x, position.y, position.z)
        
        -- Obtém todos os espectadores (criaturas) no andar de cima dentro de um raio de 10 tiles
        local monstrosParaRemover = Game.getSpectators(positionAbove, false, false, 15, 15, 15, 15)
        
        -- Itera sobre a lista de espectadores
        for i = 1, #monstrosParaRemover do
            local alvo = monstrosParaRemover[i]
            
            -- Verifica se o espectador é um monstro e não é o "The Source Of Corruption"
            if alvo:isMonster() and alvo:getName() == "Zarcorix Of Yalahar" then
                -- Remove o monstro do jogo
                alvo:remove()
            end
        end
    end

    -- Retorna true para indicar que a função foi executada com sucesso
    return true
end

yalaharesome:register()

