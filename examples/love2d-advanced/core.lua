local pauseMsg = nil
local font = love.graphics.newFont(14)
local execFilename = "exec.lua"
local execTimestamp = love.filesystem.getInfo(execFilename).modtime
local game = require("game")

-- store the original print function once, so that when we reload this file it
-- doesn't get replaced by our new print function
do
    if not Core_LogFile then
        Core_LogFile = io.open("game.log", "w")
    end
    PrintOrig = PrintOrig or print

    local core_LogFile = Core_LogFile
    local printOrig = PrintOrig
    local string = string
    local table = table
    local tostring = tostring
    local select = select
    local function Concatenate(...)
        local nargs = select("#", ...)
        local args = {}
        for i = 1, nargs do
            args[i] = tostring((select(i, ...)))
        end

        return table.concat(args, "\t")
    end
    function print(...)
        if string.find(tostring(select(1, ...)), "%[LUAR%]%[") == 1 then
            -- Store all logs to a file
            core_LogFile:write(Concatenate(...))
            core_LogFile:write("\n")
            core_LogFile:flush()
        else
            -- Print only logs that are not lua-reloading logs
            core_LogFile:write(Concatenate(...))
            core_LogFile:write("\n")
            core_LogFile:flush()
            printOrig(...)
        end
    end
end

LuaReload.SetErrorHandler(function(fileName, errorMessage, isReloading)
    if not isReloading then
        error(errorMessage)
    end
    print(errorMessage)
    pauseMsg = errorMessage
end)

LuaReload.SetShouldReload(function(fileName)
    return fileName ~= execFilename
end)

local function SafeCall(func, ...)
    local success, msg = xpcall(func, debug.traceback, ...)
    if not success then
        print(msg)
        pauseMsg = msg
    end
end

function love.update(dt)
    local reloading = LuaReload.Monitor()
    if pauseMsg and reloading then
        pauseMsg = nil
    end
    if not pauseMsg then
        -- call your functions via SafeCall
        SafeCall(game.Update, dt)
    end

    local timestamp = love.filesystem.getInfo(execFilename).modtime
    print(timestamp)
    if timestamp ~= execTimestamp then
        pauseMsg = nil
        execTimestamp = timestamp
        SafeCall(loadfile(execFilename))
    end
end

function love.draw()
    if pauseMsg then
        love.graphics.origin()
        love.graphics.setShader()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print(pauseMsg, 16, 16)
    else
        -- do not call any of your functions if pauseMsg is set
        SafeCall(game.Render)
    end
end
