dofile("test_setup.lua")

local file1 = [=[
    local module = {}
    module.__index = module
    function module:new()
        return setmetatable({}, module)
    end
    function module:Func()
        return 100
    end
    function module:GetAnon()
        return function()
            return self:Func()
        end
    end
    return module
]=]

local file2 = [=[
    local module = {}
    module.__index = module
    function module:new()
        return setmetatable({}, module)
    end
    function module:Func()
        return 200
    end
    function module:GetAnon()
        return function()
            return self:Func()
        end
    end
    return module
]=]

Module = DoFileString(file1)
obj = Module:new()
func = obj:GetAnon()

assert(func() == 100)

collectgarbage()
collectgarbage()

ReloadFileString(file2)

assert(func() == 200)
