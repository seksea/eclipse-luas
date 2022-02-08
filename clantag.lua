--name clantag
--desc script to showcase patternscan via ffi to change clantag
--author sekc

ffi = require("ffi")

ffi.cdef("typedef void (*SendClantag)(const char*, const char*);")

local sendClantag = ffi.cast("SendClantag", memory.patternScan("engine_client.so", "55 48 89 E5 41 55 49 89 FD 41 54 BF"))
sendClantag("eclipse", "eclipse.wtf premium")