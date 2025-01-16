function love.load()
    arr = {a = "bcd",
           e = "fgh"
    }
end

function love.update(dt)

end

function love.draw()
    --print_array(arr)
    lg.setColor(1, 1, 1)
    print("hello", 10, 10)
end

function print_array(arr)
    x_pos = 10
    y_pos = 200
    lg.setColor(1, 1, 0)
    for k, v in pairs(arr) do
        lg.print(k .. ": " .. v, x_pos, y_pos)
        y_pos = y_pos + 20
    end
end