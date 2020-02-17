dofile("test_setup.lua")

local file1 = [=[
    local module = {}
    function module.Func()
        return 100
    end
    function module.GetAnon()
        return function()
            return module.Func()
        end
    end
    return module
]=]

local file2 = [=[
    local module = {}
    function module.Func()
        return 200
    end
    function module.GetAnon()
        return function()
            return module.Func()
        end
    end
    return module
]=]

Module = DoFileString(file1)
func = Module.GetAnon()

assert(func() == 100)

collectgarbage()
collectgarbage()

ReloadFileString(file2)

assert(func() == 200)
