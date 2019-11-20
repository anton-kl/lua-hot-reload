dofile("test_setup.lua")

local file1 = [=[
    local calls = 0
    return function()
        calls = calls + 1
        log("> Hello, you've called this function", calls, "times")
        return calls
    end
]=]

local file2 = [=[
    local calls = 0
    return function()
        calls = calls + 1
        log("> Hello, you've called this function", calls, "times, and I'm the new version of it")
        return calls, true
    end
]=]

local func = DoFileString(file1)

assert(func() == 1)
assert(func() == 2)
assert(select(2, func()) == nil)

DoFileString(file2)

assert(func() == 4)
assert(func() == 5)
assert(select(2, func()) == true)
