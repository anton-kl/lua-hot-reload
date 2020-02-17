dofile("test_setup.lua")

local file1 = [=[
    local t = {
        a = 10,
        b = 20
    }
    local m = {}
    function t.Func()
        return t.a
    end
    return t, m
]=]

local file2 = [=[
    local t = {
        a = 100,
        b = 200
    }
    local m = {
        v = 300
    }
    function t.Func()
        return m.v
    end
    return t, m
]=]

local obj, m = DoFileString(file1)

assert(obj.Func() == 10)

ReloadFileString(file2)

assert(obj.a == 100)
assert(obj.b == 200)
assert(m.v == 300)

assert(obj.Func() == 300)
