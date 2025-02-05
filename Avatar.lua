local love = require "love"
local lg = love.graphics

function Avatar(text, character_name, func, func_params, text_offset_x, text_offset_y, font, width, height, image, scale, debugger)
    return {
        text = text,
        image = image,
        debugger = debugger,
        func = func,
        func_params = func_params,
        width = width,
        height = height,
        border_radius = 5,
        scale = scale,
        text_offset_x = text_offset_x,
        text_offset_y = text_offset_y,
        font = font,
        scale = scale,
        character_name = character_name,

        draw = function(self, x, y, pic_offset, text_offset)
            self.x = x
            self.y = y

            lg.scale(self.scale)

            love.graphics.setColor(163/255, 15/255, 32/255)
            love.graphics.rectangle("fill", (x - 5) * 1/scale, (y - 5) * 1/scale, self.width + 10 * 1/scale, self.height + 10 * 1/scale, self.border_radius * 1/scale, self.border_radius * 1/scale)
            love.graphics.setColor(252/255, 165/255, 3/255)
            love.graphics.rectangle("fill", x * 1/scale, y * 1/scale, self.width, self.height, self.border_radius * 1/scale, self.border_radius * 1/scale)

            love.graphics.setColor(1, 1, 1)
            if pic_offset then
                love.graphics.draw(image, x * 1/scale, (y + 100 + pic_offset) * 1/scale)
            else
                love.graphics.draw(image, x * 1/scale, (y + 100) * 1/scale)
            end

            love.graphics.setColor(248/255, 252/255, 3/255)
            if text_offset then
                love.graphics.print(self.text, self.font, (x + self.text_offset_x + text_offset) * 1/scale, (y + self.text_offset_y) * 1/scale)
            else
                love.graphics.print(self.text, self.font, (x + self.text_offset_x) * 1/scale, (y + self.text_offset_y) * 1/scale)
            end
            lg.scale(1/self.scale)
        end,

        checkPressed = function(self, mouse_x, mouse_y)
            if self.x and self.y then
                if mouse_x > self.x and mouse_x < self.x + self.width and mouse_y > self.y + scroll_offset_y * 5 and mouse_y < self.y + scroll_offset_y * 5 + self.height and self.func then
                    self.debugger("Avatar: " .. self.text .. " was pressed")
                    if contains(characters, self.character_name) then
                        chosen_avatar = self.character_name
                    else
                        chosen_opponent = self.character_name
                    end
                    if self.func_params then
                        self.func(self.func_params)
                    else
                        self.func()
                    end
                end
            end
        end
    }
end

return Avatar