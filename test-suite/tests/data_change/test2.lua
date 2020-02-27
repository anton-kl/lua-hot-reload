dofile("test_setup.lua")

local file1 = [=[
    local data = false
    return function()
        return data
    end
]=]

local file2 = [=[
    local data = true
    return function()
        return data
    end
]=]

local func = DoFileString(file1)
assert(func() == false)

ReloadFileString(file2)
assert(func() == true)

ReloadFileString(file1)
assert(func() == false)

ReloadFileString(file2)
assert(func() == true)
