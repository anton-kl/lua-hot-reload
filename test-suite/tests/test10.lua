dofile("test_setup.lua")

local file1 = [=[
    local module = {}
    local iter = 0
    local garbage = { exists = true, data = 0 } -- ensure this variable is removed when all those functions are removed

    function module.Func()
        garbage.data = garbage.data + 1 -- make this function use garbage, so garbage will be removed only when this function is removed
        iter = iter + 1
        log("[OLD] iter has been increased, it's", iter, "now")
        return iter, false
    end

    function module.GetNestedFunc()
        garbage.data = garbage.data + 1 -- make this function use garbage, so garbage will be removed only when this function is removed
        return function()
            iter = iter + 1
            log("[OLD] iter has been increased, it's", iter, "now (this is a closure returned from GetNestedFunc which can't be updated)")
            return iter, false
        end
    end

    function module.GarbageTest()
        log("[OLD] GarbageTest is called, and it uses upvalue garbage, garbage.exists is", garbage.exists)
        return garbage
    end

    return module
]=]

local file2 = [=[
    local module = {}
    local iter = 0

    function module.FuncNew()
        iter = iter + 1
        log("[NEW] iter has been increased, it's", iter, "now")
        return iter, true
    end

    return module
]=]

local obj = DoFileString(file1)
local NestedFunc = obj.GetNestedFunc()

AssertCall({ 1, false }, obj.Func())
AssertCall({ 2, false }, NestedFunc())

local garbage = obj.GarbageTest()
assert(garbage.exists)

-- store a week reference to garbage, it should be removed
local ref = setmetatable({}, { __mode = "v" })
table.insert(ref, garbage)
garbage = nil

obj.Func = nil
obj.GetNestedFunc = nil
obj.GarbageTest = nil
collectgarbage()
collectgarbage()

-- ensure "garbage" table was removed
assert(#ref == 0)

DoFileString(file2)
log("*** File has been reloaded ***")

assert(obj.Func == nil)
assert(obj.GetNestedFunc == nil)
AssertCall({ 3, true }, obj.FuncNew())
log("Anonymous function expected to be OLD:")
AssertCall({ 4, false }, NestedFunc())
AssertCall({ 5, true }, obj.FuncNew())
