--name precache test
--desc test precache models in lua
--author sekc

memory.precacheModel("models/player/custom_player/eminem/css/t_leet.mdl")

for i, ent in pairs(entitylist.getEntitiesByClassID(40)) do
    if ent:sane() then
        ent:setModelIndex(memory.getModelIndex("models/player/custom_player/eminem/css/t_leet.mdl"))
    end
end