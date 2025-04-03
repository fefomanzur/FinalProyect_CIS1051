function button(text, func, func_param, width, heigth, image_path)
    return { 
        text = text or nil,
        width = width or 200,
        height = heigth or 50,
        func = func or function() print("Button pressed, but no function assigned.") end,
        func_param = func_param or nil, 
        button_x = 0, 
        button_y = 0, 
        text_x = 0, 
        text_y = 0,
        image = image_path and love.graphics.newImage(image_path) or nil, -- Load the image if provided

        CheckPressed = function (self, mouse_x, mouse_y)
            if (mouse_x >= self.button_x) and (mouse_x <= self.button_x + self.width) and 
               (mouse_y >= self.button_y) and (mouse_y <= self.button_y + self.height) then
                if self.func_param then
                    self.func(self.func_param)
                else
                    self.func()
                end
                return true -- Button was pressed
            end
        end,

        draw = function (self, button_x, button_y, text_x, text_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y

            if text_x then
                self.text_x = text_x
            else
                self.text_x = self.button_x + (self.width / 2) - (love.graphics.getFont():getWidth(self.text) / 2)
            end

            if text_y then
                self.text_y = text_y
            else
                self.text_y = self.button_y + (self.height / 2) - (love.graphics.getFont():getHeight(self.text) / 2)
            end

            if self.image then
                love.graphics.draw(self.image, self.button_x, self.button_y, 0, self.width / self.image:getWidth(), self.height / self.image:getHeight())
            else
                love.graphics.setColor(0.6, 0.6, 0.6)
                love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)
                love.graphics.setColor(0, 0, 0)
                love.graphics.printf(self.text, self.text_x, self.text_y, self.width, "center")
                love.graphics.setColor(1, 1, 1)
            end
        end
    }
end

return button