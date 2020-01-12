
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
    globalCardState.playerStack[1]:flip()

end


--- Called when the user clicks on a card
---@param card table the card that was clicked
---@param container table the container the card is currently in
function ruler:cardClick(card, container)
    globalCardState.overlay = card
    log:debug("Entering overlay game state")
    GameState.push(state_card_game_overlay)
end


--- Called when the user clicks on a card
---@param card table the card that was dropped
---@param from table the container the card is currently in
---@param to table the container the card is dropped into
function ruler:cardDrop(card, from, to)
    print("Dropped card", card.data.title, "into a container")
    if not (from == to) then
        from:remove(card)
        to:put(card)
    end
end


return ruler
