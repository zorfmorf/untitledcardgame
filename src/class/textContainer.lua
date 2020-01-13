
TextContainer = Class {

    __includes = { Container },

    init = function(self, text)
        Container.init(self, {})
        self.text = text
        self.scale = 1
        self.dragInteractions = false
    end

}

local function getTextHeight(text, width, font)
    local _, wrappedText = font:getWrap(text, width)
    return #wrappedText * font:getHeight()
end


function TextContainer:update(dt)

end


--- Draw the specified text into the given container
function TextContainer:draw()

    -- match the font size to the used scaling
    local font = r.font.pixel
    if self.scale >= 2 then font = r.font.pixelLarge end
    if self.scale <= 0.5 then font = r.font.pixelSmall end

    -- first check how much space the text is going to need
    local textHeight = getTextHeight(self.text, self.w, font)

    -- if the font doesn't fit into the big box, we need to scale it down
    if textHeight > self.h then
        if scale >= 2 then
            font = r.font.pixel
        else
            font = r.font.pixelSmall
        end
        textHeight = getTextHeight(self.text, self.w, font)
    end

    local y = math.floor(self.y + 0.5 * (self.h - textHeight))
    love.graphics.printf(self.text, font, self.x, y, self.w)
end
