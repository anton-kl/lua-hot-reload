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
local status, err = pcall(dofile, GetTestFilename())

assert(status == false)
assert(err)
print("BELOW ERROR is expected:")
print(err)
