dofile("test_setup.lua")

local file1 = [=[
    return function()
        log("> Hello, I'm the original version of the function1, and I return 5!")
        return 5
    end, function()
        log("> Hello, I'm the original version of the function1, and I return 50!")
        return 50
    end
]=]

local file2 = [=[
    return function()
        log("> Hello, I'm a new version of the function1, and I return 10!")
        return 10
    end, function()
        log("> Hello, I'm a new version of the function2, and I return 100!")
        return 100
    end
]=]

local func, func2 = DoFileString(file1)

assert(func() == 5)
assert(func2() == 50)

DoFileString(file2)

assert(func() == 10)
assert(func2() == 100)
