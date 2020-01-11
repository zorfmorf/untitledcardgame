
--- Represents one container that can display cards
---
--- Extend for specific card features
Container = Class {

    init = function(self, cards)
        self.id = "uninitialized"
        self.name = "uninitialized"
        self.pad = 0
        self.x = 0
        self.y = 0
        self.w = 0
        self.h = 0
        self.cards = cards
    end

    -- !! any variables defined outside of init scoped are global !!

}


function Container:updateDimensions(data)
    self.id = data.id
    self.name = data.name
    self.pad = data.pad
    self.x = data.x
    self.y = data.y
    self.w = data.w
    self.h = data.h
end


function Container:canReceiveCard()
    return true -- TODO hook up rule lawyer
end


function Container:receiveCard(card)
    if self:canReceiveCard() then
        table.insert(self.cards, card)
    end
end


function Container:getCards()
    return self.cards
end

