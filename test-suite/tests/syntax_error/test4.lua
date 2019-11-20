dofile("test_setup.lua")

local file1 = [=[
    return function()
        return 5
    end
]=]

local file2 = [=[
    return function()
        syntax error is here!!!
    end
]=]

local func = DoFileString(file1)

assert(func() == 5)

WriteFileString(file2)

LuaReload.SetErrorHandler(function(fileName, errorMessage, isReloading)
    error("ERROR catched: " .. errorMessage)
end)

local status, err = pcall(loadfile, GetTestFilename())

assert(status == false)
assert(err)
print("BELOW ERROR is expected:")
print(err)
