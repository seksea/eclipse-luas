if not eclipse.isInGame() then
    panorama.executeScript([[
        var textEntry = $.GetContextPanel().FindChildTraverse("NameableTextEntry");
        textEntry.enabled = true
        textEntry.text = "\u2029\u2029\u2029\u2029\u2029\u2029\u2029cock"
        var validButton = $.GetContextPanel().FindChildTraverse("NameableValidBtn");
        validButton.enabled = true
    ]], "CSGOMainMenu")
end