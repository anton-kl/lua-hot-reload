dofile("test_setup.lua")

local file1 = [=[
    local calls = 0
    local function Call()
        calls = calls + 1
        log("> Hello, you've called Call()", calls, "times")
        return calls, false
    end
    return {
        Call = Call
    }
]=]

local file2 = [=[
    local calls = 0
    local function Call()
        calls = calls + 1
        log("> Hello, you've called Call()", calls, "times, and I'm the new version of it")
        return calls, true
    end
    local function PrintCalls()
        log("> You've called Call()", calls, "times, and I'm PrintCalls()")
        return calls
    end
    return {
        Call = Call,
        PrintCalls = PrintCalls
    }
]=]

local obj = DoFileString(file1)

local calls, isNew = obj.Call()
assert(calls == 1)
assert(not isNew)

DoFileString(file2)

local calls, isNew = obj.Call()
assert(calls == 2)
assert(isNew)

assert(obj.PrintCalls)
local calls = obj.PrintCalls()
assert(calls == 2)
