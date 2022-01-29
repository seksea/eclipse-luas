--name advancededgebug
--desc bug the edge. (advanced)
--author sekc

-- Settings
EDGEBUG_FOUND_SOUND = "common/warning"
EDGEBUG_SOUND = "buttons/blip1"

local ffi = require("ffi")

-- Get Globals
ffi.cdef([[
typedef struct {
	float realtime;
	int framecount;
	float absoluteframetime;
	float absoluteframestarttimestddev;
	float curtime;
	float frametime;
	int maxClients;
	int tickcount;
	float tickInterval;
	float interpolation_amount;
	int simTicksThisFrame;
	int network_protocol;
	void* pSaveData;
	bool m_bClient;
	bool m_bRemoteClient;
} Globals;
]])
local hudUpdate = ffi.cast("void***", memory.getInterface("./csgo/bin/linux64/client_client.so", "VClient"))[0][11]
local globals = ffi.cast("Globals**", memory.getAbsoluteAddress(tonumber(ffi.cast("uintptr_t", hudUpdate)) + 13, 3, 7))

local lastTickVel = Vector(0, 0, 0)
local sv_gravity = eclipse.getConvar("sv_gravity")
local function detectEdgebug(localPlayer)
    local edgebugZVel = sv_gravity:getFloat() * 0.5 * globals[0][0].tickInterval
    return math.floor(math.abs(localPlayer:velocity().z)) == math.floor(math.abs(edgebugZVel)) and lastTickVel.z < -edgebugZVel
end

local successfulMove = {
    found = false, forwardmove = 0, sidemove = 0, angle = QAngle(0, 0, 0), delta = QAngle(0, 0, 0), buttons = 0, edgebugTick = 0
}

local backupMove = {
    forwardmove = 0, sidemove = 0, buttons = 0, angle = QAngle(0, 0, 0), delta = QAngle(0, 0, 0)
}

local binBrute = {
    highestGround = -1337420, searchDir = 1, ticksToGround = 0
}

-- if edgebug found force cmd to follow this edgebug
local function forceEdgebug(cmd, localPlayer)
    if successfulMove.found then
        -- disable edgebug if onground or past found edgebug tick
        if cmd.tickcount > successfulMove.edgebugTick then
            eclipse.clientCmd("play " .. EDGEBUG_SOUND)
            successfulMove.found = false
            return
        end

        -- if edgebug is already found then set buttons to the buttons to hit edgebug with (also set forwardmove+sidemove to 0)
        cmd.buttons = successfulMove.buttons

        successfulMove.angle = QAngle(0, successfulMove.angle.y + successfulMove.delta.y, 0)
        --normalize dat yaw real kwik
        while successfulMove.angle.y > 180 do
            successfulMove.angle.y = successfulMove.angle.y - 360
        end
        while successfulMove.angle.y < -180 do
            successfulMove.angle.y = successfulMove.angle.y + 360
        end

        cmd.viewangles = successfulMove.angle
        cmd.forwardmove = successfulMove.forwardmove
        cmd.sidemove = successfulMove.sidemove

        eclipse.startMovementFix(cmd)
        cmd.viewangles = backupMove.angle
        eclipse.endMovementFix(cmd)

        eclipse.setCmd(cmd)
        return
    end
end

local function onFoundEdgebug(edgebugRecord, tickFoundAt, cmd, localPlayer)
    -- add 5 future ticks to record so you can see edgebug direction
    for j=1,5 do
        prediction.start(cmd)
        prediction.end_()
        edgebugRecord[tickFoundAt+j] = { ["origin"] = localPlayer:origin() }
    end

    -- draw edgebug trail
    for i=0,#edgebugRecord - 1 do
        if ui.getConfigBool("edgebug trail") then
            beam.createBeam(edgebugRecord[i]["origin"], edgebugRecord[i+1]["origin"], "sprites/purplelaser1.vmt", ui.getConfigCol("edgebug trail color"), 10, 10, 0)
        end
    end
    beam.ringBeam(edgebugRecord[tickFoundAt]["origin"], 300 * (tickFoundAt/64), -300 * (tickFoundAt/64), "sprites/purplelaser1.vmt", ui.getConfigCol("edgebug trail color"), (tickFoundAt/64) * 2, 10)

    successfulMove.found = true
    successfulMove.angle = backupMove.angle
    cmd.viewangles = successfulMove.angle
    successfulMove.delta = backupMove.delta
    successfulMove.forwardmove = cmd.forwardmove
    successfulMove.sidemove = cmd.sidemove
    successfulMove.buttons = cmd.buttons
    successfulMove.edgebugTick = cmd.tickcount + tickFoundAt
    eclipse.clientCmd("play " .. EDGEBUG_FOUND_SOUND)
    eclipse.setCmd(cmd)
end

