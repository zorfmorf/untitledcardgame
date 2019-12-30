Gamestate = require "hump.gamestate"

local state_card_game = require("state.cardgame")


function love.load()
    if arg[#arg] == "-debug" then require("mobdebug.mobdebug").start() end

    Gamestate.registerEvents()
    Gamestate.switch(state_card_game)
end


function love.draw()
    love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() - 20, 5)
end


function love.update()
    love.system.getProcessorCount()
end
