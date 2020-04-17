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

-- TODO remove when vanilla Lua doesn't load new version of files
-- by default (see loadFileNew)
local isVanillaLua = type(jit) ~= "table"

local func = DoFileString(file2)
assert(isVanillaLua or func() == 1)

LuaReload.SetUseCache(false)

local func = DoFileString(file2)
assert(func() == 2)
