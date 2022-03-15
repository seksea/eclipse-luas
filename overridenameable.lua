function onUI()
    ui.label("use \\u2029 to create newlines")
    ui.textInputMultiline("name", "overridenameable name", 128)
    if ui.button("rename") then
        panorama.executeScript([[
            var textEntry = $.GetContextPanel().FindChildTraverse("NameableTextEntry");
            textEntry.enabled = true
            textEntry.text = "]] .. ui.getConfigStr("overridenameable name") .. [["
            var validButton = $.GetContextPanel().FindChildTraverse("NameableValidBtn");
            validButton.enabled = true
        ]], "CSGOMainMenu")
    end
end

eclipse.registerHook("UI", onUI)