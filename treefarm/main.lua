local sqrdist = 3
local farmx = 16 -- (farmx-1)mod3=0
local farmy = 4 -- (farmy-1)mod3=0

local function getType(id)
    if id == 'minecraft:air' then
        return 'air'
    elseif id == 'minecraft:sapling' then
        return 'sapling'
    end

    local logIDs = {
        'minecraft:log',
        'minecraft:log2'
    }
    for i = 1, #logIDs, 1 do
        if id == logIDs[i] then
            return 'log'
        end
    end

    return 'other'
end

local function getId()
    local success, data = turtle.inspect()

    if success then
        return data.name
    end

    return 'minecraft:air'
end

local function getIdUp()
    local success, data = turtle.inspectUp()

    if success then
        return data.name
    end

    return 'minecraft:air'
end

local function getIdDown()
    local success, data = turtle.inspectDown()

    if success then
        return data.name
    end

    return 'minecraft:air'
end

local function placeSapling()
    local origSlot = turtle.getSelectedSlot()

    for i = 1, 16, 1 do
        local slotData = turtle.getItemDetail(i)

        if slotData == nil then
        elseif getType(slotData.name) == 'sapling' then
            turtle.select(i)
            turtle.place()
            break
        end
    end

    turtle.select(origSlot)
end

local function destroyTree()
    local isBig = false
    if getType(getId()) == 'log' then
        turtle.dig()
        turtle.forward()
        if getType(getId()) == 'log' then
            isBig = true
            turtle.dig()
        end
        while getType(getIdUp()) == 'log' do
            turtle.digUp()
            turtle.up()
            if isBig then
                turtle.dig()
            end
        end

        if isBig then
            turtle.turnLeft()

            if not getType(getId()) == 'log' then
                turtle.turnRight()
                turtle.turnRight()

                if not getType(getId()) == 'log' then
                    isBig = false
                    turtle.turnLeft()
                end
            end
        end

        if isBig then
            turtle.dig()
            turtle.forward()

            turtle.turnLeft()
            if not getType(getId()) == 'log' then
                turtle.turnRight()
                turtle.turnRight()
            end

            turtle.dig()

            while getType(getIdDown()) == 'log' do
                turtle.digDown()
                turtle.down()
                turtle.dig()
            end
        else
            while not turtle.detectDown() do
                turtle.down()
            end
        end
        turtle.back()

        return true
    end

    return false
end

destroyTree()
placeSapling()
