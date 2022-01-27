--name skeetbar
--desc simple script to showcase drawing over the menu with a "drawabove" hook, imitating gamesense's rainbow bar, also allows you to place rainbow bars at the top and bottom of your screen. 
--author sekc

function uiHook()
	ui.checkbox("menu bar", "skeetbar menu bar")
	ui.checkbox("top bar", "skeetbar top bar")
	ui.checkbox("bottom bar", "skeetbar bottom bar")
	ui.checkbox("animated", "skeetbar animated")
	ui.sliderFloat("animation speed", "skeetbar animation speed", 0, 1, "%.2f")
	ui.sliderFloat("saturation", "skeetbar saturation", 0, 1, "%.2f")
	ui.sliderFloat("value", "skeetbar value", 0, 1, "%.2f")
end

local hue = 0
function drawSkeetBar(min, max)
	color1 = draw.HSVtoColor(hue, ui.getConfigFloat("skeetbar saturation"), ui.getConfigFloat("skeetbar value"), 1)
	color2 = draw.HSVtoColor(hue+0.2, ui.getConfigFloat("skeetbar saturation"), ui.getConfigFloat("skeetbar value"), 1)
	color3 = draw.HSVtoColor(hue+0.4, ui.getConfigFloat("skeetbar saturation"), ui.getConfigFloat("skeetbar value"), 1)
	color4 = draw.HSVtoColor(hue+0.6, ui.getConfigFloat("skeetbar saturation"), ui.getConfigFloat("skeetbar value"), 1)
	draw.gradientFilledRectangle(min, Vec2(min.x + ((max.x - min.x) / 3), max.y), color1, color2, color1, color2)
	draw.gradientFilledRectangle(Vec2(min.x + ((max.x - min.x) / 3), min.y), Vec2(min.x + ((max.x - min.x) / 3)*2, max.y), color2, color3, color2, color3)
	draw.gradientFilledRectangle(Vec2(min.x + ((max.x - min.x) / 3)*2, min.y), max, color3, color4, color3, color4)
end

function drawHook()
	if ui.getConfigBool("skeetbar animated") then
		hue = hue + (draw.deltaTime() * ui.getConfigFloat("skeetbar animation speed"))
	end

	if ui.getConfigBool("skeetbar menu bar") and ui.isMenuOpen() then
		drawSkeetBar(Vec2(ui.getMenuPos().x + 2, ui.getMenuPos().y + 2), Vec2(ui.getMenuPos().x + ui.getMenuSize().x - 2, ui.getMenuPos().y + 6))
	end
	if ui.getConfigBool("skeetbar top bar") then
		drawSkeetBar(Vec2(0, 0), Vec2(draw.getScreenSize().x, 6))
	end
	if ui.getConfigBool("skeetbar bottom bar") then
		drawSkeetBar(Vec2(0, draw.getScreenSize().y - 6), Vec2(draw.getScreenSize().x, draw.getScreenSize().y))
	end
end

eclipse.registerHook("UI", uiHook)
eclipse.registerHook("drawabove", drawHook)