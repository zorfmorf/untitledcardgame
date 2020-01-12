local cardGameOverlay = {}


--- dimensions of all card game areas. needs to be recalculated before it can be used
local d = {
    id = "overlayView"
}

--- recalculate the dimensions of all card game areas depending on the current game window dimensions
function cardGameOverlay:recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)

    -- split the width into three equal parts, with padding between all parts (and the screen border)
    local thirdWidth = math.floor((width - d.pad * 4) / 3)

    self.containers.leftText:updateDimensions({
        id = d.id,
        name = "Left text area",
        pad = d.pad,
        x = d.pad,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96)
    })

    self.containers.card:updateDimensions({
        id = d.id,
        name = "Card area",
        pad = d.pad,
        x = d.pad * 2 + thirdWidth,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96)
    })

    self.containers.rightText:updateDimensions({
        id = d.id,
        name = "Right text area",
        pad = d.pad,
        x = d.pad * 3 + 2 * thirdWidth,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96)
    })
end


--- Called when entering the state
function cardGameOverlay:enter()
    self.containers = {}

    self.containers.leftText = TextContainer(globalCardState.overlay:getLeftText())
    self.containers.card = Container( { globalCardState.overlay } )
    self.containers.rightText = TextContainer(globalCardState.overlay:getRightText())

    self.bg = love.graphics.newCanvas()
    love.graphics.setCanvas(self.bg)
    state_card_game:draw()
    love.graphics.setCanvas()

    self:resize()
end


--- Called on window resize
function cardGameOverlay:resize()
    self:recalculateDimensions()
end


--- Called on every game update cycle
---@param dt number time since last update in seconds
function cardGameOverlay:update(dt)
    self.containers.card:update(dt)
    self.containers.card:resetAnimationState()
    local scale = self.containers.card:getCurrentCardScale()

    self.containers.leftText.scale = scale
    self.containers.leftText:update(dt)

    self.containers.rightText.scale = scale
    self.containers.rightText:update(dt)
end


--- Draw all card containers including their cards
function cardGameOverlay:draw()

    love.graphics.setColor(1.0, 1.0, 1.0, 0.1)
    love.graphics.draw(self.bg)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

    for _, container in pairs(self.containers) do
        container:draw()
    end

    if DRAW_DEBUG_OUTLINES then
        -- horizontal line in center to better see alignment
        love.graphics.line(0, love.graphics.getHeight() * 0.5, love.graphics.getWidth(), love.graphics.getHeight() * 0.5)
    end
end


function cardGameOverlay:mousepressed(x, y, button, isTouch, presses)
    if button == 1 then
        if not self.containers.card:catchMouseClick(x, y) then
            GameState.pop()
        end
    end
end


function cardGameOverlay:leave()
    log:debug("Leaving overlay game state")
    globalCardState.overlay.drawPos[d.id] = nil -- TODO probably should do this through a method
    globalCardState.overlay = nil
    hand:clear()
end


return cardGameOverlay
