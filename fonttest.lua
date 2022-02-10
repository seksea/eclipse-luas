--name fonttest
--desc custom font example
--author sekc

local arial = draw.loadFont("fonttest/arial.ttf", 22, true)
local arialNoAA = draw.loadFont("fonttest/arial.ttf", 22, false)
local arialBig = draw.loadFont("fonttest/arial.ttf", 52, true)

function onDraw()
    draw.text(Vec2(10, 10), Color(1, 1, 1, 1), "this is the normal font.")

    draw.pushFont(arial)
    draw.text(Vec2(10, 30), Color(1, 1, 1, 1), "this is the arial font.")
    draw.popFont()

    draw.pushFont(arialNoAA)
    draw.text(Vec2(10, 50), Color(1, 1, 1, 1), "this is the arial font no AA.")
    draw.popFont()
    
    draw.pushFont(arialBig)
    draw.text(Vec2(10, 70), Color(1, 1, 1, 1), "this is the arial font in big.")
    draw.popFont()
end

eclipse.registerHook("draw", onDraw)