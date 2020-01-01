local cardGameOverlay = {}


--- dimensions of all card game areas. needs to be recalculated before it can be used
local d = { pad = 10 }

--- recalculate the dimensions of all card game areas depending on the current game window dimensions
local function recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)

    -- split the width into three equal parts, with padding between all parts (and the screen border)
    local thirdWidth = math.floor((width - d.pad * 4) / 3)
    d.leftText = {
        pad = d.pad,
        x = d.pad,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96)
    }
    d.card = {
        pad = d.pad,
        x = d.pad * 2 + thirdWidth,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96)
    }
    d.rightText = {
        pad = d.pad,
        x = d.pad * 3 + 2 * thirdWidth,
        y = d.pad,
        w = thirdWidth,
        h = math.floor(height * 0.96)
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


--- Draw all card containers including their cards
function cardGameOverlay:draw()

    -- draw the card container
    if drawDebugOutlines then love.graphics.rectangle("line", d.card.x, d.card.y, d.card.w, d.card.h) end
    if drawDebugOutlines then love.graphics.printf("Card area", d.card.x, d.card.y + 10, d.card.w, "center") end
    local scale = cardDrawer:drawCardContainer(d.card, { 1 })

    -- draw the left text box
    if drawDebugOutlines then love.graphics.rectangle("line", d.leftText.x, d.leftText.y, d.leftText.w, d.leftText.h) end
    if drawDebugOutlines then love.graphics.printf("Left text area", d.leftText.x, d.leftText.y + 10, d.leftText.w, "center") end
    cardDrawer:drawTextContainer(d.leftText, "This is some formatted text for the left side", scale)


    -- draw the right text box
    local rText = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\n\nAt vero eos et accusam et justo duo dolores et ea rebum."
    if drawDebugOutlines then love.graphics.rectangle("line", d.rightText.x, d.rightText.y, d.rightText.w, d.rightText.h) end
    if drawDebugOutlines then love.graphics.printf("Right text area", d.rightText.x, d.rightText.y + 10, d.rightText.w, "center") end
    cardDrawer:drawTextContainer(d.rightText, rText, scale)

    if drawDebugOutlines then
        love.graphics.line(0, love.graphics.getHeight() * 0.5, love.graphics.getWidth(), love.graphics.getHeight() * 0.5)
    end
end


return cardGameOverlay
