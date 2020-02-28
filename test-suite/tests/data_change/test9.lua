dofile("test_setup.lua")

local file1 = [=[
    return {
        data = false
    }
]=]

local file2 = [=[
    return {
        data = true,
        func = function() end
    }
]=]

local t = DoFileString(file1)
assert(t.data == false)

ReloadFileString(file2)
assert(t.data == true)
assert(t.func)

ReloadFileString(file1)
assert(t.data == false)
assert(t.func == nil)

ReloadFileString(file2)
assert(t.data == true)
assert(t.func)
