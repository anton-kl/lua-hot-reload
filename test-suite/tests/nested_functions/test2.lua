dofile("test_setup.lua")

local file1 = [=[
    local x = 1
    local function f()
        return function()
            return x
        end
    end
    local function f2()
    end
    return f, f2
]=]

local file2 = [=[
    local x = 10
    local function f()
        return function()
            x = x + 1
            return x
        end
    end
    local function f2()
    end
    return f, f2
]=]

local file3 = [=[
    local x = 10
    local function f()
        return function()
            return 5
        end
    end
    local function f2()
        x = x + 100
        return x
    end
    return f, f2
]=]

local f1, f2 = DoFileString(file1)
f_nested = f1()
assert(f_nested() == 1)

ReloadFileString(file2)
f_nested2 = f1()
assert(f_nested() == 10)
assert(f_nested2() == 11)

ReloadFileString(file3)
f_nested3 = f1()
assert(f_nested() == 11)
assert(f_nested2() == 12)
assert(f_nested3() == 5)
assert(f2() == 112)