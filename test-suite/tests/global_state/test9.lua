dofile("test_setup.lua")

LuaReload.SetHandleGlobalModules(true)

-- SKIPPED dut to not supporting crazy things like `getfenv(print)`
--[[
local file1 = [=[
    local iter = 0
    local function LocalFunc()
        log("> [OLD] iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return iter
    end
    local g = getfenv(print)
    function g.GlobalFunc()
        log("> Hello, I'm the original version of the function, and I return 1000 + iter!", debug.getinfo(1).func)
        return 1000 + LocalFunc()
    end
    return LocalFunc
]=]

local file2 = [=[
    local iter = 0
    local function LocalFunc()
        log("> [NEW] iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return 200 + iter
    end
    local g = getfenv(print)
    function g.GlobalFunc()
        local r = 2000 + LocalFunc()
        log("> Hello, I'm the new version of the function, and I return 2000 + 200 + iter!", r, debug.getinfo(1).func)
        return r
    end
]=]

local iter = DoFileString(file1)

assert(GlobalFunc() == 1001)
assert(GlobalFunc() == 1002)
assert(iter() == 3)
assert(GlobalFunc() == 1004)

WriteFileString(file2)
local fn = GetTestFilename()
LuaReload.ScheduleReload(fn)
LuaReload.ReloadScheduledFiles()


assert(GlobalFunc() == 2205)
assert(GlobalFunc() == 2206)
assert(iter() == 207)
assert(GlobalFunc() == 2208)
--]]
