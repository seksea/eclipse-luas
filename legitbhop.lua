--name legitbhop
--desc legit auto bhop that imitates mousewheel bhop as to look legit on demo
--author sekc

local bhopTick = 0
local jumpThisTick = false
local currentTick = 0
function onCreateMove(cmd)
    currentTick = cmd.tickcount
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if not (localPlayer:sane() and localPlayer:alive()) then return end

    if not ui.isKeybinderDown("bhop key") or ui.getConfigBool("lock cmd") then return end

    local goingToHitFloorSoon = false
    local commandsPredicted = prediction.commandsPredicted();
    
    for i=0,10 do
        prediction.start(cmd)
        prediction.end_()
        if localPlayer:onground() then
            goingToHitFloorSoon = true
            bhopTick = cmd.tickcount
        end
    end

    prediction.restoreToFrame(commandsPredicted - 1)

    if goingToHitFloorSoon or cmd.tickcount - bhopTick < 6 then
        if cmd.tickcount % 2 == 0 then
            cmd.buttons = bit.bxor(cmd.buttons, 2)
            eclipse.setCmd(cmd)
            jumpThisTick = true
        else
            jumpThisTick = false
        end
    end
end

function onUI()
    ui.keybinder("bhop key")
end

function onDraw()
    if currentTick - bhopTick < 6 or bhopTick > currentTick or ui.isMenuOpen() then
        ui.beginWindow("legit bhop info")
        ui.label(jumpThisTick and "+jump" or "-jump")
        ui.endWindow()
    end
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("UI", onUI)
eclipse.registerHook("draw", onDraw)