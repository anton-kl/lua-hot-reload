dofile("test_setup.lua")

local file1 = [=[
    local function Func()
        return 100
    end
    return function()
        return function()
            return Func()
        end
    end
]=]

local file2 = [=[
    local function Func()
        return 200
    end
    return function()
        return function()
            return Func()
        end
    end
]=]

local fn = LoadFileString(file1)
local original = fn()
local func = original()


local getfenv = getfenv or function(func)
    local i = 1
    while true do
        local name, val = debug.getupvalue(func, i)
        print("getupvalue", name, val)
        if name == "_ENV" then
            return val
        elseif not name then
            break
        end
        i = i + 1
    end
    return nil
end

print(getfenv(fn))
print(getfenv(original))
print(getfenv(func))

fn = nil
original = nil

assert(func() == 100)
collectgarbage()
collectgarbage()

DoFileString(file2)

assert(func() == 200)
