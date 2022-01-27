--name trail
--desc create a trail behind you created of beams
--author sekc

local lastPos = Vector(0, 0, 0)
function onCreateMove(cmd)
    if cmd.tickcount % 2 == 0 and cmd.tickcount > 0 then
        if eclipse.isInGame() then
            local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
            if localPlayer:sane() then
                if ui.getConfigBool("trail rainbow") then
                    ui.setConfigCol("trail color", draw.HSVtoColor((cmd.tickcount % 128) / 128, 1, 1, 1))
                end
                beam.createBeam(lastPos, localPlayer:origin(), "sprites/purplelaser1.vmt", ui.getConfigCol("trail color"), ui.getConfigFloat("trail life"), ui.getConfigFloat("trail width"), 0)
                lastPos = localPlayer:origin()
            end
        end
    end
end

function onUI()
    ui.colorPicker("trail color", "trail color")
    ui.sliderFloat("trail life", "trail life", 0, 10, "%.2f")
    ui.sliderFloat("trail width", "trail width", 0, 10, "%.2f")
    ui.checkbox("rainbow", "trail rainbow")
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("UI", onUI)