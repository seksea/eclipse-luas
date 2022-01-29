--name lobby tricks
--desc spams people from looking to play with invites to lobby.
--author sekc

panorama.executeScript([[
    collectedSteamIDS = [];
    collectedSteamIDS.push("123");

    massInviteEnabled = false;

    function massInvite() {
        $.Schedule(6, massInvite);
        if (massInviteEnabled) {
            PartyBrowserAPI.Refresh();
            var lobbies = PartyBrowserAPI.GetResultsCount();
            for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
                var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
                if (!collectedSteamIDS.includes(xuid)) {
                    if (collectedSteamIDS.includes('123')) {
                        collectedSteamIDS.splice(collectedSteamIDS.indexOf('123'), 1);
                    }
                    collectedSteamIDS.push(xuid);
                    $.Msg(`Adding ${xuid} to the collection..`);
                }
            }
            $.Msg(`Mass invite collection: ${collectedSteamIDS.length}`);
            collectedSteamIDS.forEach(xuid => {
                FriendsListAPI.ActionInviteFriend(xuid, "");
            });
        }
    }
    massInvite()
]], "panorama/layout/base.xml")

function onUI()
    if ui.button("invite all friends") then
        panorama.executeScript([[
        var friends = FriendsListAPI.GetCount();
        for (var id = 0; id < friends; id++) {
            var xuid = FriendsListAPI.GetXuidByIndex(id);
            FriendsListAPI.ActionInviteFriend(xuid, "");
        }]], "panorama/layout/base.xml")
    end
    ui.checkbox("mass invite", "mass invite")
    panorama.executeScript("massInviteEnabled = " .. (ui.getConfigBool("mass invite") and "true" or "false") .. ";", "panorama/layout/base.xml")
end

function onUnload()
    panorama.executeScript("massInviteEnabled = false;", "panorama/layout/base.xml") 
end

eclipse.registerHook("UI", onUI)
eclipse.registerHook("unload", onUnload)