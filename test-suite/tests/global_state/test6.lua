dofile("test_setup.lua")

LuaReload.SetHandleGlobalModules(true)

-- TODO we do not update data in global tables yet, so this test fails
--[[
local file1 = [=[
    GlobalModule = {
        iter = 0
    }
    function GlobalModule:Func()
        log("> Hello, I'm the original version of the function, and I return 1000 + iter", self.iter, debug.getinfo(1).func)
        self.iter = self.iter + 1
        return 1000 + self.iter
    end
]=]

local file2 = [=[
    GlobalModule = {
        iter = 0
    }
    function GlobalModule:Func()
        log("> Hello, I'm the new version of the function, and I return 2000 + iter", self.iter, debug.getinfo(1).func)
        self.iter = self.iter + 1
        return 2000 + self.iter
    end
]=]

local iter = DoFileString(file1)

assert(GlobalModule:Func() == 1001)
assert(GlobalModule:Func() == 1002)

ReloadFileString(file2)

assert(GlobalModule:Func() == 2003)
assert(GlobalModule:Func() == 2004)
]]
