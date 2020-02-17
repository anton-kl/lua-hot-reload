dofile("test_setup.lua")

local file1 = [=[
    local t = {
        a = 10,
        b = 20
    }
    function t.Func()
        return t.a
    end
    return t
]=]

local file2 = [=[
    local t = {
        a = 100,
        b = 200
    }
    function t.Func()
        return t.b
    end
    return t
]=]

local obj = DoFileString(file1)

assert(obj.Func() == 10)

obj.a = 1
obj.b = 2

assert(obj.Func() == 1)

ReloadFileString(file2)

assert(obj.Func() == 2)
