local love = require "love"

function Biome(type, x, y, width, height, num)
    return {
        type = type,
        x = x,
        y = y,
        width = width,
        height = height,
        border_radius = 5,

        draw = function(self, x_offset, y_offset)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", self.x - 5 + x_offset, self.y - 5 + y_offset, self.width + 10, self.height + 10, self.border_radius, self.border_radius)

            --if x_offset ~= 0 then
            --    player_biome_hitboxes["L" .. tostring(num)] = {self.x + x_offset, self.y + y_offset, self.width, self.height}
            --end

            if type == "B" then
                love.graphics.setColor(22/255, 112/255, 135/255)
            elseif type == "D" then
                love.graphics.setColor(201/255, 106/255, 22/255)
            elseif type == "N" then
                love.graphics.setColor(227/255, 68/255, 214/255)
            elseif type == "S" then
                love.graphics.setColor(27/255, 64/255, 29/255)
            elseif type == "C" then
                love.graphics.setColor(200/255, 187/255, 26/255)
            end
            love.graphics.rectangle("fill", self.x + x_offset, self.y + y_offset, self.width, self.height, self.border_radius, self.border_radius)
        end,
        checkPressed = function() -- DO NOT DELETE

        end
    }
end

return Biome