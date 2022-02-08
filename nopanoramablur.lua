--name nopanoramablur
--desc remove panorama blur
--author winston, sekc

local panorama_disable_blur = eclipse.getConvar("@panorama_disable_blur")
panorama_disable_blur:setInt(1)

function onUnload()
    panorama_disable_blur:setInt(0)
end

eclipse.registerHook("unload", onUnload)