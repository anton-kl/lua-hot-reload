function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1, 1)
end

function love.update(dt)
    LuaReload.Monitor()
end

function love.draw()
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print("Welcome", 32, 32)
end
