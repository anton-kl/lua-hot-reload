dofile("test_setup.lua")

local file1 = [=[
    local function f2()
    end
    return function()
        return 0, f2
    end
]=]

local file2 = [=[
    local iter = 0
    local function f2()
        iter = iter + 1
    end
    return function()
        return iter, f2
    end
]=]

local file3 = [=[
    local iter = 0
    local function f2()
        iter = iter + 2
    end
    return function()
        return iter, f2
    end
]=]

local f = DoFileString(file1)
local iter, f2 = f()
assert(iter == 0)
f2()
assert(f() == 0)

DoFileString(file2)

f2()
assert(f() == 1)

local iter, f2 = f()
assert(iter == 1)
f2()
assert(f() == 2)

DoFileString(file3)

f2()
assert(f() == 4)

local iter, f2 = f()
assert(iter == 4)
f2()
assert(f() == 6)
