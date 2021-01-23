dofile("test_setup.lua")

local file1 = [=[
    local x = 1
    local function f()
        return function()
            return x
        end
    end
    return f
]=]

local file2 = [=[
    local x = 2
    local function f()
        return function()
            return x
        end
    end
    return f
]=]

local f_nested = DoFileString(file1)()
assert(f_nested() == 1)

ReloadFileString(file2)

assert(f_nested() == 2)
