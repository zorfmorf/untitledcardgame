
--- draw debug information in screens. TODO move to config file
drawDebugOutlines = false

res = {}

-- libraries
GameState = require "hump.gamestate"


-- helper tools
love.graphics.setDefaultFilter( "nearest", "nearest" )
res = require "draw.resourceLoader" -- load after scaling filter has been set
cardDrawer = require "draw.cardDrawer"

-- states
local state_card_game = require "state.cardGame"
local state_card_game_overlay = require "state.cardGameOverlay"


function love.load()
    if arg[#arg] == "-debug" then require("mobdebug.mobdebug").start() end

    GameState.registerEvents()
    --GameState.switch(state_card_game)
    GameState.switch(state_card_game_overlay)

end


function love.draw()
    love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() - 20, 5)
end


function love.update()
    love.system.getProcessorCount()
end
