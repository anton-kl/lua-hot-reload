dofile("test_setup.lua")

local file1 = [=[
    local iter = 0
    return function()
        iter = iter + 1
        return iter
    end
]=]

local file2 = [=[
    local iter = 0
    return function()
        iter = iter + 2
        return iter
    end
]=]

local func1 = DoFileString(file1)
local func2 = DoFileString(file1)

assert(func1() == 1)
assert(func1() == 2)
assert(func1() == 3)

assert(func2() == 1)
assert(func2() == 2)

ReloadFileString(file2)

assert(func1() == 5)
assert(func2() == 4)
