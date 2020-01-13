
--- Applies the game rules and decides on possible and allowed moves
--- Probably also executes them until we have to split execution off

ruler = {}


function ruler:init()

    for i=1,10 do
        globalCardState.playerStack[i] = Card(cardData.placeholder)
        globalCardState.playerStack[i]:flip()
    end

end


--- Called when the user clicks on a card
---@param card table the card that was clicked
---@param container table the container the card is currently in
function ruler:cardClick(card, container)
    log:debug("Player clicks card", card.id, card.data.title)
    if container.type == "stack" then
        if container.id == state_card_game.containers.stack.id then
            local card = container:drawCard()
            if card then
                card:flip()
                log:debug("Player draws card", card.id, card.data.title)
                state_card_game.containers.hand:put(card)
            end
        end
    else
        globalCardState.overlay = card
        log:debug("Entering overlay game state")
        GameState.push(state_card_game_overlay)
    end
end


function ruler:cardClickSecondary(card, container)
    if container.type == "stack" then
        if container.id == state_card_game.containers.stack.id then
            container:shuffle()
        end
        if container.id == state_card_game.containers.cemetery.id then
            while #container:getCards() > 0 do
                local c = container:drawCard()
                c:flip()
                state_card_game.containers.stack:put(c)
            end
            state_card_game.containers.stack:shuffle()
        end
    end
end


--- Called when the user clicks on a card
---@param card table the card that was dropped
---@param from table the container the card is currently in
---@param to table the container the card is dropped into
function ruler:cardDrop(card, from, to)
    print("Dropped card", card.data.title, "into a container")
    if not (from == to) then
        from:remove(card)
        if to.id == state_card_game.containers.stack.id or from.id == state_card_game.containers.stack.id then
            card:flip()
        end
        to:put(card)
    end
end


return ruler
