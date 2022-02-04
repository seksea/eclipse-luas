--name lobby tricks
--desc spams people from looking to play with invites to lobby.
--author sekc
if not eclipse.isInGame() then
    panorama.executeScript([[
        collectedSteamIDS = [];
        collectedSteamIDS.push("123");
    ]], "panorama/layout/base.xml")
    end
    
    function onUI()
        if eclipse.isInGame() then 
            ui.label("lua only works in lobby.")
            return
        end
        if ui.button("invite all friends") then
            panorama.executeScript([[
                _PauseMainMenuCharacter();
                _NavigateToTab( 'JsInventory', 'mainmenu_inventory' );
            var friends = FriendsListAPI.GetCount();
            for (var id = 0; id < friends; id++) {
                var xuid = FriendsListAPI.GetXuidByIndex(id);
                FriendsListAPI.ActionInviteFriend(xuid, "");
            }]], "panorama/layout/base.xml")
        end
        ui.checkbox("mass invite", "mass invite")
    end
    
    local timeToNextInviteSpam = 0
    function onDraw()
        if eclipse.isInGame() then 
            return
        end
        timeToNextInviteSpam = timeToNextInviteSpam - draw.deltaTime()
        if ui.getConfigBool("mass invite") and timeToNextInviteSpam < 0 then
            timeToNextInviteSpam = 10
            panorama.executeScript([[
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
                });]], "panorama/layout/base.xml")
        end
    end
    
    function onUnload()
        panorama.executeScript("massInviteEnabled = false;", "panorama/layout/base.xml") 
    end
    
    eclipse.registerHook("UI", onUI)
    eclipse.registerHook("draw", onDraw)
    eclipse.registerHook("unload", onUnload)