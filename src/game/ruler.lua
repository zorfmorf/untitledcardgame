
--- Applies the game rules and decides on possible and allowed moves
--- Probably also executes them until we have to split execution off

ruler = {}


function ruler:init()

    self.cardsEnemy = {}
    for i=1,2 do
        globalCardState.enemyArea[i] = Card(cards.placeholder)
    end
    self.cardsPlayer = {}
    for i=1,5 do
        globalCardState.playerArea[i] = Card(cards.placeholder)
    end

end


return ruler
