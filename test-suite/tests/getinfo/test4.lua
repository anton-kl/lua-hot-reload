dofile("test_setup.lua")

local file1 = [=[
    local function f()
        return 10
    end
    return f
]=]

local file2 = [=[
    local iter = 0
    local function f()
        iter = iter + 1
        return iter
    end
    return f
]=]

local f1 = DoFileString(file1)
local f2 = DoFileString(file1)

assert(f1() == 10)
assert(f2() == 10)

DoFileString(file2)

assert(f1() == 1)
assert(f1() == 2)
assert(f1() == 3)

assert(f2() == 1)
assert(f2() == 2)
