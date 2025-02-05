local love = require "love"

function Button(text, func, func_params, x, y, width, height, font, text_offset_x, text_offset_y, debugger, icon)
    return {
        icon = icon,
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
        debugger = debugger,

        draw = function(self)
            love.graphics.setColor(163/255, 15/255, 32/255)
            love.graphics.rectangle("fill", self.x - 5, self.y - 5, self.width + 10, self.height + 10, self.border_radius, self.border_radius)
            love.graphics.setColor(252/255, 165/255, 3/255)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.border_radius, self.border_radius)
            if self.icon then
                love.graphics.scale(1/4)
                love.graphics.draw(self.icon, self.x * 4 + self.text_offset_x - 6, self.y * 4 + self.text_offset_y * 4)
                love.graphics.scale(4)
            end
            if self.text then
                love.graphics.setColor(248/255, 252/255, 3/255)
                love.graphics.print(self.text, self.font, self.x + self.text_offset_x, self.y + self.text_offset_y)
            end
        end,

        checkPressed = function(self, mouse_x, mouse_y)
            if mouse_x > self.x and mouse_x < self.x + self.width and mouse_y > self.y and mouse_y < self.y + self.height and self.func then
                self.debugger(self.text .. " was pressed.")
                if self.func_params then
                    self.func(self.func_params)
                else
                    self.func()
                end
                return
            end
        end
    }
end

return Button