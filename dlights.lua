local timeToNextAlloc = 0
function onDraw()
    timeToNextAlloc = timeToNextAlloc - draw.deltaTime()
    if timeToNextAlloc < 0 then
        timeToNextAlloc = timeToNextAlloc + 3
    else
        return
    end

    for i, ent in pairs(entitylist.getEntitiesByClassID(164)) do
        if ent:sane() then
            glow.createDlight(ent:origin(), i, 3.1, Color(1, 0, 0, 1), 300, 0.1)
        end
    end
end

eclipse.registerHook("draw", onDraw)