--name auto queue
--desc automatically queues matchmaking.
--author sekc

local gamemodes = {"competitive", "scrimcomp2v2", "casual", "deathmatch", "skirmish", "survival"}

function getGamemodeFlags(gamemode)
    if gamemode == "competitive" then
        return (ui.getConfigNumber("autoqueue match length") == 0 and 16 or (ui.getConfigNumber("autoqueue match length") == 1 and 32 or 48))
    elseif gamemode == "deathmatch" then
        return (ui.getConfigNumber("autoqueue match style") == 0 and 16 or (ui.getConfigNumber("autoqueue match style") == 1 and 32 or 4))
    else
        return 0
    end
end

function update()
    if eclipse.isInGame() or (not ui.getConfigBool("autoqueue enabled")) then
        return
    end

    panorama.executeScript([[            
		var cfg = GameTypesAPI.GetConfig();
        function getGameType(mode) {
            for ( var gameType in cfg.gameTypes ) 
            {
                if ( cfg.gameTypes[ gameType ].gameModes.hasOwnProperty( mode ) )
                    return gameType;
            }
        }

        $.Msg(getGameType("]] .. gamemodes[ui.getConfigNumber("autoqueue gamemode") + 1] .. [["))

        if (!LobbyAPI.BIsHost()) {
            LobbyAPI.CreateSession();
        }
        
        LobbyAPI.UpdateSessionSettings({
            update: {
                Options: {
                    action: "custommatch",
                    server : "official"
                },
                Game : {
                    mode: "]] .. gamemodes[ui.getConfigNumber("autoqueue gamemode") + 1] .. [[",
                    type : getGameType("]] .. gamemodes[ui.getConfigNumber("autoqueue gamemode") + 1] .. [["),
                    mapgroupname : "]] .. ui.getConfigStr("autoqueue map") .. [[",
                    gamemodeflags : ]] .. getGamemodeFlags(gamemodes[ui.getConfigNumber("autoqueue gamemode") + 1]) .. [[,
                    prime : ]] .. (ui.getConfigBool("autoqueue prime") and "true" or "false") ..[[
                }
            }
            });

		GameInterfaceAPI.SetSettingString("ui_playsettings_flags_competitive_16", 1);
        if (!GameStateAPI.IsConnectedOrConnectingToServer()) {
            LobbyAPI.StartMatchmaking("", "", "", "");
        }
        ]], "CSGOMainMenu")
end

local timeToNextUpdate = 0
function onDraw()
    timeToNextUpdate = timeToNextUpdate - draw.deltaTime()
    if timeToNextUpdate < 0 then
        timeToNextUpdate = timeToNextUpdate + 2
        update()
    end
end

function onUI()
    ui.checkbox("enabled", "autoqueue enabled")
    ui.checkbox("prime?", "autoqueue prime")
    ui.comboBox("gamemode", "autoqueue gamemode", gamemodes)
    ui.comboBox("match length", "autoqueue match length", {"long", "short", "any"})
    ui.comboBox("match style", "autoqueue match style", {"classic", "free for all", "team vs team"})
    ui.textInput("map", "autoqueue map")
end

eclipse.registerHook("UI", onUI)
eclipse.registerHook("draw", onDraw)