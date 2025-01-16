--[[
    This script resizes two images to 355x500.
    Make sure you have the lua-magick library installed:
        luarocks install magick

    Usage example:
        1. Save this file as resize.lua
        2. Run: lua resize.lua "path/to/image1.jpg" "path/to/image2.png"
--]]

local magick = require("magick")

-- Grab command-line arguments (or you can hardcode the paths if preferred)
local image1_path = "assets/opponents/marcelling.jpg"
local image2_path = "assets/opponents/ice_king.png"

-- Validate input
if not image1_path or not image2_path then
    print("Usage: lua resize.lua <image1_path> <image2_path>")
    os.exit(1)
end

-- Define the desired dimensions
local width = 355
local height = 500

-- Resize and save image 1
local image1 = magick.load_image(image1_path)
image1:resize(width, height)
local resized_image1_path = "resized_image1.jpg"  -- Adjust if you want a different output name
image1:write(resized_image1_path)
print("Resized image 1 saved to " .. resized_image1_path)

-- Resize and save image 2
local image2 = magick.load_image(image2_path)
image2:resize(width, height)
local resized_image2_path = "resized_image2.jpg"  -- Adjust if you want a different output name
image2:write(resized_image2_path)
print("Resized image 2 saved to " .. resized_image2_path)
