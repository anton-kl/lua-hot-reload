dofile("test_setup.lua")

-- assume we don't have get_timestamp functionality
LuaReload.FileGetTimestamp = function(_)
    return 0
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

ReloadFileString(file2)
assert(func() == 1)

LuaReload.SetEnableTimestampCheck(false)

ReloadFileString(file2)
assert(func() == 2)

ReloadFileString(file1)
assert(func() == 1)
