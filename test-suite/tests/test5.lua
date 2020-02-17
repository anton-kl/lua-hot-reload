dofile("test_setup.lua")

local file1 = [=[
    local function localFunc()
        log("> Hello, I'm the original version of the function, and I return 5!")
        return 5
    end
    local function localFuncRemoved()
        log("> Hello, I'm the function defined in the original file which will be removed!")
        return true
    end
    return {
        func = localFunc,
        funcRemoved = localFuncRemoved
    }
]=]

local file2 = [=[
    local function localFunc()
        log("> Hello, I'm a new version of the function, and I return 10!")
        return 10
    end
    local function localFuncAdded()
        log("> Hello, I'm a new function defined in the new versin of the file!")
        return true
    end
    return {
        func = localFunc,
        funcAdded = localFuncAdded
    }
]=]

local obj = DoFileString(file1)

assert(obj.func() == 5)
assert(obj.funcRemoved ~= nil)
assert(obj.funcAdded == nil)

ReloadFileString(file2)

assert(obj.func() == 10)
assert(obj.funcRemoved == nil)
assert(obj.funcAdded ~= nil)
