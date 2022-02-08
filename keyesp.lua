--name keyesp
--desc enables esp features on keybind
--author sekc

function onUI()
    ui.checkbox("box", "keyesp box")
    ui.sameLine()
    ui.keybinder("keyesp key")
    ui.checkbox("name", "keyesp name")
    ui.checkbox("healthbar", "keyesp healthbar")
    ui.checkbox("ignorez chams alpha", "keyesp ignorez chams alpha")
end

function onCreateMove()
    local keybinderDown = ui.isKeybinderDown("keyesp key")
    ui.setConfigBool("enemy esp box", ui.getConfigBool("keyesp box") and keybinderDown)
    ui.setConfigBool("enemy esp name", ui.getConfigBool("keyesp name") and keybinderDown)
    ui.setConfigBool("enemy esp healthbar", ui.getConfigBool("keyesp healthbar") and keybinderDown)

    local chamCol = ui.getConfigCol("enemy ignorez chams color")
    chamCol.value.w = ui.getConfigBool("keyesp ignorez chams alpha") and keybinderDown and 1 or 0
    ui.setConfigCol("enemy ignorez chams color", chamCol)
end

eclipse.registerHook("UI", onUI)
eclipse.registerHook("createMove", onCreateMove)