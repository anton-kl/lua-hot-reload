dofile("test_setup.lua")

local file1 = [=[
    local data = 1
    return function()
        return data
    end
]=]

local file2 = [=[
    local data = 2
    return function()
        return data
    end
]=]

local func = DoFileString(file1)
assert(func() == 1)

ReloadFileString(file2)
assert(func() == 2)

ReloadFileString(file1)
assert(func() == 1)

ReloadFileString(file2)
assert(func() == 2)
