dofile("test_setup.lua")

local file1 = [=[
    local t = {
    }
    function t.Func()
        return 0
    end
    return t
]=]

local file2 = [=[
    local t = {
        a = 100
    }
    function t.Func()
        return 0
    end
    function t.GetA()
        return t.a
    end
    return t
]=]

local t = DoFileString(file1)

assert(t.Func() == 0)

ReloadFileString(file2)

assert(t.Func() == 0)
assert(t.GetA() == 100)

assert(t.a == 100)

t.a = 200

assert(t.GetA() == 200)
