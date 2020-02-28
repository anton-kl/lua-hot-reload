dofile("test_setup.lua")

local file1 = [=[
    local module = {}
    local data = "original"
    function module:Get()
        return data
    end
    function module:Set( value )
        data = value
    end
    return module
]=]

local file2 = [=[
    local module = {}
    local data = "new"
    function module:Get()
        return data
    end
    function module:Set( value )
        data = value
    end
    return module
]=]

local file3 = [=[
    local module = {}
    local data = "new2"
    function module:Get()
        return data
    end
    function module:Set( value )
        data = value
    end
    return module
]=]

local module = DoFileString(file1)
assert(module:Get() == "original")

module:Set("current")
ReloadFileString(file2)
assert(module:Get() == "current")

module:Set("new")
ReloadFileString(file3)
assert(module:Get() == "new2")
