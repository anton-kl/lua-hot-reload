dofile("test_setup.lua")

local file1 = [=[
    local fn = {}
    local a = 0
    function fn:GetA()
        a = a + 1
        return a
    end
    function fn:GetFunc1()
        local a = 10
        return function()
            a = a + 1
            return a
        end
    end
    function fn:GetFunc2()
        local a = 100
        return function()
            a = a + 1
            return a
        end
    end
    return fn
]=]

local file2 = [=[
    local fn = {}
    local a = 0
    function fn:GetA()
        a = a + 1
        return a
    end
    function fn:GetFunc1()
        local a = 20
        return function()
            a = a + 1
            return a
        end
    end
    function fn:GetFunc2()
        local a = 200
        return function()
            a = a + 1
            return a
        end
    end
    return fn
]=]

local obj = DoFileString(file1)
local f1 = obj:GetFunc1()
local f2 = obj:GetFunc2()
assert(obj:GetA() == 1)
assert(f1() == 11)
assert(f2() == 101)

DoFileString(file2)

assert(obj:GetA() == 2)
assert(f1() == 12)
assert(f2() == 102)
local _f1 = obj:GetFunc1()
local _f2 = obj:GetFunc2()
assert(_f1() == 21)
assert(_f2() == 201)
