dofile("test_setup.lua")

local file1 = [=[
    return { value = 5 }
]=]

local file2 = [=[
    return { value = 10 }
]=]

local func = DoFileString(file1)

func = nil
collectgarbage()

local cache = LuaReload.GetFileCache()
local file = cache[ GetTestFilename() ]
for k, v in pairs(file.returnValues) do
    error("return values are still present!")
end
