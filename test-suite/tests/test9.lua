dofile("test_setup.lua")

local file1 = [=[
    local module = {}
    local iter = 0

    function module.Func()
        iter = iter + 1
        log("[OLD] iter has been increased, it's", iter, "now")
        return iter, false
    end

    function module.GetNestedFunc()
        return function()
            iter = iter + 1
            log("[OLD] iter has been increased, it's", iter, "now (this is a closure returned from GetNestedFunc which can't be updated)")
            return iter, false
        end
    end

    return module
]=]

local file2 = [=[
    local module = {}
    local iter = 0

    function module.Func()
        iter = iter + 1
        log("[NEW] iter has been increased, it's", iter, "now")
        return iter, true
    end

    function module.GetNestedFunc()
        return function()
            iter = iter + 1
            log("[NEW] iter has been increased, it's", iter, "now (this is a closure retrieved from the new version of the file)")
            return iter, true
        end
    end

    return module
]=]

local obj = DoFileString(file1)
local NestedFunc = obj.GetNestedFunc()

AssertCall({ 1, false }, obj.Func())
AssertCall({ 2, false }, NestedFunc())

DoFileString(file2)
local NestedFuncNew = obj.GetNestedFunc()
log("*** File has been reloaded ***")

AssertCall({ 3, true }, obj.Func())
log("Anonymous function expected to be OLD:")
AssertCall({ 4, false }, NestedFunc())
AssertCall({ 5, true }, NestedFuncNew())
AssertCall({ 6, true }, obj.Func())
