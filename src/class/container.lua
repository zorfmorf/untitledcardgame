
local ID = 0

local function generateID()
    ID = ID + 1
    return ID
end

--- Represents one container that can display cards
---
--- Extend for specific card features
Container = Class {

    init = function(self, cards)
        self.id = generateID()
        self.type = "container"
        self.name = "uninitialized"
        self.pad = 0
        self.x = 0
        self.y = 0
        self.w = 0
        self.h = 0
        self.cards = cards
        self.dragInteractions = true
    end

    -- !! any variables defined outside of init scope are global !!

}


function Container:updateDimensions(data)
    self.name = data.name
    self.pad = data.pad
    self.x = data.x
    self.y = data.y
    self.w = data.w
    self.h = data.h
end


function Container:canReceiveCard()
    return true -- TODO hook up rule lawyer
end


function Container:put(card)
    if self:canReceiveCard() then
        table.insert(self.cards, card)
    end
end


function Container:remove(card)
    for i, c in pairs(self.cards) do
        if c.id == card.id then
            local c = table.remove(self.cards, i)
            c:removeDrawPosition(self.id)
            return c
        end
    end
end


function Container:getCards()
    return self.cards
end


function Container:update(dt)
    self:updateCardDrawPositions()
    self:updateMouseOver(dt)
    for _, card in pairs(self.cards) do
        card:update(dt)
    end
end


function Container:resetAnimationState()
    for _, card in pairs(self.cards) do
        card:resetAnimationState()
    end
end


--- Pre-calculate draw positions during update phase, so we only have to do this once. Write the result to each card,
--- so each card knows how it's displayed and can use that for easy collision resolve
---@param dt number time since
---@return number the scaling used
function Container:updateCardDrawPositions()

    local s = 1 -- scale factor for card

    local n = self:cardWidth()

    -- nothing to be done if there are no cards
    if n == 0 then return s end

    local maxW = self.w
    local maxH = self.h
    local originalW = self.cards[1]:getWidth()
    local originalH = self.cards[1]:getHeight()
    local pad = self.pad -- might be necessary to use a separate padding

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

    local xCenterOfContainer = self.x + maxW * 0.5
    local widthOfAllCards = n  * w + (n - 1) * pad

    -- the x location of the leftmost card to draw (center of card)
    local xLoc = math.floor( xCenterOfContainer - 0.5 * (widthOfAllCards - w))

    -- if there are too many cards, they will exceed the container length. in this case overlap cards by shifting
    local xShift = 0
    if xLoc - w * 0.5 < self.x then
        -- the amount the most left and right cards have to move "in" not to exceed their container bounds
        xShift = self.x - (xLoc - w * 0.5)
    end

    -- the y location for all cards in this container (center of card)
    local yLoc = math.floor(self.y + maxH * 0.5)

    -- just draw all cards from left to right
    for i, card in ipairs(self:getCards() ) do

        -- start from leftmost location and add width and padding for each additional card
        local x = xLoc + (i - 1) * (w + pad)

        -- xShift moves cards further to the center. the further away from the center, the more xShift is applied
        if n > 1 then
            x = x + xShift * (1 - ((i - 1) / (n - 1)) * 2)
        end

        card:setDrawPosition(self.id, x, yLoc, s)
    end

    return s
end


--- How many cards are next to each other. Mainly needed so that stacks can override this so they always get drawn
--- as a one card stack
function Container:cardWidth()
    return #self.cards
end


--- Draws all given cards into the specified container
---@return number the scaling used for the card
function Container:draw()

    local highLightCard = nil

    -- just draw all cards from left to right
    for _, card in ipairs(self.cards) do

        -- a held card is drawn after all the containers are finished
        if not card:isHeld() then
            -- if the card is hovered over, skip drawing now so we can draw it last (on top)
            if card.animState.mouseover.increase then
                highLightCard = card
            else
                card:draw(self.id)
            end
        end

        if DRAW_DEBUG_OUTLINES then
            -- draw a red dot to each card's draw position
            local c = love.graphics.getColor()
            love.graphics.setColor(1.0, 0.0, 0.0)
            love.graphics.rectangle("fill", card:getX(self.id) - 1, card:getY(self.id) - 1, 3, 3)
            love.graphics.setColor(c)
        end
    end

    -- draw this card last (on top) if applicable
    if highLightCard then
        highLightCard:draw(self.id)
    end

    if DRAW_DEBUG_OUTLINES then

        -- draw an outline around the container
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        love.graphics.printf(self.name, self.x, self.y + 10, self.w, "center")

    end
end


function Container:updateMouseOver(dt)
    local mouseCaught = false
    local x, y = love.mouse.getPosition()

    -- iterate in reverse so mouseover detection works correctly on overlapping cards
    for i = #self.cards, 1, -1 do
        local card = self.cards[i]
        if mouseCaught then
            card.animState.mouseover.increase = false
        else
            mouseCaught = card:checkMouseOver(x, y)
        end
    end
end


local function isInContainer(container, x, y)
    return x >= container.x and x <= container.x + container.w and
            y >= container.y and y <= container.y + container.h
end


--- See if the mouse click is hitting any of the cards in the given container.
---@return table the card that caught the click or nil
function Container:catchMouseClick(x, y, containerOnly)
    if isInContainer(self, x, y) then

        -- no further hit detection necessary in this case
        if containerOnly then return true end

        -- iterate in reverse so we correctly match overlapping cards (topmost first)
        for i = #self.cards, 1, -1 do
            if self.cards[i]:collides(self.id, x, y) then
                return self.cards[i]
            end
        end
    end
    return nil
end


function Container:getCurrentCardScale()
    if #self.cards > 0 then
        return self.cards[1]:getScale(self.id)
    end
    return 1
end


function Container:canDrag()
    return self.dragInteractions
end
