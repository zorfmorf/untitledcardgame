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
        h = math.floor(height* 0.05)
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

    local stackWidth = math.floor(width  * 0.2)
    d.stack = {
        id = d.id,
        name = "Stack",
        pad = d.pad,
        x = d.pad,
        y = d.pad + d.player.y + d.player.h,
        w = stackWidth,
        h = math.floor(height * 0.3)
    }
    d.hand = {
        id = d.id,
        name = "Player hand card area",
        pad = d.pad,
        x = d.pad + stackWidth + d.pad,
        y = d.pad + d.player.y + d.player.h,
        w = math.floor(width - stackWidth * 2 - d.pad * 4),
        h = math.floor(height * 0.3)
    }
    d.cemetery = {
        id = d.id,
        name = "Cemetery",
        pad = d.pad,
        x = width - d.pad - stackWidth,
        y = d.pad + d.player.y + d.player.h,
        w = stackWidth,
        h = math.floor(height * 0.3)
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


--- Called on every game update cycle
---@param dt number time since last update in seconds
function cardGame:update(dt)
    -- TODO refactor this
    cardDrawer:updateCardDrawPositions(dt, d.enemy, globalCardState.enemyArea )
    cardDrawer:updateCardDrawPositions(dt, d.player, globalCardState.playerArea )
    cardDrawer:updateCardDrawPositions(dt, d.hand, globalCardState.playerHand )
    cardDrawer:updateCardDrawPositions(dt, d.stack, globalCardState.playerStack )
    cardDrawer:updateCardDrawPositions(dt, d.cemetery, globalCardState.playerCemetery )

    cardDrawer:updateMouseOver(dt, globalCardState.enemyArea)
    cardDrawer:updateMouseOver(dt, globalCardState.playerArea)
    cardDrawer:updateMouseOver(dt, globalCardState.playerHand)
    cardDrawer:updateMouseOver(dt, globalCardState.playerStack)
    cardDrawer:updateMouseOver(dt, globalCardState.playerCemetery)
end


--- Draw all card containers including their cards
function cardGame:draw()

    -- TODO refactor this
    cardDrawer:drawCardContainer(d.top, {})
    cardDrawer:drawCardContainer(d.enemy, globalCardState.enemyArea)
    cardDrawer:drawCardContainer(d.player, globalCardState.playerArea)
    cardDrawer:drawCardContainer(d.hand, globalCardState.playerHand)
    cardDrawer:drawCardContainer(d.stack, globalCardState.playerStack)
    cardDrawer:drawCardContainer(d.cemetery, globalCardState.playerCemetery)

    if DRAW_DEBUG_OUTLINES then
        love.graphics.line(love.graphics.getWidth() * 0.5, 0, love.graphics.getWidth() * 0.5, love.graphics.getHeight())
    end
end


function cardGame:mousepressed(x, y, button, isTouch, presses)
    if button == 1 then
        -- TODO refactor this and include other card containers
        local result = cardDrawer:catchMouseClick(d.enemy, x, y, globalCardState.enemyArea)
        if not result then
            result = cardDrawer:catchMouseClick(d.player, x, y, globalCardState.playerArea)
        end
        if result then
            globalCardState.overlay = result
            log:debug("Entering overlay game state")
            GameState.push(state_card_game_overlay)
        end
    end
end


return cardGame
