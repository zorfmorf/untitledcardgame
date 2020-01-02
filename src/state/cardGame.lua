local cardGame = {}


--- dimensions of all card game areas. needs to be recalculated before it can be used
local d = {
    id = "gameView"
}

--- recalculate the dimensions of all card game areas depending on the current game window dimensions
local function recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)
    d.top = {
        id = d.id,
        name = "Top bar",
        pad = d.pad,
        x = d.pad,
        y = 0,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height* 0.1)
    }
    d.enemy = {
        id = d.id,
        name = "Enemy card area",
        pad = d.pad,
        x = d.pad,
        y = d.pad + d.top.y + d.top.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    }
    d.player = {
        id = d.id,
        name = "Player card area",
        pad = d.pad,
        x = d.pad,
        y = d.pad + d.enemy.y + d.enemy.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    }
    d.hand = {
        id = d.id,
        name = "Player hand card area",
        pad = d.pad,
        x = d.pad,
        y = d.pad + d.player.y + d.player.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.24)
    }
end


--- Called when entering the state
function cardGame:enter()
    self:resize()

    -- TODO set this card in a global game state container
    self.cardsEnemy = {}
    for i=1,2 do
        self.cardsEnemy[i] = Card(cards.placeholder)
    end
    self.cardsPlayer = {}
    for i=1,5 do
        self.cardsPlayer[i] = Card(cards.placeholder)
    end
end


--- Called on window resize
function cardGame:resize()
    recalculateDimensions()
end


--- Called on every game update cycle
---@param dt number time since last update in seconds
function cardGame:update(dt)
    -- TODO get card lists from state
    cardDrawer:updateCardDrawPositions(dt, d.enemy, self.cardsEnemy )
    cardDrawer:updateCardDrawPositions(dt, d.player, self.cardsPlayer )
end


--- Draw all card containers including their cards
function cardGame:draw()

    -- draw the top bar
    cardDrawer:drawCardContainer(d.top, {})

    -- draw the enemy area
    cardDrawer:drawCardContainer(d.enemy, self.cardsEnemy)

    -- draw the player area
    cardDrawer:drawCardContainer(d.player, self.cardsPlayer)

    -- draw the hand card area
    cardDrawer:drawCardContainer(d.hand, {})

    if DRAW_DEBUG_OUTLINES then
        love.graphics.line(love.graphics.getWidth() * 0.5, 0, love.graphics.getWidth() * 0.5, love.graphics.getHeight())
    end
end


return cardGame
