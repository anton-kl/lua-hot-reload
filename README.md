# Lua Hot Reload library
[![Build Status](https://travis-ci.org/anton-kl/lua-hot-reload.svg?branch=master)](https://travis-ci.org/anton-kl/lua-hot-reload)
![Lua](https://img.shields.io/badge/Lua-5.2%2C%205.3%2C%20JIT-blue)

A single file module that allows you to hot reload Lua code in your project.

Note: this project is **in the beta stage**, it may contain bugs.

## Requirements
- LuaJIT or Lua 5.2+
- Optionally [LuaFileSystem](https://keplerproject.github.io/luafilesystem/)

As for Lua5.1, the support is very limited, unless you provide `upvalueid` and `upvaluejoin` functions via a [patch](http://lua-users.org/lists/lua-l/2010-01/msg00914.html).

LuaFileSystem is used in the integrated filesystem pooling loop which informs your game about file changes. In case you use Love2D, `love.filesystem` will be used. Note though, that filesystem pooling is slow, so for best performance you should use some filesystem watching library (e.g. [efsw](https://bitbucket.org/SpartanJ/efsw) in case of C or C++)

## Features

1. You can change the code of any file-scoped function, every instance of this function in the game will be updated immediately. Data links (upvalues) will be preserved, it will also work if a file has been loaded several times.

2. You can change values of the file-scoped variables, if they value didn't change since you loaded a file. Even if a file just returns a table with data - you can edit this table in a file and this table should be updated.

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
When you want to reload a certain file, just call the `ReloadFile` function:
```lua
luaReload.ReloadFile(filename)
```

#### Step 4
Hot reloading works best when you game detects file changes on the disk and reloads them automatically. The best option would be to integrate filesystem watching library, but for Love2D and projects that can use LuaFileSystem - there is an integrated filesystem pooling loop for fast setup. Call `luaReload.Monitor()` function several times per second, and luaReload will automatically reload any changed files. For Love2D the code could look like this:
```lua
function love.update(dt)
    luaReload.Monitor()
end
```

## Limitations

### Execution of the file shouldn't have side effects

This library doesn't parse the file, it uses debug library to get functions and data from the file. In order for a file to be reloaded, it has to be executed, so its execution should not break the game.

### Functions made inside other functions can't be updated after they are created

If a function is created inside another function, each instance of it is unique. Only new instances of this function will have new code. If you want to update all instances of such a function in real time, you should make it a local file-scoped function.

### You shouldn't rename functions

If you rename a function, or if you change the way how it can be retrieved from a file (e.g. it was in a table and you made it a local function), the library will think that old function has been removed and a new function has been added.

### Modifying global functions and data is WIP

You can execute `LuaReload.SetHandleGlobalModules(true)` to enable reloading of the files which return nothing and only contain global functions, but this feature is limited and WIP.

## Test suite
To run the test suite:

1. Install [LuaFileSystem](https://keplerproject.github.io/luafilesystem/)
2. Go to `test-suite` folder and execute `luajit run_tests.lua`

To run a specific test, or tests from a specific folder, provide the name of the file or the folder as an argument, e.g. `luajit run_tests.lua tests/env`

You can also install [inspect](https://luarocks.org/modules/kikito/inspect) for additional upvalue logs.
