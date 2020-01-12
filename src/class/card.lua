
local ID = 0

local function generateID()
    ID = ID + 1
    return ID
end

--- Represents one single "physical card object" on the virtual game table
---
--- All card information is piped through the card class object before used in the game
--- In addition, the card class object has final say on how it gets drawn
--- This will make it easier to add fancy animations in the future based on card states
Card = Class {

    init = function(self, data)
        self.id = generateID()
        self.data = shallowCopy(data) -- we don't want to deep copy the image objects
        self.back = res.card.back -- load this from the settings somewhere or something
        self.drawPos = {} -- container to save draw positions into
        self.flipped = false -- whether to flip the cards in around
        self:resetAnimationState()
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


function Card:removeDrawPosition(id)
    self.drawPos[id] = nil
end


function Card:resetAnimationState()
    self.animState = {
        mouseover = { increase = false, dt = 0.0 },
        r = 0
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

    if self.held then
        self.held.x = self.held.x + (self.held.ox - self.held.x) * dt * CARD_LATCH_SPEED
        self.held.y = self.held.y + (self.held.oy - self.held.y) * dt * CARD_LATCH_SPEED
    end
end


function Card:generateImage()
    local font = r.font.pixel
    local base = res.card[self.data.base]
    self.img = love.graphics.newCanvas(base:getWidth(), base:getHeight())
    love.graphics.setCanvas(self.img)
    love.graphics.setFont(font)
    love.graphics.draw(base, 0, 0)
    love.graphics.setColor(0, 0, 0)
    local textW = self.img:getWidth() - 6
    love.graphics.printf(self.data.title, 3, -1, textW, "center")
    local w, t = font:getWrap(self.data.description, textW)
    if #t > 4 then love.graphics.setFont(r.font.pixelSmaller) end
    w, t = r.font.pixelSmaller:getWrap(self.data.description, textW)
    if #t > 5 then love.graphics.setFont(r.font.pixelSmall) end
    love.graphics.printf(self.data.description, 3, math.floor(self.img:getHeight() * 0.55), textW, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.setCanvas()
    if not self.img then log:err("Could not locate card image resource", self.data.img) end
end


function Card:draw(id)
    if not self.img then self:generateImage() end

    local img = self.img
    if self.flipped then img = self.back end

    --love.graphics.setColor(1.0, 1.0, 1.0)
    local dt = self.animState.mouseover.dt
    local d = self.drawPos[id]
    local s = self:getDrawScale(id) -- increase size on mouse over

    local x = d.x
    local y = d.y

    if self.held then
        -- draw a red rectangle at the origin position
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(1.0, 0.5, 0.5, 0.8)
        love.graphics.rectangle("line", math.floor(d.x - self:getWidth() * 0.5), math.floor(d.y - self:getHeight() * 0.5), self:getWidth(), self:getHeight())
        love.graphics.setColor(r, g, b, a)

        x = love.mouse.getX() + self.held.x
        y = love.mouse.getY() + self.held.y
    end

    -- love.graphics.setBlendMode("alpha", "premultiplied") TODO find out if or when we need this
    love.graphics.draw(img, x, math.floor(y - dt * 10), self.animState.r, s, s,
            math.floor(self:getWidth() * 0.5), math.floor(self:getHeight() * 0.5))
    -- love.graphics.setBlendMode("alpha")
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
    return self.back:getHeight()
end


function Card:getWidth()
    return self.back:getWidth()
end


function Card:getX(id)
    return self.drawPos[id].x
end


function Card:getY(id)
    return self.drawPos[id].y
end


function Card:isFlipped()
    return self.flipped
end


function Card:flip()
    self.flipped = not self.flipped
end


--- Return the current card scale used for the given container id
---@param id number Container id to calculate the scale for
function Card:getScale(id)
    if self.drawPos[id] then return self.drawPos[id].scale else return 1 end
end


--- Return the current card scale used for the given container id when drawing the card (modified from regular scale)
---@param id number Container id to calculate the scale for
function Card:getDrawScale(id)
    return self:getScale(id) * (1 + self.animState.mouseover.dt * 0.05)
end


--- Check if the given mouse position collides with the card position for the assigned container id
---@return boolean collision or not
function Card:collides(id, x, y)
    local t = self.drawPos[id]
    local w = self:getWidth() * self:getDrawScale(id) * 0.5
    local h = self:getHeight() * self:getDrawScale(id) * 0.5
    return x >= t.x - w and x <= t.x + w and y >= t.y - h and y <= t.y + h
end


--- Called when the card is held by the mouse
---@param sx number original x position of hold point
---@param sy number original y position of hold point
function Card:hold(id, sx, sy)
    local t = self.drawPos[id]
    local x, y = love.mouse.getPosition()
    self.held = {
        ox = t.x - sx,
        oy = t.y - sy,
        x = t.x - x,
        y = t.y - y
    }
end


function Card:drop()
    self.held = nil
end


function Card:isHeld()
    return self.held
end
