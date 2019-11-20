dofile("test_setup.lua")

local file1 = [=[
    local function f()
        return 10
    end
    return { f = f }
]=]

local file2 = [=[
    local iter = 0
    local function f()
        iter = iter + 1
        return iter
    end
    return { f = f }
]=]

local t1 = DoFileString(file1)
local t2 = DoFileString(file1)

assert(t1.f() == 10)
assert(t2.f() == 10)

DoFileString(file2)

assert(t1.f() == 1)
assert(t1.f() == 2)
assert(t1.f() == 3)

assert(t2.f() == 1)
assert(t2.f() == 2)
