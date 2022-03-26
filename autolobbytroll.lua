--name auto lobby troll
--desc automatically finds lobbies via looking to play and wastes their time by cancelling matchmaking every time a game is found.
--author sekc

panorama.executeScript([[
    trollCount = 0;
]], "CSGOMainMenu")

function update()
    panorama.executeScript([[
        if (PartyListAPI.GetCount() <= 3) { // if not in a party find a party to join via looking to play
            LobbyAPI.CloseSession();
            PartyListAPI.SetLocalPlayerForHireAdvertising("competitive");
            PartyBrowserAPI.ActionJoinParty(PartyBrowserAPI.GetInviteXuidByIndex(0));
        }
        else { // if you are in a party wait until a game is found and stop matchmaking
            if (LobbyAPI.GetMatchmakingStatusString() == "#SFUI_QMM_State_find_reserved") { // if have found game cancel matchmaking and display fake error message
                LobbyAPI.StopMatchmaking();
                trollCount++;
                $.Msg("cancelled " + trollCount + " potential games.")
            }
        }
        ]], "CSGOMainMenu")
end

local timeToNextUpdate = 0
function onDraw()
    timeToNextUpdate = timeToNextUpdate - draw.deltaTime()
    if timeToNextUpdate < 0 then
        timeToNextUpdate = timeToNextUpdate + 10
        update()
    end
end

eclipse.registerHook("draw", onDraw)