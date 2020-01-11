local cardGameOverlay = {}


--- dimensions of all card game areas. needs to be recalculated before it can be used
local d = {
    id = "overlayView"
}

--- recalculate the dimensions of all card game areas depending on the current game window dimensions
local function recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)

    -- split the width into three equal parts, with padding between all parts (and the screen border)
    local thirdWidth = math.floor((width - d.pad * 4) / 3)
    d.leftText = {
        id = d.id,
        name = "Left text area",
        pad = d.pad,
        x = d.pad,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96),
        getCards = function() return { } end -- little bit of a dirt hack but I can't be arsed to refactor this again
    }
    d.card = {
        id = d.id,
        name = "Card area",
        pad = d.pad,
        x = d.pad * 2 + thirdWidth,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96),
        getCards = function() return { globalCardState.overlay } end -- see above
    }
    d.rightText = {
        id = d.id,
        name = "Right text area",
        pad = d.pad,
        x = d.pad * 3 + 2 * thirdWidth,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96),
        getCards = function() return { } end -- see above
    }
end


--- Called when entering the state
function cardGameOverlay:enter()
    self:resize()
end


--- Called on window resize
function cardGameOverlay:resize()
    recalculateDimensions()
end


--- Called on every game update cycle
---@param dt number time since last update in seconds
function cardGameOverlay:update(dt)
    cardDrawer:updateCardDrawPositions(dt, d.card)
end


--- Draw all card containers including their cards
function cardGameOverlay:draw()

    local card = globalCardState.overlay

    -- draw the card container
    cardDrawer:drawCardContainer(d.card, { card })
    cardDrawer:drawTextContainer(d.leftText, card:getLeftText(), card:getScale(d.id))
    cardDrawer:drawTextContainer(d.rightText, card:getRightText(), card:getScale(d.id))

    if DRAW_DEBUG_OUTLINES then
        -- horizontal line in center to better see alignment
        love.graphics.line(0, love.graphics.getHeight() * 0.5, love.graphics.getWidth(), love.graphics.getHeight() * 0.5)
    end
end


function cardGameOverlay:mousepressed(x, y, button, isTouch, presses)
    if button == 1 then
        if not cardDrawer:catchMouseClick(d.card, x, y, { globalCardState.overlay }) then
            GameState.pop()
        end
    end
end


function cardGameOverlay:leave()
    log:debug("Leaving overlay game state")
    globalCardState.overlay.drawPos[d.id] = nil -- TODO probably should do this through a method
    globalCardState.overlay = nil
end


return cardGameOverlay
