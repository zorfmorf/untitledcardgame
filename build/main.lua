
if arg[#arg] == "-debug" then require("mobdebug/mobdebug").start() end

function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end
