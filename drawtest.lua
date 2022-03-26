--name drawtest
--desc drawing example
--author sekc

local arial = draw.loadFont("fonttest/arial.ttf", 22, true)
local arialNoAA = draw.loadFont("fonttest/arial.ttf", 22, false)
local arialBig = draw.loadFont("fonttest/arial.ttf", 52, true)

testImage = draw.loadImage("420/7.png")

function onDraw()
    draw.text(Vec2(10, 10), Color(1, 1, 1, 1), "this is the normal font.")

    draw.pushFont(arial)
    draw.text(Vec2(10, 30), Color(1, 1, 1, 1), "this is the arial font.")
    draw.outlineText(Vec2(200, 30), Color(1, 1, 1, 1), "this is the arial font (outlined).")
    draw.popFont()

    draw.pushFont(arialNoAA)
    draw.text(Vec2(10, 50), Color(1, 1, 1, 1), "this is the arial font no AA.")
    draw.popFont()
    
    draw.pushFont(arialBig)
    draw.text(Vec2(10, 70), Color(1, 1, 1, 1), "this is the arial font in big.")
    draw.popFont()
    
    draw.drawBlurRect(Vec2(10, 120), Vec2(190, 300), 1)

    draw.polygon(Vec2(300, 210), 90, Color(1, 1, 1, 1), 3, 5)

    draw.filledPolygon(Vec2(500, 210), 90, Color(1, 1, 1, 1), 5)

    draw.gradientFilledRectangle(Vec2(10, 310), Vec2(590, 490), Color(1, 0, 0, 1), Color(0, 1, 0, 1), Color(0, 0, 1, 1), Color(1, 1, 1, 1))

    draw.drawImage(testImage, Vec2(10, 500), Vec2(590, 680))
end

eclipse.registerHook("draw", onDraw)