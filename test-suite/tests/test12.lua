dofile("test_setup.lua")

local file1 = [=[
    local module = {}

    local module2 = {}
    function module2:Func()
        self.a = 20
    end
    
    function module:Func()
        module2:Func()
        self.a = 10
        return function()
            self.a = 10
        end
    end
    
    return module
]=]

local file2 = [=[
    local module = {}

    local module2 = {}
    function module2:Func()
        self.a = 20
    end
    
    function module:Func()
        module2:Func()
        self.a = 10
        return function()
            self.a = 10
        end
    end
    
    return module
]=]

local obj = DoFileString(file1)

local a = obj:Func()

--assert(obj.func() == 5)

DoFileString(file2)

--assert(obj.func() == 10)
