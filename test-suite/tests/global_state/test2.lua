dofile("test_setup.lua")

LuaReload.SetHandleGlobalModules(true)

local file1 = [=[
    GlobalModule = {}
    local iter = 0
    function GlobalModule.Func()
        log("> Hello, I'm the original version of the function, and I return 1000 + iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return 1000 + iter
    end
    print("XXX GlobalModule: ", GlobalModule)
]=]

local file2 = [=[
    GlobalModule = {}
    local iter = 0
    function GlobalModule.Func()
        log("> Hello, I'm the new version of the function, and I return 2000 + iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return 2000 + iter
    end
    print("XXX GlobalModule new: ", GlobalModule)
]=]

local iter = DoFileString(file1)

assert(GlobalModule.Func() == 1001)
assert(GlobalModule.Func() == 1002)

ReloadFileString(file2)

assert(GlobalModule.Func() == 2003)
assert(GlobalModule.Func() == 2004)
