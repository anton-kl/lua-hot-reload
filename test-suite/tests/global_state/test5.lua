dofile("test_setup.lua")

LuaReload.SetHandleGlobalModules(true)

local fileBaseModule = [===[
    Module = {}
    function Module:CreateModule(modulePath)
        local parent = Module
        -- split by dot
        for module in string.gmatch(modulePath, [=[[^\.]+]=]) do
            parent[module] = parent[module] or {}
            parent = parent[module]
        end
        return parent
    end
]===]

local file1 = [=[
    local module = Module:CreateModule("first.second.third")
    local iter = 0
    local function LocalFunc()
        log("> [OLD] iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return iter
    end
    function module.Func()
        log("> Hello, I'm the original version of the function, and I return 1000 + iter!", debug.getinfo(1).func)
        return 1000 + LocalFunc()
    end
    return LocalFunc
]=]

local file2 = [=[
    local module = Module:CreateModule("first.second.third")
    local iter = 0
    local function LocalFunc()
        log("> [NEW] iter", iter, debug.getinfo(1).func)
        iter = iter + 1
        return 200 + iter
    end
    function module.Func()
        local r = 2000 + LocalFunc()
        log("> Hello, I'm the new version of the function, and I return 2000 + 200 + iter!", r, debug.getinfo(1).func)
        return r
    end
]=]

DoFileString(fileBaseModule, "base_module")

local iter = DoFileString(file1)

assert(Module.first.second.third.Func() == 1001)
assert(Module.first.second.third.Func() == 1002)
assert(iter() == 3)
assert(Module.first.second.third.Func() == 1004)

WriteFileString(file2)
local fn = GetTestFilename()
LuaReload.ReloadFile(fn)


assert(Module.first.second.third.Func() == 2205)
assert(Module.first.second.third.Func() == 2206)
assert(iter() == 207)
assert(Module.first.second.third.Func() == 2208)
