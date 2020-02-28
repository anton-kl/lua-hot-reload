dofile("test_setup.lua")

local file1 = [=[
    return {
        data = false
    }
]=]

local file2 = [=[
    return {
        data = true
    }
]=]

local t = DoFileString(file1)
assert(t.data == false)

ReloadFileString(file2)
assert(t.data == true)

ReloadFileString(file1)
assert(t.data == false)

ReloadFileString(file2)
assert(t.data == true)
