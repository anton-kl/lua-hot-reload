dofile("test_setup.lua")

local file0 = [=[
    Module = {}
    Module.__index = Module
    function Module:new()
        return setmetatable({}, Module)
    end
    function Module:GetAnon()
        return function()
            return 100
        end
    end
]=]

local file1 = [=[
    Module = {}
    Module.__index = Module
    function Module:new()
        return setmetatable({}, Module)
    end
    function Module:Func()
        return 200
    end
    function Module:GetAnon()
        return function()
            return self:Func()
        end
    end
]=]

local file2 = [=[
    Module = {}
    Module.__index = Module
    function Module:new()
        return setmetatable({}, Module)
    end
    function Module:Func()
        return 300
    end
    function Module:GetAnon()
        return function()
            return self:Func()
        end
    end
]=]

DoFileString(file0)
local obj = Module:new()
local func = obj:GetAnon()

assert(func() == 100)

collectgarbage()
collectgarbage()

ReloadFileString(file1)
--[[
assert(func() == 100)
local obj2 = Module:new()
local func2 = obj2:GetAnon()
assert(func2() == 200)

ReloadFileString(file2)

assert(func() == 100)
assert(func2() == 300)
assert(obj2:Func() == 300)
assert(obj:Func() == 300)
--]]
