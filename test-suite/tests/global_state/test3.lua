dofile("test_setup.lua")

LuaReload.SetHandleGlobalModules(true)

local file1 = [=[
    GlobalModule = GlobalModule or {}
    GlobalModule.subModule = GlobalModule.subModule or {}
    local iter = 0
    function GlobalModule.subModule.Func()
        log("> Hello, I'm the original version of the function, and I return 1000 + iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return 1000 + iter
    end
]=]

local file2 = [=[
    GlobalModule = GlobalModule or {}
    GlobalModule.subModule = GlobalModule.subModule or {}
    local iter = 0
    function GlobalModule.subModule.Func()
        log("> Hello, I'm the new version of the function, and I return 2000 + iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return 2000 + iter
    end
]=]

local iter = DoFileString(file1)

assert(GlobalModule.subModule.Func() == 1001)
assert(GlobalModule.subModule.Func() == 1002)

ReloadFileFunc(file2)

assert(GlobalModule.subModule.Func() == 2003)
assert(GlobalModule.subModule.Func() == 2004)
