dofile("test_setup.lua")

local file1 = [=[
    local function localFunc()
        return 5
    end
    local function memberFunc1()
        log("> Hello, I'm the original version of the memberFunc1, and I return 15!")
        return 10 + localFunc()
    end
    local function memberFunc2()
        log("> Hello, I'm the original version of the memberFunc2, and I return 25!")
        return 20 + localFunc()
    end
    return {
        memberFunc1 = memberFunc1,
        memberFunc2 = memberFunc2
    }, 1000
]=]

local file2 = [=[
    local function localFunc()
        return 10
    end
    local function memberFunc1()
        -- reference to the localFunc is removed here, so we are forced to follow a second route
        -- (return values/1/memberFunc2/upvalue localFunc)
        log("> Hello, I'm the new version of the memberFunc1, and I return 100!")
        return 100
    end
    local memberFunc2 = nil
    return {
        memberFunc1 = memberFunc1,
        memberFunc2 = memberFunc2
    }, {}
]=]

local obj = DoFileString(file1)
local memberFunc2 = obj.memberFunc2
assert(obj.memberFunc1() == 15)
assert(obj.memberFunc2() == 25)
assert(memberFunc2() == 25)

DoFileString(file2)

assert(obj.memberFunc1() == 100)
assert(memberFunc2 == nil)
