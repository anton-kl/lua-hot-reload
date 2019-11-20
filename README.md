# Lua Hot Reload library
[![Build Status](https://travis-ci.org/anton-kl/lua-hot-reload.svg?branch=master)](https://travis-ci.org/anton-kl/lua-hot-reload)
![Lua](https://img.shields.io/badge/Lua-5.2%2C%20JIT-blue.svg)

A single file module that allows you to hot reload Lua code in your project.

Note: this project is **in alpha stage**, it may contain major bugs.

## Requirements
- LuaJIT or Lua 5.2+
- Optionally [LuaFileSystem](https://keplerproject.github.io/luafilesystem/)

As for Lua5.1, the support is very limited, unless you provide `upvalueid` and `upvaluejoin` functions via a [patch](http://lua-users.org/lists/lua-l/2010-01/msg00914.html).

LuaFileSystem is used in the integrated filesystem pooling loop which informs your game about file changes. In case you use Love2D, `love.filesystem` will be used. Note though, that filesystem pooling is slow, so for best performance you should use some filesystem watching library (e.g. [efsw](https://bitbucket.org/SpartanJ/efsw) in case of C or C++)

## Integration

#### Step 1
Add `lua_reload.lua` file to your project

#### Step 2
Load it and call the `Inject` function. You should do this as early as possible, since only files loaded after this call will be available for hot reloading.
```lua
local luaReload = require("lua_reload")
luaReload.Inject()
```

#### Step 3
When you want to reload a certain file, call `ScheduleReload` to schedule a file to be reloaded, and `ReloadScheduledFiles` to reload all scheduled files now. For example:
```lua
local function ReloadFile(filename)
    luaReload.ScheduleReload(filename)
    luaReload.ReloadScheduledFiles()
end
```

#### Step 4
Hot reloading works best when you game detects file changes on the disk and reloads them automatically. The best option would be to integrate filesystem watching library, but for Love2D and projects that can use LuaFileSystem - there is an integrated filesystem pooling loop for fast setup. Call `luaReload.Monitor()` function several times per second, and luaReload will automatically reload any changed files. For Love2D the code could look like this:
```lua
function love.update(dt)
    luaReload.Monitor()
end
```

## Test suite
To run the whole test suite:

1. Install [LuaFileSystem](https://keplerproject.github.io/luafilesystem/)
2. Go to `test-suite` folder and execute `luajit run_tests.lua`

To run a specific test, or tests from a specific folder, provide the name of the file or the folder as an argument, e.g. `luajit run_tests.lua tests/env`
