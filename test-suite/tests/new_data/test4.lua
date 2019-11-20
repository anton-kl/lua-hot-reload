dofile("test_setup.lua")

local file1 = [=[
    local t = {
    }
    function t.New()
        local obj = {}
        setmetatable(obj, { __index = t })
        obj.myClass = t
        return obj
    end
    function t:Func()
        return 0
    end
    return t
]=]

local file2 = [=[
    local t = {
        a = 100
    }
    function t.New()
        local obj = {}
        setmetatable(obj, { __index = t })
        obj.myClass = t
        return obj
    end
    function t:Func()
        return 0
    end
    function t:GetA()
        return t.a
    end
    return t
]=]

local obj = DoFileString(file1).New()

assert(obj:Func() == 0)

DoFileString(file2)

assert(obj:Func() == 0)
assert(obj:GetA() == 100)

assert(obj.a == 100)

obj.myClass.a = 200

assert(obj:GetA() == 200)
