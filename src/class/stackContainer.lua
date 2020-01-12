
StackContainer = Class {

    __includes = { Container },

    init = function(self, cards)
        Container.init(self, cards)
    end

}


function StackContainer:shuffle()
    -- TODO
end


--- Don't update mouseover for stacks, we don't want card reactions to mouse pointers here
function StackContainer:update(dt)
    self:updateCardDrawPositions()
end


--- Just draw the topmost card for now. In the future probably add stack size indicators
function StackContainer:draw()
    if #self.cards > 0 then
        self.cards[#self.cards]:draw(self.id)
    end
end
