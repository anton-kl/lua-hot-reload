dofile("test_setup.lua")

-- TODO: we do not update envs properly, so this test fails

--[[
local file1 = [=[
    local f = function()
        log("> Hello, I'm the original version of the function, and I return 5!", global)
        return 5
    end
    setfenv(f, {
        f = function()
            log("> Hello, I'm the original version of the function, and I return 15!")
            return 15
        end,
        log = log,
        global = 100
    })
    return f
]=]

local file2 = [=[
    local f = function()
            log("> Hello, I'm a new version of the function, and I return 10!", global)
        return 10
    end
    setfenv(f, {
        f = function()
            log("> Hello, I'm a new version of the function, and I return 20!")
            return 20
        end,
        log = log,
        global = 100
    })
    return f
]=]

local func = DoFileString(file1)

assert(func() == 5)
local env = getfenv(func)
assert(env.f() == 15)

DoFileString(file2)

assert(getfenv(func) == env)
assert(func() == 10)
assert(env.f() == 20)
]]
