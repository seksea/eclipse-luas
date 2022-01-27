--name esp everything
--desc draws a box around every entity
--author sekc

local entities = {}

function onDraw()
    for i, ent in pairs(entities) do
        draw.outlineText(Vec2(ent.box.x + ((ent.box.z - ent.box.x) - draw.calcTextSize(ent.classID .. " | " .. ent.networkName).x)/2, ent.box.y - 14), Color(1, 1, 1, 1), ent.classID .. " | " .. ent.networkName)
        draw.rectangle(Vec2(ent.box.x, ent.box.y), Vec2(ent.box.z, ent.box.w), Color(0, 0, 0, 1), 3)
        draw.rectangle(Vec2(ent.box.x, ent.box.y), Vec2(ent.box.z, ent.box.w), Color(1, 1, 1, 1), 1)
    end
end

function onCreateMove()
    entities = {}
    for i, ent in pairs(entitylist.getEntities()) do
        if ent:sane() then
            local box = ent:getBBox()
            if box.y > 0 then
                entities[i] = {box = ent:getBBox(), classID = ent:classID(), networkName = ent:networkName()}
            end
        end
    end
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("draw", onDraw)