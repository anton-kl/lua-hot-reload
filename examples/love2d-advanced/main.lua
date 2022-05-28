LuaReload = dofile("../../lua_reload.lua")
LuaReload.Inject()
LuaReload.SetStoreReferencePath(true)
LuaReload.SetHandleGlobalModules(true)

require("core")
