dofile("test_setup.lua")

local file1 = [=[
    local function f()
        log("> Hello, I'm the original version of the function1, and I return 5!")
        return 5
    end
    return "hi", nil, {
        f = f
    }
]=]

local file2 = [=[
    local function f()
        log("> Hello, I'm a new version of the function1, and I return 10!")
        return 10
    end
    return "hi", nil, {
        f = f
    }
]=]

local a, b, c = DoFileString(file1)

assert(c.f() == 5)

ReloadFileString(file2)

assert(c.f() == 10)
