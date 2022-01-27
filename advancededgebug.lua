--name advancededgebug
--desc bug the edge. (advanced)
--author sekc, vampur

-- Settings
EDGEBUG_FOUND_SOUND = "common/warning"
EDGEBUG_SOUND = "buttons/arena_switch_press_02"

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
    found = false, forwardmove = 0, sidemove = 0, angle = QAngle(0, 0, 0), delta = 0, buttons = 0, edgebugTick = 0
}

local backupMove = {
    forwardmove = 0, sidemove = 0, buttons = 0, angle = QAngle(0, 0, 0), delta = 0
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

        successfulMove.angle = QAngle(successfulMove.angle.x, successfulMove.angle.y + successfulMove.delta, 0)
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

local function onFoundEdgebug(edgebugRecord, delta, tickFoundAt, cmd, localPlayer)
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

    successfulMove.found = true
    successfulMove.angle = backupMove.angle
    cmd.viewangles = successfulMove.angle
    successfulMove.delta = delta
    successfulMove.forwardmove = cmd.forwardmove
    successfulMove.sidemove = cmd.sidemove
    successfulMove.buttons = cmd.buttons
    successfulMove.edgebugTick = cmd.tickcount + tickFoundAt
    eclipse.clientCmd("play " .. EDGEBUG_FOUND_SOUND)
    eclipse.setCmd(cmd)
end

local function predictEdgebug(cmd, localPlayer, delta)
    if not delta then delta = 0 end

    local commandsPredicted = prediction.commandsPredicted()

    local edgebugRecord = {} -- table that holds records of position of found edgebug (for edgebug trail)
    -- prediction loop
    cmd.viewangles = backupMove.angle -- restore baseline viewangles
    for i=0,ui.getConfigFloat("edgebug predict ticks") do
        lastTickVel = localPlayer:velocity()
        prediction.start(cmd)
        prediction.end_()
        
         -- add current tick to edgebug record
        edgebugRecord[i] = { ["origin"] = localPlayer:origin() }

        -- if edgebug found save found edgebug and set cmd
        if detectEdgebug(localPlayer) then
            onFoundEdgebug(edgebugRecord, delta, i, cmd, localPlayer)
            break
        end

        if localPlayer:onground() then break end

        cmd.viewangles = QAngle(cmd.viewangles.x, cmd.viewangles.y + delta, 0)
    end

    prediction.restoreToFrame(commandsPredicted - 1)
end

local edgebugLookupTable = {
    [1] = function (cmd, localPlayer) -- standing and crouching edgebug
        cmd.forwardmove = 0
        cmd.sidemove = 0
        cmd.buttons = bit.bxor(cmd.buttons, 4) -- IN_DUCK = 4
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.buttons = bit.bxor(cmd.buttons, 4) -- IN_DUCK = 4
        predictEdgebug(cmd, localPlayer)
    end,
    [2] = function (cmd, localPlayer) -- sidemove + forwardmove edgebug
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.sidemove = 450
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.sidemove = -450
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.sidemove = 0
        cmd.forwardmove = 450
        predictEdgebug(cmd, localPlayer)
        if successfulMove.found then return end
        cmd.forwardmove = -450
        predictEdgebug(cmd, localPlayer)
    end,
    [3] = function (cmd, localPlayer) -- strafe edgebug
        cmd.sidemove = 450
        predictEdgebug(cmd, localPlayer, -2)
        if successfulMove.found then return end
        predictEdgebug(cmd, localPlayer, -1)
        if successfulMove.found then return end
        cmd.sidemove = -450
        predictEdgebug(cmd, localPlayer, 2)
        if successfulMove.found then return end
        predictEdgebug(cmd, localPlayer, 1)
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

    backupMove.forwardmove = cmd.forwardmove
    backupMove.sidemove = cmd.sidemove
    backupMove.buttons = cmd.buttons
    backupMove.delta = QAngle(cmd.viewangles.x - backupMove.angle.x, cmd.viewangles.y - backupMove.angle.y, 0)
    backupMove.angle = QAngle(cmd.viewangles.x, cmd.viewangles.y, 0)

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
        ui.label("y delta: " .. successfulMove.delta)
        ui.endWindow()
    end
end

if ui.getConfigFloat("edgebug predict ticks") == 0 then
    ui.setConfigFloat("edgebug predict ticks", 64)
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("draw", onDraw)
eclipse.registerHook("UI", onUI)