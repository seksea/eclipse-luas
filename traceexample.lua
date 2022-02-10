--name trace example
--desc runs a visible check on all entities with traceray to print current visible entities (createmove)
--author sekc

function onCreateMove()
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if not localPlayer:sane() then return end

    local begin = localPlayer:origin()
    begin.z = begin.z + 64

    for i, ent in pairs(entitylist.getEntitiesByClassID(40)) do
        if ent:sane() then
            local _end = ent:origin()
            _end.z = _end.z + 64
            local result = trace.traceSimple(begin, _end)
            if result.entityHit:sane() and (result.entityHit:index() == ent:index()) then
                print("entity " .. ent:index() .. " is visible.")
            end
        end
    end
end

eclipse.registerHook("createMove", onCreateMove)