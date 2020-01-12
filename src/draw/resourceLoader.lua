
r = {}

r.card = {}
r.card.back = love.graphics.newImage("res/card/back.png")
r.card.base = love.graphics.newImage("res/card/base.png")

r.font = {}
r.font.pixel = love.graphics.newFont("res/font/pixel-uniCode.ttf", 16, "normal")
r.font.pixelSmaller = love.graphics.newFont("res/font/pixel-uniCode.ttf", 12, "normal")
r.font.pixelLarge = love.graphics.newFont("res/font/pixel-uniCode.ttf", 32, "normal")
r.font.pixelSmall = love.graphics.newFont("res/font/pixel-uniCode.ttf", 8, "normal")

return r
