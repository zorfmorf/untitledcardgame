local cardGame = {}


--- dimensions of all card game areas. needs to be recalculated before it can be used
local d = {
    id = "gameView"
}

--- recalculate the dimensions of all card game areas depending on the current game window dimensions
function cardGame:recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)

    self.containers.top:updateDimensions({
        id = d.id,
        name = "Top bar",
        pad = d.pad,
        x = d.pad,
        y = 0,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height* 0.05)
    })
    self.containers.enemy:updateDimensions({
        id = d.id,
        name = "Enemy card area",
        pad = d.pad,
        x = d.pad,
        y = d.pad + self.containers.top.y + self.containers.top.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    })
    self.containers.player:updateDimensions({
        id = d.id,
        name = "Player card area",
        pad = d.pad,
        x = d.pad,
        y = d.pad + self.containers.enemy.y + self.containers.enemy.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    })

    local stackWidth = math.floor(width  * 0.2)
    self.containers.stack:updateDimensions({
        id = d.id,
        name = "Stack",
        pad = d.pad,
        x = d.pad,
        y = d.pad + self.containers.player.y + self.containers.player.h,
        w = stackWidth,
        h = math.floor(height * 0.3)
    })
    self.containers.hand:updateDimensions({
        id = d.id,
        name = "Player hand card area",
        pad = d.pad,
        x = d.pad + stackWidth + d.pad,
        y = d.pad + self.containers.player.y + self.containers.player.h,
        w = math.floor(width - stackWidth * 2 - d.pad * 4),
        h = math.floor(height * 0.3)
    })
    self.containers.cemetery:updateDimensions({
        id = d.id,
        name = "Cemetery",
        pad = d.pad,
        x = width - d.pad - stackWidth,
        y = d.pad + self.containers.player.y + self.containers.player.h,
        w = stackWidth,
        h = math.floor(height * 0.3)
    })
end


--- Called when entering the state
function cardGame:enter()

    self.containers = {}
    self.containers.top = Container({})
    self.containers.enemy = Container(globalCardState.enemyArea)
    self.containers.player = Container(globalCardState.playerArea)
    self.containers.hand = Container(globalCardState.playerHand)
    self.containers.stack = Container(globalCardState.playerStack)
    self.containers.cemetery = Container(globalCardState.playerCemetery)

    self:recalculateDimensions()
end


--- Called on window resize
function cardGame:resize()
    recalculateDimensions()
end


--- Called on every game update cycle
---@param dt number time since last update in seconds
function cardGame:update(dt)
    for _, container in pairs(self.containers) do
        cardDrawer:update(dt, container)
    end
end


--- Draw all card containers including their cards
function cardGame:draw()

    for _, container in pairs(self.containers) do
        cardDrawer:drawCardContainer(container)
    end

    if DRAW_DEBUG_OUTLINES then
        love.graphics.line(love.graphics.getWidth() * 0.5, 0, love.graphics.getWidth() * 0.5, love.graphics.getHeight())
    end
end


function cardGame:mousepressed(x, y, button, isTouch, presses)
    if button == 1 then

        local result = false
        for _, container in pairs(self.containers) do
            result = cardDrawer:catchMouseClick(container, x, y)
            if result then break end
        end

        if result then
            globalCardState.overlay = result
            log:debug("Entering overlay game state")
            GameState.push(state_card_game_overlay)
        end
    end
end


return cardGame
