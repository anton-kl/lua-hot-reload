dofile("test_setup.lua")

local file1 = [=[
    local module = {}
    local data = "original"
    function module.MakeAnon()
        return function()
            return data
        end
    end
    return module
]=]

local file2 = [=[
    local module = {}
    local data = "new"
    function module.MakeAnon()
        return function()
            return data
        end
    end
    return module
]=]

local module = DoFileString(file1)
local anon = module.MakeAnon()
assert(anon() == "original")

module = nil
collectgarbage()
collectgarbage()
assert(anon() == "original")

ReloadFileString(file2)
assert(anon() == "new")
