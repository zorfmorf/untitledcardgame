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
        name = "Top bar",
        pad = d.pad,
        x = d.pad,
        y = 0,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height* 0.05)
    })
    self.containers.enemy:updateDimensions({
        name = "Enemy card area",
        pad = d.pad,
        x = d.pad,
        y = d.pad + self.containers.top.y + self.containers.top.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    })
    self.containers.player:updateDimensions({
        name = "Player card area",
        pad = d.pad,
        x = d.pad,
        y = d.pad + self.containers.enemy.y + self.containers.enemy.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    })

    local stackWidth = math.floor(width  * 0.2)
    self.containers.stack:updateDimensions({
        name = "Stack",
        pad = d.pad,
        x = d.pad,
        y = d.pad + self.containers.player.y + self.containers.player.h,
        w = stackWidth,
        h = math.floor(height * 0.3)
    })

    local cards = self.containers.hand.cards
    local handWidthMax = width - stackWidth * 2 - d.pad * 4
    local handWith = handWidthMax
    if #cards > 0 then
        local pw = cards[1]:getWidth() * cards[1]:getScale(d.id)
        handWith = math.min(pw * #cards * 0.6, handWidthMax)
    end
    self.containers.hand:updateDimensions({
        name = "Player hand card area",
        pad = d.pad,
        x = d.pad + stackWidth + d.pad + math.floor((handWidthMax - handWith) * 0.5),
        y = d.pad + self.containers.player.y + self.containers.player.h,
        w = handWith,
        h = math.floor(height * 0.3)
    })
    self.containers.cemetery:updateDimensions({
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
    self.containers.stack = StackContainer(globalCardState.playerStack)
    self.containers.cemetery = StackContainer(globalCardState.playerCemetery)
    self.containers.cemetery.flipped = true

    self:resize()

    hand:init()
end


--- Called on window resize
function cardGame:resize()
    self:recalculateDimensions()
end


--- Called on every game update cycle
---@param dt number time since last update in seconds
function cardGame:update(dt)
    for _, container in pairs(self.containers) do
        container:update(dt)
    end
    hand:update(dt)
end


--- Draw all card containers including their cards
function cardGame:draw()

    if DRAW_DEBUG_OUTLINES then
        love.graphics.line(love.graphics.getWidth() * 0.5, 0, love.graphics.getWidth() * 0.5, love.graphics.getHeight())
    end

    for _, container in pairs(self.containers) do
        container:draw()
    end

    hand:draw()

end


function cardGame:mousepressed(x, y, button, isTouch, presses)
    hand:mousepressed(x, y, button, isTouch, presses, self.containers)
end


function cardGame:mousereleased(x, y, button, isTouch, presses)
    hand:mousereleased(x, y, button, isTouch, presses, self.containers)
end


function cardGame:resume()
    self:recalculateDimensions()
end


return cardGame
