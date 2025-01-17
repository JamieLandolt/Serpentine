local love = require "love"
local lg = love.graphics

function Opponent(text, func, func_params, text_offset_x, text_offset_y, font, width, height, image, scale, debugger)
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

        draw = function(self, x, y)
            self.x = x
            self.y = y
            love.graphics.setColor(163/255, 15/255, 32/255)
            love.graphics.rectangle("fill", x - 5, y - 5, self.width + 10, self.height + 10, self.border_radius, self.border_radius)
            love.graphics.setColor(252/255, 165/255, 3/255)
            love.graphics.rectangle("fill", x, y, self.width, self.height, self.border_radius, self.border_radius)
            love.graphics.setColor(1, 1, 1)
            lg.scale(self.scale)
            love.graphics.draw(image, x, y + 100)
            lg.scale(1/self.scale)
            love.graphics.setColor(248/255, 252/255, 3/255)
            love.graphics.print(self.text, self.font, x + self.text_offset_x, y + self.text_offset_y)
        end,

        checkPressed = function(self, mouse_x, mouse_y)
            --self.debugger("X: " .. mouse_x .. " Y: " .. mouse_y)
            if self.x and self.y then
                if mouse_x > self.x and mouse_x < self.x + self.width and mouse_y > self.y and mouse_y < self.y + self.height and self.func then
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

return Opponent