local predCount = 0
local function predictEdgebug(cmd, localPlayer)
    if successfulMove.found then return end

    local commandsPredicted = prediction.commandsPredicted()

    local edgebugRecord = {} -- table that holds records of position of found edgebug (for edgebug trail)
    -- prediction loop
    cmd.viewangles = backupMove.angle -- restore baseline viewangles

    local curPredCount = 0
    for i=0,ui.getConfigFloat("edgebug predict ticks") do
        if(predCount >= ui.getConfigFloat("edgebug predict ticks")) then break end
        
        lastTickVel = localPlayer:velocity()
        prediction.start(cmd)
        prediction.end_()
        predCount = predCount + 1
        curPredCount = curPredCount + 1
        
         -- add current tick to edgebug record
        edgebugRecord[i] = { ["origin"] = localPlayer:origin() }

        -- if edgebug found save found edgebug and set cmd so our forwardmove and sidemove are 0
        if detectEdgebug(localPlayer) then
            onFoundEdgebug(edgebugRecord, i, cmd, localPlayer)
            prediction.restoreToFrame(commandsPredicted - 1)
            break
        end

        if localPlayer:onground() then
            binBrute.ticksToGround = curPredCount
            if localPlayer:origin().z > binBrute.highestGround then
                binBrute.highestGround = localPlayer:origin().z
                binBrute.searchDir = 1
            end
            break 
        end

        if localPlayer:origin().z < binBrute.highestGround then
            binBrute.searchDir = -1
        end

        cmd.viewangles = QAngle(0, cmd.viewangles.y + backupMove.delta.y, 0)
        while cmd.viewangles.y > 180 do
            cmd.viewangles.y = cmd.viewangles.y - 360
        end
        while cmd.viewangles.y < -180 do
            cmd.viewangles.y = cmd.viewangles.y + 360
        end
    end

    prediction.restoreToFrame(commandsPredicted - 1)
end

local edgebugLookupTable = {
    [1] = function (cmd, localPlayer) -- standing/crouching/strafing edgebug
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.buttons = bit.bxor(cmd.buttons, 4) -- IN_DUCK = 4
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.buttons = bit.bxor(cmd.buttons, 4) -- IN_DUCK = 4
        cmd.forwardmove = 0
        cmd.sidemove = 0
        backupMove.delta.y = 0
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.buttons = bit.bxor(cmd.buttons, 4) -- IN_DUCK = 4
        predictEdgebug(cmd, localPlayer)
    end,
    [2] = function (cmd, localPlayer) -- BiNaRy sEaRcH EdGeBuG
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        while predCount < ui.getConfigFloat("edgebug predict ticks") do
            if predCount >= (binBrute.ticksToGround * 8) then break end
            backupMove.delta.y = backupMove.delta.y + (backupMove.delta.y/2) * binBrute.searchDir
            predictEdgebug(cmd, localPlayer)
            if successfulMove.found then break end
        end
    end
}

local count = 0
local currentTick = 0
function onCreateMove(cmd)
    currentTick = cmd.tickcount
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if not (localPlayer:sane() and localPlayer:alive()) then return end

    if not ui.isKeybinderDown("edgebug key") or localPlayer:onground() then
        successfulMove.found = false
        return
    end

    predCount = 0

    backupMove.forwardmove = cmd.forwardmove
    backupMove.sidemove = cmd.sidemove
    backupMove.buttons = cmd.buttons
    backupMove.delta = QAngle(0, cmd.viewangles.y - backupMove.angle.y, 0)
    backupMove.angle = QAngle(cmd.viewangles.x, cmd.viewangles.y, 0)

    binBrute.highestGround = -1337420
    binBrute.searchDir = 1

    forceEdgebug(cmd, localPlayer)

    count = count + 1
    if not successfulMove.found then
        edgebugLookupTable[(count % #edgebugLookupTable) + 1](cmd, localPlayer)
    end
    
    if not successfulMove.found then
        cmd.forwardmove = backupMove.forwardmove
        cmd.sidemove = backupMove.sidemove
        cmd.buttons = backupMove.buttons
        cmd.viewangles = backupMove.angle
        eclipse.setCmd(cmd)
    end

    -- do this so that other luas can stop doing things with cmd when going to
    if successfulMove.found then ui.setConfigBool("lock cmd", true)
    else ui.setConfigBool("lock cmd", false) end
end

function onUI()
    ui.label("edgebug key")
    ui.sameLine()
    ui.keybinder("edgebug key")
    ui.separator()
    ui.label("edgebug settings")
    ui.sliderInt("predict ticks", "edgebug predict ticks", 0, 256, "%d ticks")
    ui.separator()
    ui.label("trail")
    ui.checkbox("edgebug trail", "edgebug trail")
    if ui.getConfigBool("edgebug trail") then
        ui.colorPicker("edgebug trail color", "edgebug trail color")
    end
end

function onDraw()
    if successfulMove.edgebugTick > currentTick - 64 or ui.isMenuOpen() then
        ui.beginWindow("edgebug info")
        ui.label("edgebug found: " .. tostring(successfulMove.found))
        ui.label("sidemove: " .. successfulMove.sidemove)
        ui.label("forwardmove: " .. successfulMove.forwardmove)
        ui.label("yaw delta: " .. successfulMove.delta.y)
        ui.endWindow()
    end
end

if ui.getConfigFloat("edgebug predict ticks") == 0 then
    ui.setConfigFloat("edgebug predict ticks", 64)
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("draw", onDraw)
eclipse.registerHook("UI", onUI)