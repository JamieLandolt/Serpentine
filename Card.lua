local love = require "love"
local lg = love.graphics

function Card(card_path, card_width, card_height)
    return {
        card_object = lg.newImage("assets/Snake_Cards/" .. card_path),
        card_height = card_height,
        card_width = card_width,
        card_path = card_path,
        draw = function(self, x, y, rot)
            lg.scale(7/10)
            lg.rotate(rot)
            lg.setColor(1, 1, 1)
            lg.draw(self.card_object, x, y)
            lg.setColor(163/255, 15/255, 32/255)
            --lg.setLineWidth(5)
            --lg.rectangle("line", x - 5, y - 5, self.card_width + 10, self.card_height + 10)
            --lg.setLineWidth(1)
            lg.scale(10/7)
            lg.rotate(-rot)
        end
    }
end

return Card