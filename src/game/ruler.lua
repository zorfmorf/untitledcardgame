
--- Applies the game rules and decides on possible and allowed moves
--- Probably also executes them until we have to split execution off

ruler = {}


function ruler:init()

    for i=1,2 do
        globalCardState.enemyArea[i] = Card(cards.placeholder)
    end
    for i=1,5 do
        globalCardState.playerArea[i] = Card(cards.placeholder)
    end
    globalCardState.playerCemetery[1] = Card(cards.placeholder)
    for i=1,5 do
        globalCardState.playerHand[i] = Card(cards.placeholder)
    end
    globalCardState.playerStack[1] = Card(cards.placeholder)

end


return ruler
