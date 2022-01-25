--name hitmarkers
--desc recreates call of duty hitmarkers, complete with a random rotation
--author sekc

local hitmarkers = {} -- table of all active hitmarkers
Hitmarker = {rotation = 0, durationLeft = 0.2, hitgroup = 0}
function Hitmarker:new(hitgroup)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.hitgroup = hitgroup
    o.durationLeft = ui.getConfigFloat("hitmarker die time") == 0 and 0.2 or ui.getConfigFloat("hitmarker die time")
    o.rotation = math.random(-ui.getConfigFloat("hitmarker random rotation amount")*100, ui.getConfigFloat("hitmarker random rotation amount")*100) / 100
    return o
end

local function rotatePoint(point, angle, around)
    if not around then around = Vec2(0, 0) end
    local s = math.sin(angle)
    local c = math.cos(angle)
    
    point.x = around.x - point.x
    point.y = around.y - point.y

    return Vec2(around.x + (point.x * c - point.y * s), around.y + (point.x * s + point.y * c))
end

local function drawCross(pos, rotation, color, thickness, insidePointDistance, outsidePointDistance)
    draw.line(
        rotatePoint(Vec2(pos.x + outsidePointDistance, pos.y + outsidePointDistance), rotation, pos),
        rotatePoint(Vec2(pos.x + insidePointDistance, pos.y + insidePointDistance), rotation, pos),
        color, thickness)

    draw.line(
        rotatePoint(Vec2(pos.x - outsidePointDistance, pos.y + outsidePointDistance), rotation, pos),
        rotatePoint(Vec2(pos.x - insidePointDistance, pos.y + insidePointDistance), rotation, pos),
        color, thickness)

    draw.line(
        rotatePoint(Vec2(pos.x + outsidePointDistance, pos.y - outsidePointDistance), rotation, pos),
        rotatePoint(Vec2(pos.x + insidePointDistance, pos.y - insidePointDistance), rotation, pos),
        color, thickness)

    draw.line(
        rotatePoint(Vec2(pos.x - outsidePointDistance, pos.y - outsidePointDistance), rotation, pos),
        rotatePoint(Vec2(pos.x - insidePointDistance, pos.y - insidePointDistance), rotation, pos),
        color, thickness)
end

-- return false if hitmarker should be deleted
function Hitmarker:draw()
    self.durationLeft = self.durationLeft - draw.deltaTime()
    local color = (self.hitgroup == 1) and ui.getConfigCol("hitmarker headshot color") or ui.getConfigCol("hitmarker color")
    color.value.w = self.durationLeft * 8
    drawCross(Vec2(draw.getScreenSize().x / 2, draw.getScreenSize().y / 2), self.rotation, Color(0, 0, 0, self.durationLeft * 8), ui.getConfigFloat("hitmarker width") + 1, 3 + (self.durationLeft * 22), 10 + ui.getConfigFloat("hitmarker length") + (self.durationLeft * 22))
    drawCross(Vec2(draw.getScreenSize().x / 2, draw.getScreenSize().y / 2), self.rotation, color, ui.getConfigFloat("hitmarker width"), 4 + (self.durationLeft * 22), 9 + ui.getConfigFloat("hitmarker length") + (self.durationLeft * 22))
    


    if self.durationLeft < 0 then
        return false
    end
    return true
end

function onFireEvent(event)
    -- if the attacker is localplayer play hitsound and add a hitmarker to the table
    if event:getName() == "player_hurt" and entitylist.getIndexForUserID(event:getInt("attacker")) == entitylist:getLocalPlayer() then
        eclipse.clientCmd("playvol buttons/arena_switch_press_02 " .. 0.4)
        hitmarkers[#hitmarkers + 1] = Hitmarker:new(event:getInt("hitgroup"))
    end
end

function onDraw()
    -- loop through and draw all hitmarkers
    for i=1,#hitmarkers do
        -- remove hitmarkers if draw returns false
        if hitmarkers[i] and not hitmarkers[i]:draw() then
            table.remove(hitmarkers, i)
        end
    end
end

function onUI()
    ui.colorPicker("hitmarker color", "hitmarker color")
    ui.colorPicker("hitmarker headshot color", "hitmarker headshot color")
    ui.sliderFloat("random rotation amount", "hitmarker random rotation amount", 0, 1.57, "%.2f")
    ui.sliderInt("hitmarker length", "hitmarker length", 0, 10, "%ipx")
    ui.sliderFloat("die time", "hitmarker die time", 0, 2, "%.2f")
    ui.sliderFloat("hitmarker width", "hitmarker width", 1, 3, "%.1f")
end

eclipse.registerHook("fireEvent", onFireEvent)
eclipse.registerHook("draw", onDraw)
eclipse.registerHook("UI", onUI)