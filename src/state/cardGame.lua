local cardGame = {}


--- dimensions of all card game areas. needs to be recalculated before it can be used
local d = { pad = 10 }

--- recalculate the dimensions of all card game areas depending on the current game window dimensions
local function recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)
    d.top = {
        pad = d.pad,
        x = d.pad,
        y = 0,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height* 0.1)
    }
    d.enemy = {
        pad = d.pad,
        x = d.pad,
        y = d.pad + d.top.y + d.top.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    }
    d.player = {
        pad = d.pad,
        x = d.pad,
        y = d.pad + d.enemy.y + d.enemy.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    }
    d.hand = {
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
end


--- Called on window resize
function cardGame:resize()
    recalculateDimensions()
end


--- Draw all card containers including their cards
function cardGame:draw()

    -- TODO set this card in a global game state container
    local card = Card(cards.placeholder)

    -- draw the top bar
    if DRAW_DEBUG_OUTLINES then love.graphics.rectangle("line", d.top.x, d.top.y, d.top.w, d.top.h) end
    if DRAW_DEBUG_OUTLINES then love.graphics.printf("Top bar", d.top.x, d.top.y + 10, d.top.w, "center") end

    -- draw the enemy area
    if DRAW_DEBUG_OUTLINES then love.graphics.rectangle("line", d.enemy.x, d.enemy.y, d.enemy.w, d.enemy.h) end
    if DRAW_DEBUG_OUTLINES then love.graphics.printf("Enemy area", d.enemy.x, d.enemy.y + 10, d.enemy.w, "center") end
    cardDrawer:drawCardContainer(d.enemy, { card, card })

    -- draw the player area
    if DRAW_DEBUG_OUTLINES then love.graphics.rectangle("line", d.player.x, d.player.y, d.player.w, d.player.h) end
    if DRAW_DEBUG_OUTLINES then love.graphics.printf("Player area", d.player.x, d.player.y + 10, d.player.w, "center") end
    cardDrawer:drawCardContainer(d.player, { card, card, card, card, card })

    -- draw the hand card area
    if DRAW_DEBUG_OUTLINES then love.graphics.rectangle("line", d.hand.x, d.hand.y, d.hand.w, d.hand.h) end
    if DRAW_DEBUG_OUTLINES then love.graphics.printf("Hand cards", d.hand.x, d.hand.y + 10, d.hand.w, "center") end

    if DRAW_DEBUG_OUTLINES then
        love.graphics.line(love.graphics.getWidth() * 0.5, 0, love.graphics.getWidth() * 0.5, love.graphics.getHeight())
    end
end


return cardGame
