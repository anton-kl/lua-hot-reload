LuaReload = dofile("../../lua_reload.lua")
LuaReload.Inject()
LuaReload.SetPrintReloadingLogs(false)

dofile("core.lua")
