--name pearlescent
--desc script that adds a material to the cheat named pearlescent
--author sekc

eclipse.addMaterial("pearlescent", "VertexLitGeneric", [[
"VertexLitGeneric"
{
    "$basetexture" "vgui/white_additive"
    "$nocull" "1"
    "$nofog" "1"
    "$model" "1"
    "$nocull" "0"
    "$phong" "1"
    "$phongboost" "0"
    "$basemapalphaphongmask" "1"
    "$pearlescent" "16"
}
]])

function onUnload()
    eclipse.removeMaterial("pearlescent")
end

eclipse.registerHook("unload", onUnload)