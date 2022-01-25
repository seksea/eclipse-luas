--name edgebug
--desc bug the edge.
--author sekc

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
    found = false, buttons = 0, edgebugTick = 0
}

-- if edgebug found force cmd to follow this edgebug
local function forceEdgebug(cmd, localPlayer)
     -- disable edgebug if onground or past found edgebug tick
     if cmd.tickcount > successfulMove.edgebugTick and successfulMove.found then
        eclipse.clientCmd("play " .. EDGEBUG_SOUND)
        successfulMove.found = false
        return
    end
    if not localPlayer:onground() then
        successfulMove.found = false
        return
    end

    -- if edgebug is already found then set buttons to the buttons to hit edgebug with (also set forwardmove+sidemove to 0)
    if successfulMove.found then
        cmd.buttons = successfulMove.buttons
        eclipse.setCmd(cmd)
        return
    end
end

local function predictEdgebug(cmd, localPlayer)
    for i=0,64 do
        lastTickVel = localPlayer:velocity()
        prediction.start(cmd)
        prediction.end_()
        -- if edgebug found save found edgebug and set cmd so our forwardmove and sidemove are 0
        if detectEdgebug(localPlayer) then
            successfulMove.found = true
            successfulMove.buttons = cmd.buttons
            successfulMove.edgebugTick = cmd.tickcount + i
            eclipse.clientCmd("play " .. EDGEBUG_FOUND_SOUND)
            eclipse.setCmd(cmd)
        end
    end
end

function onCreateMove(cmd)
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if not localPlayer:sane() then return end

    -- set forwardmove and sidemove to 0
    cmd.forwardmove = 0
    cmd.sidemove = 0

    forceEdgebug(cmd, localPlayer)

    if not successfulMove.found then
        predictEdgebug(cmd, localPlayer)
    end
end

eclipse.registerHook("createMove", onCreateMove)