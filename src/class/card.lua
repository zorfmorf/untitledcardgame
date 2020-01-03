
--- Represents one single "physical card object" on the virtual game table
---
--- All card information is piped through the card class object before used in the game
--- In addition, the card class object has final say on how it gets drawn
--- This will make it easier to add fancy animations in the future based on card states
Card = Class {

    init = function(self, data)
        self.id = math.random(1000000, 99999999)
        self.data = data
        self.img = res.card[self.data.img]
        self.drawPos = {} -- container to save draw positions into
        self.animState = {
            mouseover = { increase = false, dt = 0.0 },
            r = 0
        }
        if not self.img then log:err("Could not locate card image resource", self.data.img) end
    end,

    -- !! any variables defined outside of init scoped are global !!

}


--- Set the current draw position. Can't be calculated internally because in a container with more than one card
--- the draw position is complicated to calculate and dependent on all the cards and their state
function Card:setDrawPosition(id, x, y, scale)
    self.drawPos[id] = {
        x = x,
        y = y,
        scale = scale
    }
end


function Card:checkMouseOver(x, y)
    self.animState.mouseover.increase = false
    for _, pos in pairs(self.drawPos) do
        local w = self:getWidth() * pos.scale * 0.5
        local h = self:getHeight() * pos.scale * 0.5
        if x >= pos.x - w and x <= pos.x + w and y >= pos.y - h and y <= pos.y + h then
            self.animState.mouseover.increase = true
        end
    end
    return self.animState.mouseover.increase
end


function Card:update(dt)
    if self.animState.mouseover.increase then
        self.animState.mouseover.dt = math.min(1.0, self.animState.mouseover.dt + dt * 8)
    else
        self.animState.mouseover.dt = math.max(0, self.animState.mouseover.dt - dt * 16)
    end
end

function Card:draw(id)
    love.graphics.setColor(1.0, 1.0, 1.0)
    local dt = self.animState.mouseover.dt
    local d = self.drawPos[id]
    local s = d.scale * (1 + dt * 0.05) -- increase size on mouse over
    love.graphics.draw(self.img, d.x, math.floor(d.y - dt * 10), self.animState.r, s, s,
            math.floor(self:getWidth() * 0.5), math.floor(self:getHeight() * 0.5))
end


--- Enables us to adjust the text based on card state (effects, interactions, ...)
function Card:getLeftText()
    return self.data.leftText
end


--- Enables us to adjust the text based on card state (effects, interactions, ...)
function Card:getRightText()
    return self.data.rightText
end


function Card:getHeight()
    return self.img:getHeight()
end


function Card:getWidth()
    return self.img:getWidth()
end


function Card:getX(id)
    return self.drawPos[id].x
end


function Card:getY(id)
    return self.drawPos[id].y
end


function Card:getScale(id)
    return self.drawPos[id].scale
end


function Card:collides(id, x, y)
    local t = self.drawPos[id]
    local w = self:getWidth() * t.scale * 0.5
    local h = self:getHeight() * t.scale * 0.5
    return x >= t.x - w and x <= t.x + w and y >= t.y - h and y <= t.y + h
end
