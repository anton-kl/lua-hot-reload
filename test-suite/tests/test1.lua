dofile("test_setup.lua")

local file1 = [=[
    return function()
        log("> Hello, I'm the original version of the function, and I return 5!")
        return 5
    end
]=]

local file2 = [=[
    return function()
        log("> Hello, I'm a new version of the function, and I return 10!")
        return 10
    end
]=]

local func = DoFileString(file1)
local info = debug.getinfo(func, "S")
log("HELLO", info.short_src)

assert(func() == 5)

ReloadFileString(file2)

assert(func() == 10)
