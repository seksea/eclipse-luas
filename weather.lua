--name weather
--desc make it rain $$$$$$
--author sekc

local function getClientClassByName(name)
    local c = eclipse.getAllClientClasses()
    while c:exists() do
        if c:name() == name then
            return c
        end
        c = c:next()
    end
    return false
end

function onCreateMove(cmd)
    if not (cmd.tickcount > 0) or not (cmd.tickcount % 64 == 0) then return end
    
    local precipitation = entitylist.getEntity(2047)
    local precipitationClientClass = getClientClassByName("CPrecipitation")

    if not precipitation:exists() then
        precipitationClientClass:create(2047, 0)
    end

    precipitation = entitylist.getEntity(2047)
    if precipitation:exists() then
        precipitation:setPropInt("DT_Precipitation", "m_nPrecipType", ui.getConfigBool("weather snow") and 1 or 0)

        precipitation:preDataUpdate(0)
        precipitation:onPreDataChanged(0)
        
        precipitation:setMins(Vector(-32767, -32767, -32767))
        precipitation:setMaxs(Vector(32767, 32767, 32767))

        precipitation:onDataChanged(0)
        precipitation:postDataUpdate(0)
    end
end

function onUI()
    ui.checkbox("snow?", "weather snow")
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("UI", onUI)