dofile("test_setup.lua")
LuaReload.SetHandleGlobalModules(true)

local file1 = [=[
    local x = 1
    local y = 2
    function G3()
        return x + y
    end
    function G()
        return x
    end
    function G2()
        return y
    end
]=]

local file2 = [=[
    local x = 1
    local y = 2
    local z = 0
    function G()
        z = z + 10
        return z + x
    end
    function G3()
        z = z + 10
        return z + x + y
    end
    function G2()
        z = z + 10
        return z + y
    end
]=]

local f_nested = DoFileString(file1)
assert(G() == 1)
assert(G2() == 2)
assert(G3() == 3)

ReloadFileString(file2)

assert(G() == 11)
assert(G2() == 22)
assert(G3() == 33)


