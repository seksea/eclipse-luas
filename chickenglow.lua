--name chimken glow
--desc example of glowing entities in lua
--author sekc

function onPostScreenEffects()
    local color = ui.getConfigCol("chicken glow color")
    for i, ent in pairs(entitylist.getEntitiesByClassID(36)) do
        if ent:sane() then
            glow.glowEntity(ent, color, ui.getConfigFloat("chicken glow style"))
        end
    end
end

function onUI()
    ui.colorPicker("chicken color", "chicken glow color")
    ui.comboBox("chicken glow style", "chicken glow style", {"classic", "rim", "stencil", "stencil pulse"})
end

eclipse.registerHook("doPostScreenEffects", onPostScreenEffects)
eclipse.registerHook("UI", onUI)