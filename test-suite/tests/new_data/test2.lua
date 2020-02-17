dofile("test_setup.lua")

local file1 = [=[
    local t = {
        a = 100
    }
    function t.Func()
        return t.a
    end
    return t
]=]

local file2 = [=[
    local t = {
        a = 100
    }
    function t.Func()
        return t.a
    end
    return t
]=]

local t = DoFileString(file1)

assert(t.Func() == 100)
t.a = 200
assert(t.Func() == 200)

ReloadFileString(file2)

assert(t.Func() == 200)

ReloadFileString(file2)

assert(t.Func() == 200)
