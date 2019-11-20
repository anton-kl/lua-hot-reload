--[[
    Run this file with LuaJIT to run the test suite.
    Note: LuaFileSystem is required, download from https://keplerproject.github.io/luafilesystem/

    To run a specific test, or tests from a specific folder,
    provide the name of the file or the folder as an argument, e.g.
    > luajit run_tests.lua tests/env
]]
dofile("utils.lua")
require("lfs")

local tests = {}
local function traverse(dir)
    for entry in lfs.dir(dir) do
        if entry ~= "." and entry ~= ".." then
            entry = dir .. "/" .. entry
            local attr = lfs.attributes(entry)
            if attr.mode == "directory" then
                traverse(entry)
            elseif attr.mode == "file" and entry:sub(-3, -1) == "lua" then
                table.insert(tests, entry)
            end
        end
    end
end

local target = ({...})[1] or "tests"
local attr = lfs.attributes(target)
if not attr then
    Error(target, "doesn't exist")
end

if attr.mode == "file" then
    table.insert(tests, target)
else
    traverse(target)
end

table.sort(tests)

local succeded = {}
local failed = {}
local total = #tests

local setfenv = setfenv
if not setfenv then
    setfenv = function(chunk, env)
        local i = 1
        while true do
            local name = debug.getupvalue(chunk, i)
            if name == "_ENV" then
                debug.upvaluejoin(chunk, i, function() return env end, 1)
                break
            elseif not name then
                break
            end
            i = i + 1
        end
        return chunk
    end
end

local function MakeEnv()
    local env = {}
    env._G = env
    env.loadfile = function(...)
        local func, err = loadfile(...)
        if func then
            setfenv(func, env)
        end
        return func, err
    end
    env.dofile = function(...)
        local func = loadfile(...)
        if func then
            setfenv(func, env)
        else
            return dofile(...)
        end
        return func()
    end
    setmetatable(env, { __index = _G })
    return env
end

for i = 1, total do
    log("\n\n\n*** Running test no.", i, "from file", tests[i], "***")
    local success, message
    local test, err = loadfile(tests[i])

    if test then
        setfenv(test, MakeEnv())
        success, message = xpcall(test, debug.traceback)
    else
        success, message = false, err
    end

    if success then
        table.insert(succeded, { file = tests[i] })
        log("*** TEST SUCCEDED ***")
    else
        table.insert(failed, { file = tests[i], error = message })
        log("Error:\n" .. tostring(message))
        log("*** TEST FAILED ***")
    end
end

if #failed > 0 then
    log("\nfailed:")
    for _, entry in ipairs(failed) do
        log("  " .. entry.file .. " error: " .. (entry.error:match("([^\r\n]+)")))
    end
end

log("\n\nsucceded:", #succeded, "\nfailed:", #failed, "\ntotal:", total)

-- remove temporary files
for entry in lfs.dir(".") do
    if entry ~= "." and entry ~= ".." then
        local attr = lfs.attributes(entry)
        if attr.mode == "file" and entry:find("testfile") == 1 then
            os.remove(entry)
        end
    end
end

if #failed > 0 then
    os.exit(1)
end
