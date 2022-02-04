--name dead esp
--desc enables esp features when the localplayer is dead
--author sekc

function onUI()
    ui.checkbox("box", "deadesp box")
    ui.checkbox("name", "deadesp name")
    ui.checkbox("healthbar", "deadesp healthbar")
    ui.checkbox("ignorez chams alpha", "deadesp ignorez chams alpha")
end

function onCreateMove()
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if localPlayer:sane() then
        ui.setConfigBool("enemy esp box", ui.getConfigBool("deadesp box") and not localPlayer:alive())
        ui.setConfigBool("enemy esp name", ui.getConfigBool("deadesp name") and not localPlayer:alive())
        ui.setConfigBool("enemy esp healthbar", ui.getConfigBool("deadesp healthbar") and not localPlayer:alive())

        local chamCol = ui.getConfigCol("enemy ignorez chams color")
        chamCol.value.w = ui.getConfigBool("deadesp ignorez chams alpha") and localPlayer:alive() and 0 or 1
        ui.setConfigCol("enemy ignorez chams color", chamCol)
    end
end

eclipse.registerHook("UI", onUI)
eclipse.registerHook("createMove", onCreateMove)