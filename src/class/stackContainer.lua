
--- Works similar to the regular card container but all cards are drawn as a stack
--- So the card on index one is the one on top
StackContainer = Class {

    __includes = { Container },

    init = function(self, cards)
        Container.init(self, cards)
        self.type = "stack"
        self.dragInteractions = false
    end

}


function StackContainer:shuffle()
    local cardList = {}
    while #self.cards > 0 do
        table.insert(cardList, table.remove(math.random(1, #self.cards)))
    end
    -- we need to put them back into the same table so the table id stays consistent in the globalCardState TODO refactor
    for i, c in ipairs(cardList) do
        self.cards[i] = c
    end
end


--- Draw the topmost card (the one on index 1)
function StackContainer:drawCard()
    local card = nil
    if #self.cards > 0 then
        card = table.remove(self.cards, 1)
        card:removeDrawPosition(self.id)
    end
    return card
end


--- Don't update mouseover for stacks, we don't want card reactions to mouse pointers here
function StackContainer:update(dt)
    self:updateCardDrawPositions()
end


--- Just draw the topmost card for now. In the future probably add stack size indicators
function StackContainer:draw()
    love.graphics.print(#self.cards, self.x, self.y)
    if #self.cards > 0 then
        self.cards[1]:draw(self.id)
    end
end


--- Override parent method so stack containers are only ever drawn as a one card container
function StackContainer:cardWidth()
    return math.min(1, #self.cards)
end
