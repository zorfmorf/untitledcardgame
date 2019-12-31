local cardgame = {}

-- dimensions of areas
local d = { pad = 10 }

--- calculate the dimensions of all card game areas depending on the current game window dimensions
local function recalculateDimensions()
    local height = love.graphics.getHeight()
    local width = love.graphics.getWidth()
    d.pad = math.floor(height * 0.02)
    d.top = {
        x = d.pad,
        y = d.pad,
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
        h = math.floor(height * 0.2 + d.pad)
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
        local w = res.card.placeholder:getWidth()
        local h = res.card.placeholder:getHeight()
        local s = 1 -- scale factor for card

        -- only scale for height, for width we overlap cards if they don't fit into the area
        if h * s > maxH then
            s = 0.5
        else
            if h * s < maxH * 0.5 then
                s = 2
            end
        end

        -- the location to the left we start to draw cards from (center of card)
        local xLoc = math.floor(0.5 * (container.x + maxW - (#cardList - 1) * w * s + d.pad * (1 - (#cardList - 1))))

        -- calculate buffer for when the container width is too small for the amount of cards so we have to overlap them
        local xLeftShift = 0
        if xLoc - w * 0.5 < container.x then
            xLeftShift = (container.x - (xLoc - w * 0.5))
            xLoc = container.x + math.floor(w * 0.5)
        end

        -- the y location, top of the card
        local yLoc = math.floor(container.y + maxH * 0.5)

        -- just draw all cards from left to right
        for i,c in ipairs(cardList) do
            love.graphics.draw(res.card.placeholder, math.floor(xLoc + (i - 1) * (w * s + d.pad - xLeftShift)),
                    yLoc, 0, s, s, math.floor(w * 0.5 * s), math.floor(h * 0.5 * s))
        end
    end
end


function cardgame:draw()

    local drawOutline = true

    -- draw the top bar
    if drawOutline then love.graphics.rectangle("line", d.top.x, d.top.y, d.top.w, d.top.h) end
    if drawOutline then love.graphics.printf("Top bar", d.top.x, d.top.y + 10, d.top.w, "center") end

    -- draw the enemy area
    if drawOutline then love.graphics.rectangle("line", d.enemy.x, d.enemy.y, d.enemy.w, d.enemy.h) end
    if drawOutline then love.graphics.printf("Enemy area", d.enemy.x, d.enemy.y + 10, d.enemy.w, "center") end
    drawCardContainer(d.enemy, { 1, 2, 3 })

    -- draw the player area
    if drawOutline then love.graphics.rectangle("line", d.player.x, d.player.y, d.player.w, d.player.h) end
    if drawOutline then love.graphics.printf("Player area", d.player.x, d.player.y + 10, d.player.w, "center") end
    drawCardContainer(d.player, { 1, 2, 3, 4 })

    -- draw the hand card area
    if drawOutline then love.graphics.rectangle("line", d.hand.x, d.hand.y, d.hand.w, d.hand.h) end
    if drawOutline then love.graphics.printf("Hand cards", d.hand.x, d.hand.y + 10, d.hand.w, "center") end

    if drawOutline then
        love.graphics.line(love.graphics.getWidth() * 0.5, 0, love.graphics.getWidth() * 0.5, love.graphics.getHeight())
    end
end


return cardgame
