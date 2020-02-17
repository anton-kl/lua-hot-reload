dofile("test_setup.lua")

local file1 = [=[
    local fn = {
        a = 0
    }
    function fn:GetFunc1()
        return function()
            self.a = self.a + 1
            return self.a
        end
    end
    function fn:GetFunc2()
        return function()
            self.a = self.a + 1
            return self.a
        end
    end
    return fn
]=]

local file2 = [=[
    local fn = {
        a = 0
    }
    function fn:GetFunc1()
        return function()
            self.a = self.a + 2
            return self.a
        end
    end
    function fn:GetFunc2()
        return function()
            self.a = self.a + 2
            return self.a
        end
    end
    return fn
]=]

local obj = DoFileString(file1)
local f1 = obj:GetFunc1()
local f2 = obj:GetFunc2()
assert(f1() == 1)
assert(f2() == 2)

ReloadFileString(file2)

assert(f1() == 3)
assert(f2() == 4)
local _f1 = obj:GetFunc1()
local _f2 = obj:GetFunc2()
assert(_f1() == 6)
assert(_f2() == 8)
