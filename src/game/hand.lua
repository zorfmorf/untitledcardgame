
--- Represents the hand of the player (aka the mouse pointer)

--- keeps track of what is interacted with and how

local hand = {}

function hand:init()
    self:clear()
end


--- Clear all mouse state information
function hand:clear()
    self.leftClick = nil
    self.leftClickTime = 0
    self.rightClick = nil
    self.rightClickTime = 0
    self.holding = nil
end


--- Called when a hold action is started (delayed after click)
---@param click table object containing card and container
---@param sx number original x position of click
---@param sy number original y position of click
function hand:hold(click, sx, sy)
    self.holding = click
    print("holding", click.card.data.title, click.container.id)
    click.card:hold(click.container.id, sx, sy)
end


function hand:update(dt)
    if not self.holding then
        if self.leftClick then
            self.leftClickTime = self.leftClickTime + dt
            if self.leftClickTime >= CLICK_TIME_HOLD and self.leftClick.container:canDrag() then
                self:hold(self.leftClick, self.leftClick.x, self.leftClick.y)
            end
        end
        if self.rightClick then
            self.rightClickTime = self.rightClickTime + dt
        end
    end
end


function hand:catchMouse(x, y, containers, containerOnly)
    local result
    for _, container in pairs(containers) do
        result = container:catchMouseClick(x, y, containerOnly)
        if result then
            result = { card = result, container = container}
            break
        end
    end
    return result
end


function hand:mousepressed(x, y, button, isTouch, presses, containers)
    if not self.holding then
        local result = self:catchMouse(x, y, containers, false)

        if result then
            result.x = x
            result.y = y
            if button == MOUSE_LEFT then
                self.leftClick = result
                self.leftClickTime = 0
            end
            if button == MOUSE_RIGHT then
                self.rightClick = result
                self.rightClickTime = 0
            end
        end
    end
end


function hand:mousereleased( x, y, button, istouch, presses, containers)
    if self.holding then
        local result = self:catchMouse(x, y, containers, true)
        if result then
            ruler:cardDrop(self.holding.card, self.holding.container, result.container)
        end
        self.holding.card:drop()
    else
        local result = self:catchMouse(x, y, containers, false)
        if result then
            if button == MOUSE_LEFT then
                if self.leftClick and result.card == self.leftClick.card and self.leftClickTime < CLICK_TIME_HOLD then
                    ruler:cardClick(result.card, result.container)
                end
            end
            if button == MOUSE_RIGHT then
                if self.rightClick and result.card == self.rightClick.card and self.rightClickTime < CLICK_TIME_HOLD then
                    ruler:cardClickSecondary(result.card, result.container)
                end
            end
        end

    end
    self:clear()
end


--- draw mouse pointer or card if applicable
function hand:draw()
    if self.holding then
        self.holding.card:draw(self.holding.container.id)
    end
end


return hand
