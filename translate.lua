local json = require("json")

local chatMessages = {}

local function translateText(input, targetLang)
    local result = ""
    local response = web.get("http://translate.googleapis.com", "/translate_a/single?client=gtx&sl=auto&tl=" .. targetLang .. "&dt=t&q=" .. input)

    for k, v in pairs(json.decode(response.body)[1]) do
        result = result .. v[1]
    end

    return result
end

function onFireEvent(event)
    -- if the attacker is localplayer play hitsound and add a hitmarker to the table
    if event:getName() == "player_say" then
        chatMessages[#chatMessages+1] = {
            ["userid"] = event:getInt("userid"),
            ["translated"] = translateText(event:getString("text"), "en")
        }
    end
end

function onDraw()
    ui.setNextWindowSize(Vec2(300, 100))
    ui.beginComplexWindow("chat translator", 131) -- no background + no resize + no titlebar
    draw.drawBlurRect(ui.getCurrentWindowPos(), ui.getCurrentWindowPos() + ui.getCurrentWindowSize(), 1)
    ui.label("chat translator")
    ui.separator()
    ui.separator()
    for i=0,#chatMessages-1 do
        ui.label(chatMessages[#chatMessages-i]["translated"])
        ui.separator()
    end
    ui.endWindow()

    -- draw the send chat message window if menu open
    if ui.isMenuOpen() then
        ui.setNextWindowSize(Vec2(300, 100))
        ui.beginWindow("send translated message")
        ui.textInput("message", "message to translate")
        ui.textInput("target language (e.g ru,en,fr)", "target language")
        if ui.button("send message") then
            eclipse.clientCmd("say " .. translateText(ui.getConfigStr("message to translate"), ui.getConfigStr("target language")))
        end
        ui.endWindow()
    end
end

eclipse.addEventListener("player_say", false)
eclipse.registerHook("fireEvent", onFireEvent)
eclipse.registerHook("draw", onDraw)