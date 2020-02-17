dofile("test_setup.lua")

local file1 = [=[
    local t = {}
    function t.Func()
    end
    return t
]=]

local file2 = [=[
    local t = {
        data = 10
    }
    function t.Func()
    end
    return t
]=]

local t = DoFileString(file1)

assert(t.data == nil)

ReloadFileString(file2)

assert(t.data == 10)
