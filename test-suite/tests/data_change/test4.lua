dofile("test_setup.lua")

local file1 = [=[
    return {
        data = false
    }
]=]

local t = DoFileString(file1)
assert(t.data == false)

t.data = true

ReloadFileString(file1)

assert(t.data == true)
