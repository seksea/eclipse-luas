--name trace example
--desc runs a trace from player's viewangles and prints debug trace results on-screen
--author sekc


local traceResult = {}

function onCreateMove(cmd)
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if not localPlayer:sane() then return end
    
    local begin = localPlayer:origin()
    begin.z = begin.z + 64

    local forward = eclipse.angleVector(cmd.viewangles)

    local _end = Vector(begin.x + (forward.x * 4096), begin.y + (forward.y * 4096), begin.z + (forward.z * 4096))

    traceResult = trace.traceSimple(begin, _end)
end

function onDraw()
    ui.beginWindow("trace debug")
    ui.label("surfaceName: " .. traceResult.surfaceName)
    ui.label("slopeAngle: " .. traceResult.slopeAngle)
    ui.label("contents: " .. traceResult.contents)
    ui.label("distance: " .. traceResult.fraction*4096 .. "units")
    ui.separator()
    if traceResult.entityHit:sane() then
        ui.label("entity: " .. traceResult.entityHit:index())
        ui.label("hitbox: " .. traceResult.hitbox)
        ui.label("hitgroup: " .. traceResult.hitgroup)
    end
    ui.endWindow()
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("draw", onDraw)