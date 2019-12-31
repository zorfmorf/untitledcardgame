local cardgame = {}

--- draw debug outlines
local drawDebugOutlines = false

--- dimensions of all card game areas. needs to be recalculated before it can be used
local d = { pad = 10 }

--- recalculate the dimensions of all card game areas depending on the current game window dimensions
local function recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)
    d.top = {
        x = d.pad,
        y = 0,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height* 0.1)
    }
    d.enemy = {
        x = d.pad,
        y = d.pad + d.top.y + d.top.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    }
    d.player = {
        x = d.pad,
        y = d.pad + d.enemy.y + d.enemy.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.3)
    }
    d.hand = {
        x = d.pad,
        y = d.pad + d.player.y + d.player.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.24)
    }
end


--- Called when entering the state
function cardgame:enter()
    self:resize()
end


--- Called on window resize
function cardgame:resize()
    recalculateDimensions()
end

--- Draws all cards into the specified container
local function drawCardContainer(container, cardList)
    if #cardList > 0 then
        local maxW = container.w
        local maxH = container.h
        local originalW = res.card.placeholder:getWidth()
        local originalH = res.card.placeholder:getHeight()
        local s = 1 -- scale factor for card
        local pad = d.pad -- might be necessary to use a separate padding

        -- only scale for height, for width we overlap cards if they don't fit into the area
        if originalH * s > maxH then
            s = 0.5
        else
            if originalH * s < maxH * 0.5 then
                s = 2
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
        for i, _ in ipairs(cardList) do

            -- start from leftmost location and add width and padding for each additional card
            -- xShift moves cards further to the center. the further away from the center, the more xShift is applied
            local x = xLoc + (i - 1) * (w + pad) + xShift * (1 - ((i - 1) / (#cardList - 1)) * 2)

            love.graphics.draw(res.card.placeholder, x,
                    yLoc, 0, s, s, math.floor(originalW * 0.5), math.floor(originalH * 0.5))

            -- draw a red dot to each card's draw position
            if drawDebugOutlines then
                love.graphics.setColor(1.0, 0.0, 0.0)
                love.graphics.rectangle("fill", x - 1, yLoc - 1, 3, 3)
                love.graphics.setColor(1.0, 1.0, 1.0)
            end
        end
    end
end


--- Draw all card containers including their cards
function cardgame:draw()

    -- draw the top bar
    if drawDebugOutlines then love.graphics.rectangle("line", d.top.x, d.top.y, d.top.w, d.top.h) end
    if drawDebugOutlines then love.graphics.printf("Top bar", d.top.x, d.top.y + 10, d.top.w, "center") end

    -- draw the enemy area
    if drawDebugOutlines then love.graphics.rectangle("line", d.enemy.x, d.enemy.y, d.enemy.w, d.enemy.h) end
    if drawDebugOutlines then love.graphics.printf("Enemy area", d.enemy.x, d.enemy.y + 10, d.enemy.w, "center") end
    drawCardContainer(d.enemy, { 1, 2 })

    -- draw the player area
    if drawDebugOutlines then love.graphics.rectangle("line", d.player.x, d.player.y, d.player.w, d.player.h) end
    if drawDebugOutlines then love.graphics.printf("Player area", d.player.x, d.player.y + 10, d.player.w, "center") end
    drawCardContainer(d.player, { 1, 2, 3, 4, 5, 6, 7, 8 })

    -- draw the hand card area
    if drawDebugOutlines then love.graphics.rectangle("line", d.hand.x, d.hand.y, d.hand.w, d.hand.h) end
    if drawDebugOutlines then love.graphics.printf("Hand cards", d.hand.x, d.hand.y + 10, d.hand.w, "center") end

    if drawDebugOutlines then
        love.graphics.line(love.graphics.getWidth() * 0.5, 0, love.graphics.getWidth() * 0.5, love.graphics.getHeight())
    end
end


return cardgame
