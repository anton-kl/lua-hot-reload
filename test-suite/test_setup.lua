-- LuaReload is left global intentionally
LuaReload = dofile("../lua_reload.lua")
LuaReload.SetPrintReloadingLogs(true)
LuaReload.SetLogReferencesSteps(false)
LuaReload.SetTraverseGlobals(true)
LuaReload.SetTraverseRegistry(true)
LuaReload.SetStoreReferencePath(true)
LuaReload.Inject()

dofile("utils.lua")

local filesTimestamp = {}
local timestamp = 0

function GetTestFilename(postfix)
    return "testfile" .. (postfix and "_" .. postfix or "") .. ".lua"
end

function WriteString(text, filename)
    local file2 = io.open(filename, "w+")
    file2:write(text)
    file2:close()

    -- update the timestamp
    timestamp = timestamp + 1
    filesTimestamp[ filename ] = timestamp
end

function WriteFileString(text, postfix)
    local filename = GetTestFilename(postfix)
    WriteString(text, filename)
end

function DoFileString(text, postfix)
    local filename = GetTestFilename(postfix)
    WriteString(text, filename)
    return dofile(filename)
end

function LoadFileString(text, postfix)
    local filename = GetTestFilename(postfix)
    WriteString(text, filename)
    return loadfile(filename)
end

function ReloadFileString(text, postfix)
    WriteFileString(text, postfix)
    local fn = GetTestFilename(postfix)
    LuaReload.ReloadFile(fn)
end

function WriteFunction(func, filename)
    local file2 = io.open(filename, "w+")
    file2:write(string.dump(func))
    file2:close()

    -- update the timestamp
    timestamp = timestamp + 1
    filesTimestamp[ filename ] = timestamp
end

function WriteFileFunc(func, postfix)
    local filename = GetTestFilename(postfix)
    WriteFunction(func, filename)
end

function LoadFileFunc(func, postfix)
    local filename = GetTestFilename(postfix)
    WriteFunction(func, filename)
    return loadfile(filename)
end

function DoFileFunc(func, postfix)
    local filename = GetTestFilename(postfix)
    WriteFunction(func, filename)
    return dofile(filename)
end

function ReloadFileFunc(func, postfix)
    WriteFileFunc(func, postfix)
    local fn = GetTestFilename(postfix)
    LuaReload.ReloadFile(fn)
end

LuaReload.FileGetTimestamp = function(filename)
    return filesTimestamp[ filename ]
end