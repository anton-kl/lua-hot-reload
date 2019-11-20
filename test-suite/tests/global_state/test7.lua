dofile("test_setup.lua")

LuaReload.SetHandleGlobalModules(true)

list = {}

local file1 = [=[
    Module = {}
    Module.__index = Module
    function Module:new(value)
        local o = {
            value = value
        }
        setmetatable(o, Module)
        return o
    end
    function Module:GetFunc()
        table.insert(list, function(value)
            log("[OLD] self.value is", self.value, "value is", value)
            return self.value + value
        end)
    end
]=]

local file2 = [=[
    Module = {}
    Module.__index = Module
    function Module:new(value)
        local o = {
            value = value
        }
        setmetatable(o, Module)
        return o
    end
    function Module:Compute(value)
        log("[NEW] self.value is", self.value, "value is", value)
        return self.value + value + 1000
    end
    function Module:GetFunc()
        table.insert(list, function(value)
            return self:Compute(value)
        end)
    end
]=]

local file3 = [=[
    Module = {}
    Module.__index = Module
    function Module:new(value)
        local o = {
            value = value
        }
        setmetatable(o, Module)
        return o
    end
    function Module:Compute(value)
        log("[NEW2] self.value is", self.value, "value is", value)
        return self.value + value + 2000
    end
    function Module:GetFunc()
        table.insert(list, function(value)
            return self:Compute(value)
        end)
    end
]=]

DoFileString(file1)
local obj = Module:new(1)
obj:GetFunc()
obj = nil
assert(list[1](100) == 101)
table.remove(list, 1)

WriteFileString(file2)
local fn = GetTestFilename()
LuaReload.ScheduleReload(fn)
LuaReload.ReloadScheduledFiles()

local obj = Module:new(1)
obj:GetFunc()
obj = nil

assert(list[1](100) == 1101)

WriteFileString(file3)
local fn = GetTestFilename()
LuaReload.ScheduleReload(fn)
LuaReload.ReloadScheduledFiles()

assert(list[1](100) == 2101)

