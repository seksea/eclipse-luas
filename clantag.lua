--name custom clantag
--desc script to showcase patternscan via ffi to change clantag
--author sekc / sumandora

ffi = require("ffi")

ffi.cdef("typedef void (*SendClantag)(const char*, const char*);")

local sendClantag = ffi.cast("SendClantag", memory.patternScan("engine_client.so", "55 48 89 E5 41 55 49 89 FD 41 54 BF"))

local lastClantag = ""

function onCreateMove(cmd)
	local text = ui.getConfigStr("clantag")
	local anim = ui.getConfigFloat("animation")

	local len = string.len(text) + 1
	
	if len > 2 and anim > 0 then
		local cycle = math.floor(cmd.tickcount / anim)
		text = text .. " " .. text .. " "
		text = string.sub(text, cycle % len, cycle % len + len - 1)
	end
	
	if not (lastClantag == text) then
		sendClantag(text, text)

		lastClantag = text
	end
end

function onUI()
	ui.textInput("clantag", "clantag")
	ui.sliderInt("animation", "animation", 0, 64, "changes every %d tick(s)")
end

function onUnload()
	sendClantag("", "")
end

eclipse.registerHook("createMove", onCreateMove)
eclipse.registerHook("UI", onUI)
eclipse.registerHook("unload", onUnload)
