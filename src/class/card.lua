
--- All card information is piped through the card class object before used in the game
--- In addition, the card class object has final say on how it gets drawn
--- This will make it easier to add fancy animations in the future based on card states
Card = Class {
    init = function(self, data)
        self.d = data
        self.img = res.card[self.d.img]
        if not self.img then log:err("Could not locate card image resource", self.d.img) end
    end,

    -- TODO replace placeholder with actual animation state
    animState = { r = 0 }
}


function Card:update(dt)
    -- TODO animation stuff goes here
end


function Card:draw(x, y, s)
    love.graphics.draw(self.img, x, y, self.animState.r, s, s, math.floor(self:getWidth() * 0.5), math.floor(self:getHeight() * 0.5))
end


--- Enables us to adjust the text based on card state (effects, interactions, ...)
function Card:getLeftText()
    return self.d.leftText
end


--- Enables us to adjust the text based on card state (effects, interactions, ...)
function Card:getRightText()
    return self.d.rightText
end


function Card:getHeight()
    return self.img:getHeight()
end


function Card:getWidth()
    return self.img:getWidth()
end
