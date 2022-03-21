--name sand
--desc shitty falling sand simulator in lua
--author sekc

local ARRAYSIZE = Vec2(200, 200)

local sandArray = {}

for i=1,ARRAYSIZE.x do
    sandArray[i] = {}
    for j=1,ARRAYSIZE.y do
        sandArray[i][j] = 0
    end
end

local function update(array)
    local buf = {}
    for k,v in pairs(array) do
        buf[k] = {}
        for k2,v2 in pairs(v) do
            buf[k][k2] = v2
        end
    end

    for i=#array,1,-1 do
        for j=#array[i],1,-1 do
            if buf[i][j] == 1 then -- sand
                if buf[i][j+1] == 0 then
                    buf[i][j+1] = 1
                    buf[i][j] = 0
                elseif i-1 <= 0 or i+1 > ARRAYSIZE.x then -- cant move left/right if left/right is not in the array
                elseif (buf[i+1][j+1] == 0 and buf[i-1][j+1] == 0) or (buf[i+1][j+1] == 2 and buf[i-1][j+1] == 2) then
                    local rand = math.random(0, 1) == 1 and -1 or 1
                    buf[i][j] = buf[i+rand][j+1]
                    buf[i+rand][j+1] = 1
                elseif buf[i+1][j+1] == 0 or buf[i+1][j+1] == 2 then
                    buf[i][j] = buf[i+1][j+1]
                    buf[i+1][j+1] = 1
                elseif buf[i-1][j+1] == 0 or buf[i-1][j+1] == 2 then
                    buf[i][j] = buf[i-1][j+1]
                    buf[i-1][j+1] = 1
                elseif buf[i][j+1] == 2 then
                    buf[i][j+1] = 2
                    buf[i][j] = 0
                end
            end
            if buf[i][j] == 2 then -- water
                if buf[i][j+1] == 0 then
                    buf[i][j+1] = 2
                    buf[i][j] = 0
                elseif i-1 <= 0 or i+1 > ARRAYSIZE.x then -- cant move left/right if left/right is not in the array
                elseif buf[i+1][j] == 0 and buf[i-1][j] == 0 then
                    local rand = math.random(0, 1) == 1 and -1 or 1
                    buf[i][j] = buf[i+rand][j]
                    buf[i+rand][j] = 2
                elseif buf[i+1][j] == 0 then
                    buf[i][j] = buf[i+1][j]
                    buf[i+1][j] = 2
                elseif buf[i-1][j] == 0 then
                    buf[i][j] = buf[i-1][j]
                    buf[i-1][j] = 2
                elseif buf[i+1][j+1] == 0 then
                    buf[i][j] = buf[i+1][j+1]
                    buf[i+1][j+1] = 2
                elseif buf[i-1][j+1] == 0 then
                    buf[i][j] = buf[i-1][j+1]
                    buf[i-1][j+1] = 2
                end
            end
        end
    end
    return buf
end

local selectorSize = 1
local function drawArray(array, pos)
    local currentHighlight = Vec2(math.floor((ui.getMousePos().x - pos.x) / 2), math.floor((ui.getMousePos().y - pos.y) / 2))
    if currentHighlight.x > 0 and currentHighlight.x < ARRAYSIZE.x and
            currentHighlight.y > 0 and currentHighlight.y < ARRAYSIZE.y then
        
        selectorSize = selectorSize + ui.getMouseWheel()

        if ui.getMousePressed() == 1 then
            for i=0,selectorSize do
                for j=0,selectorSize do
                    sandArray[math.floor(currentHighlight.x + i - selectorSize / 2)][math.floor(currentHighlight.y + j - selectorSize / 2)] = 1
                end
            end
        elseif ui.getMousePressed() == 2 then
            for i=0,selectorSize do
                for j=0,selectorSize do
                    sandArray[math.floor(currentHighlight.x + i - selectorSize / 2)][math.floor(currentHighlight.y + j - selectorSize / 2)] = 2
                end
            end
        elseif ui.getMousePressed() == 5 then
            for i=0,selectorSize do
                for j=0,selectorSize do
                    sandArray[math.floor(currentHighlight.x + i - selectorSize / 2)][math.floor(currentHighlight.y + j - selectorSize / 2)] = 3
                end
            end
        end
        draw.rectangle(pos + Vec2(currentHighlight.x*2, currentHighlight.y*2) - Vec2(1, 1) - Vec2(selectorSize, selectorSize), pos + Vec2(currentHighlight.x*2, currentHighlight.y*2) + Vec2(4, 4) + Vec2(selectorSize, selectorSize), Color(1, 1, 1, 1), 1)
    end
    
    for i=1,#array do
        for j=1,#array[i] do
            if array[i][j] == 1 then
                draw.filledRectangle(pos + Vec2(i*2, j*2), pos + Vec2(i*2, j*2) + Vec2(2, 2), Color(1, 1, 0, 1))
            end
            if array[i][j] == 2 then
                draw.filledRectangle(pos + Vec2(i*2, j*2), pos + Vec2(i*2, j*2) + Vec2(2, 2), Color(0, 0, 1, 1))
            end
            if array[i][j] == 3 then
                draw.filledRectangle(pos + Vec2(i*2, j*2), pos + Vec2(i*2, j*2) + Vec2(2, 2), Color(0.4, 0.4, 0.4, 1))
            end
        end
    end
end

local timeToNextFrame = 0.03
function onDraw()
    timeToNextFrame = timeToNextFrame - draw.deltaTime()
    if timeToNextFrame < 0 then
        timeToNextFrame = timeToNextFrame + ui.getConfigNumber("sand sim speed")
        sandArray = update(sandArray)
    end

    -- draw window
    ui.setNextWindowSize(Vec2(400, 27))
    ui.beginWindow("falling sand")
    ui.label("falling sand")
    ui.separator()
    local windowPos = ui.getCurrentWindowPos()
    ui.endWindow()

    draw.filledRectangle(windowPos + Vec2(0, 27), windowPos + Vec2(400, 427), Color(0.1, 0.1, 0.1, 0.9))
    drawArray(sandArray, windowPos + Vec2(0, 27))
end

function onUI()
    ui.sliderFloat("sim speed", "sand sim speed", 0, 1, "%.2f")
end

eclipse.registerHook("draw", onDraw)
eclipse.registerHook("UI", onUI)