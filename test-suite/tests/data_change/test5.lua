dofile("test_setup.lua")

local file1 = [=[
    return {
        data = "original"
    }
]=]

local file2 = [=[
    return {
        data = "new"
    }
]=]

local file3 = [=[
    return {
        data = "new2"
    }
]=]

local t = DoFileString(file1)
assert(t.data == "original")

t.data = "current"
ReloadFileString(file2)
assert(t.data == "current")

t.data = "new"
ReloadFileString(file3)
assert(t.data == "new2")
