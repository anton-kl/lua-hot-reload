dofile("test_setup.lua")

local fileNested = [=[
    local fn = {}
    local base = 100
    function fn:Util()
        return base
    end
    return fn
]=]

WriteFileString(fileNested, "nested")

local file1 = [=[
    local utils = dofile(GetTestFilename("nested"))
    return function()
        return utils:Util() + 1
    end
]=]

local file2 = [=[
    local utils = dofile(GetTestFilename("nested"))
    return function()
        return utils:Util() + 2
    end
]=]

local func = DoFileString(file1)

assert(func() == 101)

DoFileString(file2)

assert(func() == 102)
