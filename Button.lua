local love = require "love"
local la = love.audio

function Button(text, func, func_params, x, y, width, height, font, text_offset_x, text_offset_y, debugger, icon, icon_scale, icon_offset_x, icon_offset_y)
    return {
        edge_buttons = {"Play", "Back", "Switch Background", "Hand"},
        icon = icon,
        icon_scale = icon_scale,
        icon_offset_x = icon_offset_x,
        icon_offset_y = icon_offset_y,
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

        update_text = function(self, new_text)
            self.text = new_text
        end,

        hover = function(self)
            if mouse.x > self.x and mouse.x < self.x + self.width and mouse.y > self.y and mouse.y < self.y + self.height and self.func then
                    play_sound(hover_sound)
                    return true
            end
            return false
        end,

        draw = function(self)
            -- Outer rectangle
            if self:hover() then
                love.graphics.setColor(231/255, 111/255, 81/255)
                if contains(self.edge_buttons, self.text) then
                    love.graphics.rectangle("fill", self.x - 5, self.y - 5, self.width + 10, self.height + 10, self.border_radius, self.border_radius)
                else
                    love.graphics.rectangle("fill", self.x - 13, self.y - 13, self.width + 26, self.height + 26, self.border_radius, self.border_radius)
                end
            else
                love.graphics.setColor(163/255, 15/255, 32/255)
                love.graphics.rectangle("fill", self.x - 5, self.y - 5, self.width + 10, self.height + 10, self.border_radius, self.border_radius)
            end

            -- Inner rectangle
            if self:hover() then
                love.graphics.setColor(248/255, 252/255, 3/255)
                if contains(self.edge_buttons, self.text) then
                    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.border_radius, self.border_radius)
                else
                    love.graphics.rectangle("fill", self.x - 5, self.y - 5, self.width + 10, self.height + 10, self.border_radius, self.border_radius)
                end
            else
                love.graphics.setColor(244/255, 162/255, 97/255)
                love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.border_radius, self.border_radius)
            end
            if self.icon then
                love.graphics.scale(self.icon_scale)
                love.graphics.draw(self.icon, self.x * 1/self.icon_scale + self.text_offset_x + self.icon_offset_x, self.y * 1/self.icon_scale + self.icon_offset_y)
                love.graphics.scale(1/self.icon_scale)
            end
            if self.text then
                if self:hover() then
                    love.graphics.setColor(225/255, 44/255, 44/255)
                else
                    love.graphics.setColor(248/255, 252/255, 3/255)
                end
                love.graphics.print(self.text, self.font, self.x + self.text_offset_x, self.y + self.text_offset_y)
            end
        end,

        checkPressed = function(self, mouse_x, mouse_y)
            if mouse_x > self.x and mouse_x < self.x + self.width and mouse_y > self.y and mouse_y < self.y + self.height and self.func then
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