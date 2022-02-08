--name recoil
--desc standalone recoil script
--author johannes / sumandora

local prev = QAngle(0,0,0)

function onCreateMove(cmd)
    currentTick = cmd.tickcount
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if not (localPlayer:sane() and localPlayer:alive()) then return end
	
    local aimpunch = localPlayer:getPropQAngle("DT_Local", "m_aimPunchAngle")
    local shots = localPlayer:getPropInt("DT_CSLocalPlayerExclusive", "m_iShotsFired")
	
    if shots > 1 then
		if bit.band(cmd.buttons, bit.lshift(1, 0)) > 0 then
			eclipse.setViewAngles(QAngle(cmd.viewangles.x - (aimpunch.x - prev.x) * 2 * ui.getConfigFloat("x amount"), cmd.viewangles.y - (aimpunch.y - prev.y) * 2 * ui.getConfigFloat("y amount"), cmd.viewangles.z))
		end
	end
	
    prev = aimpunch
end

function onUI()
	ui.sliderFloat("x amount", "x amount", 0, 1, "%.2f")
	ui.sliderFloat("y amount", "y amount", 0, 1, "%.2f")
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("UI", onUI)
