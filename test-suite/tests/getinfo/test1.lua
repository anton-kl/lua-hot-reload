dofile("test_setup.lua")

local file1 = [=[
    local iter = 0
    return {
        f1 = function()
            iter = iter + 1
            return iter
        end,
        f2 = function()
            log("f2 called, which uses global log")
            iter = iter + 1
            return iter
        end
    }
]=]

local file2 = [=[
    local iter = 0
    local const = 0
    return {
        setConst = function(value)
            const = value
        end,
        f1 = function()
            iter = iter + 2
            return iter, const
        end,
        f2 = function()
            log("f2 called, which uses global log")
            iter = iter + 2
            return iter, const
        end
    }
]=]

local t = DoFileString(file1)

assert(t.f1() == 1)
assert(t.f1() == 2)
assert(t.f2() == 3)
assert(t.f2() == 4)

DoFileString(file2)

AssertCall({6, 0}, t.f1())
AssertCall({8, 0}, t.f2())
t.setConst(10)
AssertCall({10, 10}, t.f2())
AssertCall({12, 10}, t.f1())
