dofile("test_setup.lua")

local file1 = [=[
    return {
        basic = {
            f = function()
                return 1
            end
        },
        advanced = {
            f = function()
                return 2
            end
        }
    }
]=]

local file2 = [=[
    return {
        basic = {
            f = function()
                return 10
            end,
            f2 = function()
                return 30
            end
        },
        advanced = {
            f = function()
                return 20
            end
        },
        f = function()
            return 40
        end
    }
]=]

local t = DoFileString(file1)

assert(t.basic.f() == 1)
assert(t.advanced.f() == 2)

ReloadFileString(file2)

assert(t.basic.f() == 10)
assert(t.advanced.f() == 20)
assert(t.basic.f2() == 30)
assert(t.f() == 40)