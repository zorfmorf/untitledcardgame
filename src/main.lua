
-- util
require "util.util"
log = require "util.log"
require "util.constants" -- needs to be loaded after log

-- libraries
Camera = require "hump.camera"
Class = require "hump.class"
GameState = require "hump.gameState"

-- helper tools
love.graphics.setDefaultFilter( "nearest", "nearest" )
res = require "draw.resourceLoader" -- load after scaling filter has been set

-- states
state_card_game = require "state.cardGame"
state_card_game_overlay = require "state.cardGameOverlay"

-- game
globalCardState = require "game.globalCardState"
ruler = require "game.ruler"
hand = require "game.hand"
cardData = require "res.cardData"

-- classes
require "class.card"
require "class.container"
require "class.textContainer"
require "class.stackContainer"

function love.load()
    if arg[#arg] == "-debug" then require("mobDebug.mobDebug").start() end

    GameState.registerEvents()

    ruler:init()
    GameState.switch(state_card_game)

end


function love.draw()
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.setFont(r.font.pixelLarge)
    love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() - 30, 5)
end


function love.update()
    love.system.getProcessorCount()
end
