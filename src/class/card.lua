
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
        self.animState = { r = 0 } -- TODO replace placeholder with actual animation state
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


function Card:update(dt)
    -- TODO animation stuff goes here
end


function Card:draw(id)
    love.graphics.setColor(1.0, 1.0, 1.0)
    local d = self.drawPos[id]
    love.graphics.draw(self.img, d.x, d.y, self.animState.r, d.scale, d.scale,
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
