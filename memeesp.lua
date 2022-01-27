--name meme esp
--desc script that adds threadsafe chicken and fish esp.
--author sekc

local chickens = {}
local fishies = {} -- ~v~ cute

function onDraw()
    for i, chicken in pairs(chickens) do
        if ui.getConfigBool("chicken esp text") then
            draw.outlineText(Vec2(chicken.x + ((chicken.z - chicken.x) - draw.calcTextSize("chicken").x)/2, chicken.y - 14), ui.getConfigCol("chicken esp text color"), "chicken")
        end
        if ui.getConfigBool("chicken esp") then
            draw.rectangle(Vec2(chicken.x, chicken.y), Vec2(chicken.z, chicken.w), Color(0, 0, 0, ui.getConfigCol("chicken esp color").value.w), 3)
            draw.rectangle(Vec2(chicken.x, chicken.y), Vec2(chicken.z, chicken.w), ui.getConfigCol("chicken esp color"), 1)
        end
    end
    for i, fish in pairs(fishies) do
        if ui.getConfigBool("fish esp text") then
            draw.outlineText(Vec2(fish.x - draw.calcTextSize("fish").x/2, fish.y - 16), ui.getConfigCol("fish esp text color"), "fish")
        end
        if ui.getConfigBool("fish esp") then
            draw.rectangle(Vec2(fish.x - 2, fish.y - 2), Vec2(fish.z + 2, fish.w + 2), Color(0, 0, 0, ui.getConfigCol("fish esp color").value.w), 3)
            draw.rectangle(Vec2(fish.x - 2, fish.y - 2), Vec2(fish.z + 2, fish.w + 2), ui.getConfigCol("fish esp color"), 1)
        end
    end
end

function onCreateMove()
    chickens = {}
    fishies = {}
    for i, ent in pairs(cheat.getEntitiesByClassID(36)) do
        if ent:sane() then
            local box = ent:getBBox()
            if box.y > 0 then
                chickens[i] = ent:getBBox()
            end
        end
    end
    for i, ent in pairs(cheat.getEntitiesByClassID(75)) do
        if ent:sane() then
            local box = ent:getBBox()
            if box.y > 0 then
                fishies[i] = ent:getBBox()
            end
        end
    end
end

function onUI()
    ui.colorPicker("##chicken esp color", "chicken esp color")
    ui.sameLine()
    ui.checkbox("chicken esp", "chicken esp")

    ui.colorPicker("##chicken esp text color", "chicken esp text color")
    ui.sameLine()
    ui.checkbox("chicken esp text", "chicken esp text")

    ui.colorPicker("##fish esp color", "fish esp color")
    ui.sameLine()
    ui.checkbox("fish esp", "fish esp")

    ui.colorPicker("##fish esp text color", "fish esp text color")
    ui.sameLine()
    ui.checkbox("fish esp text", "fish esp text")
end

cheat.registerHook("createMove", onCreateMove)
cheat.registerHook("draw", onDraw)
cheat.registerHook("UI", onUI)