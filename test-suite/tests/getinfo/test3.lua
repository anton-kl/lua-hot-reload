dofile("test_setup.lua")

local file1 = [=[
    local t = {}
    local function f1()
    end
    local function f2()
    end
    return f1, f2, t
]=]

local file2 = [=[
    local iter = 0
    local t = {}
    local function f1()
        iter = iter + 1
        return iter
    end
    local function f2()
        iter = iter + 1
        return iter
    end
    return f1, f2, t
]=]

local file3 = [=[
    local iter = 0
    local t = {}
    local function f1()
        iter = iter + 1
        return iter, t.a
    end
    local function f2()
        iter = iter + 1
        return iter, t.a
    end
    return f1, f2, t
]=]

local f1, f2, t = DoFileString(file1)
t.a = 100

DoFileString(file1)
collectgarbage()
collectgarbage()
ReloadFileString(file2)

assert(f1() == 1)
assert(f2() == 2)

DoFileString(file3)

AssertCall({ 3, 100 }, f1())
AssertCall({ 4, 100 }, f2())
