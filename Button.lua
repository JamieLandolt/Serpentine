local love = require "love"

function Button(text, func, func_params, x, y, width, height, font, text_offset_x, text_offset_y, debugger)
    return {
        font = font,
        text = text or "No Text",
        func = func,
        func_params = func_params,
        text_offset_x = text_offset_x,
        text_offset_y = text_offset_y,
        x = x,
        y = y,
        width = width,
        height = height,
        border_radius = 5,

        draw = function(self)
            love.graphics.setColor(163/255, 15/255, 32/255)
            love.graphics.rectangle("fill", self.x - 5, self.y - 5, self.width + 10, self.height + 10, self.border_radius, self.border_radius)
            love.graphics.setColor(252/255, 165/255, 3/255)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.border_radius, self.border_radius)
            love.graphics.setColor(248/255, 252/255, 3/255)
            love.graphics.print(self.text, self.font, self.x + self.text_offset_x, self.y + self.text_offset_y)
        end,

        checkPressed = function(self, mouse_x, mouse_y)
            --self.debugger("X: " .. mouse_x .. " Y: " .. mouse_y)
            if mouse_x > self.x and mouse_x < self.x + self.width and mouse_y > self.y and mouse_y < self.y + self.height and self.func then
                if self.func_params then
                    self.func(self.func_params)
                else
                    self.func()
                end
                debugger(self.text)
                return
            end
        end
    }
end

return Button