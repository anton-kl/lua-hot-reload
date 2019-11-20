dofile("test_setup.lua")

local file1 = [=[
    local fn = {}
    function fn:Func()
        self.a = self.a or 10
        return self.a
    end
    local self = 100
    fn.Hello = function()
        return self
    end
    return fn
]=]

local file2 = [=[
    local fn = {}
    function fn:Func()
        self.a = self.a or 100
        return self.a + 1
    end
    local self = 200
    fn.Hello = function()
        return self
    end
    return fn
]=]

local obj = DoFileString(file1)
assert(obj:Func() == 10)
assert(obj.Hello() == 100)
DoFileString(file2)
assert(obj:Func() == 11)
assert(obj.Hello() == 200)
