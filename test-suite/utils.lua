function log(...)
    local num = select("#", ...)
    local arg = {...}
    local msg = ""
    for i = 1, num do
        msg = msg .. tostring(arg[i]) .. " "
    end
    print(msg)
end

function Error(...)
    local num = select("#", ...)
    local arg = {...}
    local msg = ""
    for i = 1, num do
        msg = msg .. tostring(arg[i]) .. " "
    end
    error(msg)
end

function ErrorLevel(level, ...)
    local num = select("#", ...)
    local arg = {...}
    local msg = ""
    for i = 1, num do
        msg = msg .. tostring(arg[i]) .. " "
    end
    error(msg, level)
end

function CopyFile(filename1, filename2)
    local file1 = io.open(filename1, "r")
    local data = file1:read("*a")
    file1:close()

    local file2 = io.open(filename2, "w+")
    file2:write(data)
    file2:close()
end

function AssertCall(returnValues, ...)
    for i = 1, select("#", ...) do
        local expected = returnValues[i]
        local actual = select(i, ...)
        if expected ~= actual then
            ErrorLevel(3, "Value no.", i, "is expected to be [", expected, "] but it is [", actual, "]")
        end
    end
    return true
end

function AssertCallTable(returnValues, ...)
    for i = 1, select("#", ...) do
        local t_expected = returnValues[i]
        local t_actual = select(i, ...)
        for k, v in pairs(t_expected) do
            local expected = t_expected[k]
            local actual = t_actual[k]
            if expected ~= actual then
                Error("Value at [", k, "] in returned table no.", i,
                    "is expected to be [", expected, "] but it is [", actual, "]")
            end
        end
        for k, v in pairs(t_actual) do
            local expected = t_expected[k]
            local actual = t_actual[k]
            if expected ~= actual then
                Error("Value at [", k, "] in returned table no.", i,
                    "is expected to be [", expected, "] but it is [", actual, "]")
            end
        end
    end
    return true
end
