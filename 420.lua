--name smoke weed every day
--desc $$$$$$$$$$
--author sekc

local imageSequence = {}
local IMAGE_LENGTH = 45
for i=1,IMAGE_LENGTH do
    imageSequence[i-1] = draw.loadImage("420/"..i..".png")
end

local timeToNextFrame = 0.07
local count = 0
function onDraw()
    timeToNextFrame = timeToNextFrame - draw.deltaTime()
    if timeToNextFrame < 0 then
        timeToNextFrame = timeToNextFrame + 0.07
        count = count + 1
    end

    if count >= IMAGE_LENGTH then return end
    draw.drawImage(imageSequence[count], Vec2(0, 0), draw.getScreenSize())
end

function onFireEvent(event)
    -- if the attacker is localplayer play hitsound and add a hitmarker to the table
    if event:getName() == "player_death" and entitylist.getIndexForUserID(event:getInt("attacker")) == entitylist:getLocalPlayer() then
        count = 0
    end
end

eclipse.registerHook("draw", onDraw)
eclipse.registerHook("fireEvent", onFireEvent)