local cardgame = {}

-- dimensions of areas
local d = { pad = 10 }

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
        h = math.floor(height * 0.2)
    }
    d.player = {
        x = d.pad,
        y = d.pad + d.enemy.y + d.enemy.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.4)
    }
    d.hand = {
        x = d.pad,
        y = d.pad + d.player.y + d.player.h,
        w = math.floor(width - d.pad * 2),
        h = math.floor(height * 0.2 + d.pad)
    }
end


function cardgame:enter()
    self:resize()
end


function cardgame:resize()
    recalculateDimensions()
end


function cardgame:draw()

    -- draw the top bar
    love.graphics.rectangle("line", d.top.x, d.top.y, d.top.w, d.top.h)
    love.graphics.printf("Top bar", d.top.x, d.top.y + 10, d.top.w, "center")

    -- draw the enemy area
    love.graphics.rectangle("line", d.enemy.x, d.enemy.y, d.enemy.w, d.enemy.h)
    love.graphics.printf("Enemy area", d.enemy.x, d.enemy.y + 10, d.enemy.w, "center")

    -- draw the player area
    love.graphics.rectangle("line", d.player.x, d.player.y, d.player.w, d.player.h)
    love.graphics.printf("Player area", d.player.x, d.player.y + 10, d.player.w, "center")

    -- draw the hand card area
    love.graphics.rectangle("line", d.hand.x, d.hand.y, d.hand.w, d.hand.h)
    love.graphics.printf("Hand cards", d.hand.x, d.hand.y + 10, d.hand.w, "center")
end


return cardgame