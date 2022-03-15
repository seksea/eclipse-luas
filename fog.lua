--name fog
--desc customise fog
--author sekc

function onCreateMove(cmd)
    if not (cmd.tickcount > 0) or not (cmd.tickcount % 64 == 0) then return end
    for i, fogController in pairs(entitylist.getEntitiesByClassID(78)) do
        if fogController:sane() then
            fogController:setPropInt("DT_FogController", "m_fog.enable", ui.getConfigBool("fog enabled") and 1 or 0)
            fogController:setPropFloat("DT_FogController", "m_fog.start", ui.getConfigFloat("fog start"))
            fogController:setPropFloat("DT_FogController", "m_fog.end", ui.getConfigFloat("fog end"))
            fogController:setPropFloat("DT_FogController", "m_fog.farz", ui.getConfigFloat("fog farz"))
            fogController:setPropFloat("DT_FogController", "m_fog.maxdensity", ui.getConfigFloat("fog density"))
            local col = ui.getConfigCol("fog color").value
            local colAsInt = (col.x * 255) + 
                            bit.lshift(col.y * 255, 8) + 
                            bit.lshift(col.z * 255, 16) + 
                            bit.lshift(col.w * 255, 24)
            fogController:setPropInt("DT_FogController", "m_fog.colorPrimary", colAsInt)
        end
    end
end

function onUI()
    ui.checkbox("fog enabled", "fog enabled")
    ui.sliderFloat("fog begin", "fog begin", 0, 10000, "%.1f")
    ui.sliderFloat("fog end", "fog end", 0, 10000, "%.1f")
    ui.sliderFloat("fog farz", "fog farz", 0, 10000, "%.1f")
    ui.sliderFloat("fog density", "fog density", 0, 1, "%.2f")
    ui.colorPicker("fog color", "fog color")
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("UI", onUI)