--name cats
--desc menu cats
--author sekc

cat1 = draw.loadImage("cats/cat1.png")

function onDraw()
    if not ui.isMenuOpen() then return end

    draw.drawImage(cat1, ui.getMenuPos() + Vec2(0, -130), ui.getMenuPos() + Vec2(ui.getMenuSize().x, 20))
end

eclipse.registerHook("draw", onDraw)