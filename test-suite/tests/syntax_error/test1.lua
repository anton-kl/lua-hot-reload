dofile("test_setup.lua")

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

assert(file)
assert(err == nil)
assert(func() == 5)
assert(file()() == 5)
