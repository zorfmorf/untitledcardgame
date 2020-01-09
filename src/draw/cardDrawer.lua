
local cardDrawer = {}


--- Pre-calculate draw positions during update phase, so we only have to do this once. Write the result to each card,
--- so each card knows how it's displayed and can use that for easy collision resolve
---@param dt number time since
---@param container table a container with dimensions to draw the cards into
---@param cardList table the list of cards to be drawn
---@return number the scaling used
function cardDrawer:updateCardDrawPositions(dt, container, cardList)

    local s = 1 -- scale factor for card

    -- nothing to be done if there are no cards
    if #cardList == 0 then return s end

    local maxW = container.w
    local maxH = container.h
    local originalW = cardList[1]:getWidth()
    local originalH = cardList[1]:getHeight()
    local pad = container.pad -- might be necessary to use a separate padding

    -- at least one card must fit into the container, so scale down card as long as necessary
    if originalH * s > maxH or originalW * s > maxW then
        while originalH * s > maxH or originalW * s > maxW do
            s = s * 0.5
        end
    else
        -- if there is a lot of space in the container, we can upscale card size to fill it out better
        while originalH * s < maxH * 0.5 and originalW * s < maxW * 0.5 do
            s = s * 2
        end
    end

    -- Use actual display width of cards for draw position calculation
    local w = math.floor(originalW * s)
    local h = math.floor(originalH * s)

    local xCenterOfContainer = container.x + maxW * 0.5
    local widthOfAllCards = #cardList * w + (#cardList - 1) * pad

    -- the x location of the leftmost card to draw (center of card)
    local xLoc = math.floor( xCenterOfContainer - 0.5 * (widthOfAllCards - w))

    -- if there are too many cards, they will exceed the container length. in this case overlap cards by shifting
    local xShift = 0
    if xLoc - w * 0.5 < container.x then
        -- the amount the most left and right cards have to move "in" not to exceed their container bounds
        xShift = container.x - (xLoc - w * 0.5)
    end

    -- the y location for all cards in this container (center of card)
    local yLoc = math.floor(container.y + maxH * 0.5)

    -- just draw all cards from left to right
    for i, card in ipairs(cardList) do

        -- start from leftmost location and add width and padding for each additional card
        local x = xLoc + (i - 1) * (w + pad)

        -- xShift moves cards further to the center. the further away from the center, the more xShift is applied
        if #cardList > 1 then
            x = x + xShift * (1 - ((i - 1) / (#cardList - 1)) * 2)
        end

        card:setDrawPosition(container.id, x, yLoc, s)
    end

    return s
end


--- Draws all given cards into the specified container
---@return number the scaling used for the card
function cardDrawer:drawCardContainer(container, cardList)

    -- just draw all cards from left to right
    for _, card in ipairs(cardList) do

        card:draw(container.id)

        if DRAW_DEBUG_OUTLINES then
            -- draw a red dot to each card's draw position
            love.graphics.setColor(1.0, 0.0, 0.0)
            love.graphics.rectangle("fill", card:getX(container.id) - 1, card:getY(container.id) - 1, 3, 3)
        end
    end

    if DRAW_DEBUG_OUTLINES then

        -- draw an outline around the container
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.rectangle("line", container.x, container.y, container.w, container.h)
        love.graphics.printf(container.name, container.x, container.y + 10, container.w, "center")

    end

end


local function getTextHeight(text, width, font)
    local _, wrappedText = font:getWrap(text, width)
    return #wrappedText * font:getHeight()
end


--- Draw the specified text into the given container
function cardDrawer:drawTextContainer(container, text, scale)

    -- match the font size to the used scaling
    local font = r.font.pixel
    if scale >= 2 then font = r.font.pixelLarge end
    if scale <= 0.5 then font = r.font.pixelSmall end

    -- first check how much space the text is going to need
    local textHeight = getTextHeight(text, container.w, font)

    -- if the font doesn't fit into the big box, we need to scale it down
    if textHeight > container.h then
        if scale >= 2 then
            font = r.font.pixel
        else
            font = r.font.pixelSmall
        end
        textHeight = getTextHeight(text, container.w, font)
    end

    local y = math.floor(container.y + 0.5 * (container.h - textHeight))
    love.graphics.printf( text, font, container.x, y, container.w)
end


local function isInContainer(container, x, y)
    return x >= container.x and x <= container.x + container.w and
            y >= container.y and y <= container.y + container.h
end


--- See if the mouse click is hitting any of the cards in the given container.
---@return table the card that caught the click or nil
function cardDrawer:catchMouseClick(container, x, y, cards)
    if isInContainer(container, x, y) then
        -- iterate in reverse so we correctly match overlapping cards (topmost first)
        for i = #cards, 1, -1 do
            if cards[i]:collides(container.id, x, y) then
                return cards[i]
            end
        end
    end
    return nil
end


function cardDrawer:update(dt, container, cards)
    cardDrawer:updateCardDrawPositions(dt, container.enemy, cards)
    cardDrawer:updateMouseOver(dt, cards)
end


function cardDrawer:updateMouseOver(dt, cards)
    local mouseCaught = false
    local x, y = love.mouse.getPosition()

    -- iterate in reverse so mouseover detection works correctly on overlapping cards
    for i = #cards, 1, -1 do
        local card = cards[i]
        if mouseCaught then
            card.animState.mouseover.increase = false
        else
            mouseCaught = card:checkMouseOver(x, y)
        end
        card:update(dt)
    end
end


return cardDrawer
