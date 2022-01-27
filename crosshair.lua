--name crosshair
--desc recoil crosshair
--author sekc

function drawHook()
    localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if eclipse.isInGame() and localPlayer:sane() then
        local centerScreen = Vec2(draw.getScreenSize().x/2, draw.getScreenSize().y/2)
        local dx = draw.getScreenSize().x/90
        local dy = draw.getScreenSize().y/90
        local aimpunch = localPlayer:getPropQAngle("DT_Local", "m_aimPunchAngle")
        local x = (centerScreen.x) - (dx * aimpunch.y)
        local y = (centerScreen.y) + (dy * aimpunch.x)
        draw.filledRectangle(Vec2(x - 5, y - 1), Vec2(x + 6, y + 2), Color(0, 0, 0, 1))
        draw.filledRectangle(Vec2(x - 1, y - 5), Vec2(x + 2, y + 6), Color(0, 0, 0, 1))
        draw.filledRectangle(Vec2(x - 4, y), Vec2(x + 5, y + 1), Color(1, 1, 1, 1))
        draw.filledRectangle(Vec2(x, y - 4), Vec2(x + 1, y + 5), Color(1, 1, 1, 1))
    end
end

eclipse.registerHook("draw", drawHook)