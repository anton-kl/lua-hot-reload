local game = {}

local frames = 0

function game.Update(dt)
end

function game.Render()
    frames = frames + 1

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.origin()
    love.graphics.setShader()
    love.graphics.print(frames, 16, 16)
end

function game.OnGameStart()
end

function game.OnExit()
end

return game
