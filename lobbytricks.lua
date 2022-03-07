--name lobby tricks
--desc allows for tricks such as spamming popups to your teammates
--author sekc

if not eclipse.isInGame() then
    panorama.executeScript([[
disallowQueue = false;
disallowQueueReason = "";
function stopQueue() {
    $.Schedule(5, stopQueue);
    if (disallowQueue && LobbyAPI.GetMatchmakingStatusString() == "#SFUI_QMM_State_find_searching") {
        reason = disallowQueueReason;
        if (reason != "") {
            PartyListAPI.SessionCommand("Game::ChatReportError", `run all xuid ${MyPersonaAPI.GetXuid()} error #SFUI_QMM_ERROR_${reason}`);
        }
        LobbyAPI.StopMatchmaking();
    }
}
stopQueue()]], "CSGOMainMenu")
end


function onUI()
    if eclipse.isInGame() then 
        ui.label("lua only works in lobby.")
        return
    end

    if ui.button("popup") then
        panorama.executeScript([[PartyListAPI.SessionCommand("Game::HostEndGamePlayAgain", "run all xuid ${MyPersonaAPI.GetXuid()}");]], "CSGOMainMenu")
    end

    if ui.button("spam popups") then
        panorama.executeScript([[
function closeAllPopups() {
    $.DispatchEvent("CSGOHideMainMenu");
}
for (i = 0; i < 200; i++) {    
    PartyListAPI.SessionCommand("Game::HostEndGamePlayAgain", "run all xuid ${MyPersonaAPI.GetXuid()}");
}
$.Schedule(2, closeAllPopups);]], "CSGOMainMenu")
    end

    if ui.button("close all popups") then
        panorama.executeScript([[$.DispatchEvent("CSGOHideMainMenu");]], "CSGOMainMenu")
    end

    ui.separator()
    if ui.button("stop matchmaking") then
        panorama.executeScript([[LobbyAPI.StopMatchmaking();]], "CSGOMainMenu")
    end
    ui.checkbox("disallow queue", "disallow queue")
    ui.textInput("disallow reason", "reason for disallow")
    ui.separator()
    ui.textInput("lobby error message", "lobby error message")
    if ui.button("send error message") then
        panorama.executeScript([[PartyListAPI.SessionCommand("Game::ChatReportError", `run all xuid ${MyPersonaAPI.GetXuid()} error #SFUI_QMM_ERROR_]] .. ui.getConfigStr("lobby error message") .. [[`);]], "CSGOMainMenu")
    end

    panorama.executeScript([[
disallowQueue = ]] .. (ui.getConfigBool("disallow queue") and "true" or "false") .. [[;
disallowQueueReason = "]] .. ui.getConfigStr("reason for disallow") .. [[";
]], "CSGOMainMenu")
end

eclipse.registerHook("UI", onUI)