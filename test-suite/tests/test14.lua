dofile("test_setup.lua")

local file = [=[
    local fn = {}
    local steps = 0
    function fn:Step()
        steps = steps + 1
        return 1, steps
    end
    return fn
]=]

local obj = DoFileString(file)
AssertCall({ 1, 1 }, obj:Step())

local file = [=[
    local fn = {}
    local steps = 0
    function fn:Step()
        steps = steps + 1
        return 2, steps
    end
    function fn:GetSteps()
        return 2, steps
    end
    return fn
]=]

DoFileString(file)
AssertCall({ 2, 2 }, obj:Step())
AssertCall({ 2, 2 }, obj:GetSteps())

local file = [=[
    local fn = {}
    local steps = 0
    local const = 10
    fn.const = 100
    function fn:Step()
        steps = steps + 1
        return 3, steps, const
    end
    function fn:GetSteps()
        return 3, steps
    end
    function fn:GetConst()
        return 3, const, fn.const
    end
    return fn
]=]

DoFileString(file)
AssertCall({ 3, 3, 10 }, obj:Step())
AssertCall({ 3, 3 }, obj:GetSteps())
AssertCall({ 3, 10, 100 }, obj:GetConst())

local file = [=[
    local fn = {}
    local steps = 0
    local const = 10
    fn.const = 100
    local module = {
        GetSteps = function()
            return 4, steps
        end
    }
    function fn:Step()
        steps = steps + 1
        return 4, steps, const
    end
    function fn:GetSteps()
        return 4, steps, module.GetSteps()
    end
    function fn:GetConst()
        return 4, const, fn.const
    end
    return fn
]=]

DoFileString(file)
AssertCall({ 4, 4, 10 }, obj:Step())
AssertCall({ 4, 4, 4, 4 }, obj:GetSteps())
AssertCall({ 4, 10, 100 }, obj:GetConst())

local file = [=[
    local fn = {}
    local steps = 0
    local const = 10
    fn.const = 100
    local module = {
        GetSteps = function()
            return steps
        end
    }
    function fn:Step()
        steps = steps + 1
        return { steps = steps, const = const }
    end
    function fn:GetSteps()
        return { steps = steps, moduleSteps = module.GetSteps() }
    end
    function fn:GetConst()
        return { const = const, fnConst = fn.const }
    end
    function fn:ReturnTable()
        return { a = 1, b = 2 }
    end
    return fn
]=]

DoFileString(file)
AssertCallTable({{ steps = 5, const = 10 }}, obj:Step())
AssertCallTable({{ steps = 5, moduleSteps = 5 }}, obj:GetSteps())
AssertCallTable({{ const = 10, fnConst = 100 }}, obj:GetConst())
print(obj)
print(getmetatable(obj))
AssertCallTable({{ a = 1, b = 2 }}, obj:ReturnTable())

local file = [=[
    local fn = {}
    local steps = 0
    local const = 10
    fn.const = 100
    local module = {
        GetSteps = function()
            return steps
        end
    }
    function fn:Step()
        steps = steps + 1
        return { steps = steps, const = const }
    end
    function fn:GetSteps()
        return { steps = steps, moduleSteps = module.GetSteps() }
    end
    function fn:GetConst()
        return { const = const, fnConst = fn.const }
    end
    function fn:ReturnFunc1()
        return function()
            return self:GetSteps()
        end
    end
    function fn:ReturnFunc2()
        return function()
            return self:GetSteps()
        end
    end
    return fn
]=]

DoFileString(file)
local f1 = obj:ReturnFunc1()
local f2 = obj:ReturnFunc2()
AssertCallTable({{ steps = 6, const = 10 }}, obj:Step())
AssertCallTable({{ steps = 6, moduleSteps = 6 }}, obj:GetSteps())
AssertCallTable({{ const = 10, fnConst = 100 }}, obj:GetConst())

local file = [=[
    local fn = {}
    local steps = 0
    local const = 10
    fn.const = 100
    local module = {
        GetSteps = function()
            return steps
        end
    }
    function fn:Step()
        steps = steps + 1
        return { steps = steps, const = const }
    end
    function fn:GetSteps()
        return { steps = steps, moduleSteps = module.GetSteps() }
    end
    function fn:GetConst()
        return { const = const, fnConst = fn.const }
    end
    function fn:ReturnFunc1()
        return function()
            return self:GetSteps()
        end
    end
    function fn:ReturnFunc2()
        return function()
            return self:GetSteps()
        end
    end
    return fn
]=]

DoFileString(file)
AssertCallTable({{ steps = 7, const = 10 }}, obj:Step())
AssertCallTable({{ steps = 7, moduleSteps = 7 }}, obj:GetSteps())
AssertCallTable({{ const = 10, fnConst = 100 }}, obj:GetConst())
