dofile("test_setup.lua")

-- assume we don't have get_timestamp functionality
LuaReload.FileGetTimestamp = function(_)
    return 0
end

-- disable reloading for all files
LuaReload.ShouldReload = function()
    return false
end

local file1 = [=[
    return function()
        return 1
    end
]=]

local file2 = [=[
    return function()
        return 2
    end
]=]

local func = DoFileString(file1)
assert(func() == 1)

local func2 = DoFileString(file2)
assert(func2() == 1)

LuaReload.SetEnableTimestampCheck(false)

local func3 = DoFileString(file2)
assert(func() == 1)
assert(func2() == 1)
assert(func3() == 2)
