dofile("test_setup.lua")
LuaReload.SetUseOldFileOnError(false)

local file1 = [=[
    return function()
        return 5
    end
]=]

local file2 = [=[
    return function()
        syntax error is here!!!
    end
]=]

local func = DoFileString(file1)

assert(func() == 5)

WriteFileString(file2)

print("BELOW ERROR is expected:")
local file, err = loadfile(GetTestFilename())
print("BELOW ERROR is expected:")
print(err)

assert(file == nil)
assert(err)
assert(func() == 5)
