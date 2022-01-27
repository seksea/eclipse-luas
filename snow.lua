--name snow
--desc simple script to showcase classes in lua that draws snow particles.
--author sekc

local SNOW_AMOUNT = 400
local SNOW_SIZE = 1.5

-- create Snowflake class
Snowflake = {x = 0, y = 0, dx = 10, dy = 100}
function Snowflake:new(x, y, dx, dy)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.x = x
    o.y = y
    o.dx = dx
    o.dy = dy
    return o
end

function Snowflake:draw()
    draw.filledCircle(Vec2(self.x % draw.getScreenSize().x, self.y % draw.getScreenSize().y), SNOW_SIZE, ui.getConfigCol("snow color"))
    self.x = self.x + (self.dx * draw.deltaTime())
    self.y = self.y + (self.dy * draw.deltaTime())
end

-- create table filled with SNOW_AMOUNT amount of Snowflake objects
local snow = {}
for i=1,SNOW_AMOUNT do
    snow[i] = Snowflake:new(math.random(0, draw.getScreenSize().x), math.random(0, draw.getScreenSize().y), math.random(-10, 10), math.random(100, 140))
end

function doSnow()
    if not ui.getConfigBool("snow only when menu open") or ui.isMenuOpen() then
        -- loop through all items in snow table and run draw()
        for i=1,#snow do
            snow[i]:draw()
        end
    end
end

function drawHook()
    if ui.getConfigBool("snow behind menu") then
        doSnow()
    end
end

function drawAboveHook()
    if not ui.getConfigBool("snow behind menu") then
        doSnow()
    end
end

function uiHook()
    ui.colorPicker("snow color", "snow color")
    -- use ##snow here as "only when menu open" and "draw behind menu" are commonly used widget labels and may clash with other luas
    ui.checkbox("draw behind menu##snow", "snow behind menu")
    ui.checkbox("only when menu open##snow", "snow only when menu open")
end

cheat.registerHook("draw", drawHook)
cheat.registerHook("drawabove", drawAboveHook)
cheat.registerHook("UI", uiHook)