dofile("test_setup.lua")

local file1 = [=[
    local t = {
        data = 1
    }
    return t
]=]

local file2 = [=[
    local t = {
        data = 2,
        func = function() end
    }
    return t
]=]

local file3 = [=[
    local t = {
        data = 3,
    }
    t.func = function() return t.data end
    return t
]=]

local t = DoFileString(file1)
assert(t.data == 1)

ReloadFileString(file2)
assert(t.data == 2)
assert(t.func)

t.data = 100

ReloadFileString(file3)
assert(t.data == 100)
assert(t.func() == 100)
