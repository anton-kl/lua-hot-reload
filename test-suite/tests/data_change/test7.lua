dofile("test_setup.lua")

local file1 = [=[
    local module = {}
    return module
]=]

local file2 = [=[
    local module = {
        data = "original"
    }
    return module
]=]

local file3 = [=[
    local module = {
        data = "original"
    }
    function module.New()
        return setmetatable({}, { __index = module })
    end
    function module:Get()
        return self.data
    end
    function module:Set(value)
        self.data = value
    end
    return module
]=]

local file4 = [=[
    local module = {
        data = "new"
    }
    function module.New()
        return setmetatable({}, { __index = module })
    end
    function module:Get()
        return self.data
    end
    function module:Set(value)
        self.data = value
    end
    return module
]=]

local module = DoFileString(file1)

ReloadFileString(file2)
assert(module.data == "original")

ReloadFileString(file3)
local obj1 = module.New()
local obj2 = module.New()
assert(obj1:Get() == "original")
assert(obj2:Get() == "original")

obj1:Set("current")
ReloadFileString(file4)
assert(obj1:Get() == "current")
assert(obj2:Get() == "new")

module.data = "current2"
ReloadFileString(file4)
assert(obj1:Get() == "current")
assert(obj2:Get() == "current2")
