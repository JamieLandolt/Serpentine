local love = require "love"
local lg = love.graphics
local button = require "Button"
local opponent = require "Opponent"
local scandir = require "scandir"

math.randomseed(os.time())

_G.buttons_drawn = {}

local scroll_offset_y = 0
local button_width = 200
local button_height = 60
local opponent_button_width = 355
local opponent_button_height = 500
local window_width = 1250
local window_height = 800
local debug = "Debug Text"
local debug2 = "Debug Text"
local debug3 = "Debug Text"
local debugger_enabled = false
local count = 0
local audio = true
local card_files = {"Beach_Mum.png", "Big_Foot.png", "Big_Foot_Gold.png", "Blue_Slimey.png", "Blueberry_Djini.png", "Brain_Gooey.png", "Burning_Hand.png", "Cerebral_Bloodstorm.png", "Cornball.png", "Cornball_Gold.png", "Dark_Angel.png", "Dragon_claw.png", "Ghost_Djini.png", "Ghost_Ninja.png", "Ghost_Ninja_Gold.png", "Giant_Mummy_Hand.png", "Grape_Slimey.png", "Gray_Eyebat.png", "Gray_Eyebat_Gold.png", "Green_Cactaball.png", "Green_Cactaball_Gold.png", "Green_Mermaid.png", "Green_Merman.png", "Green_Merman_Gold.png", "Heavenly_Gazer_Gold.png", "Huskerbat.png", "Lime_slimey.png", "Mud_Angel_Gold.png", "Nicelands_Eye_Bat.png", "Orange_Slimey.png", "Ordinary_Ninja.png", "Peach_djini.png", "Sand_Angel.png", "Sand_Angel_Gold.png", "Sand_eyebat.png", "Sandfoot.png", "Travelin%27_Farmer.png", "Travelin%27_Skeleton.png", "Travelin_Wizard.png", "Unicycle_Knight.png", "Unicyclops.png", "Wall_Of_Sand.png", "Wall_of_Chocolate.png", "Wall_of_Ears.png"}
local background_files = {"background10.jpg", "background2.jpg", "background3.jpg", "background4.jpeg", "background5.jpg", "background6.jpg", "background7.jpg", "background8.jpg", "collection_background.png"}
local opponent_files = {"ice_king.png", "marcelline.jpg", "princess_bubblegum.jpeg"}
local font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 50)
local debug_font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 20)
local test = false

local avatars = {}
local cards = {}
local icons = {}
local audio_files = {}

local buttons = {
    menu = {},
    settings = {},
    level_select = {},
    collection = {},
    running = {},
    paused = {},
    ended = {}
}

local game = {
    state = {
        menu = true,
        settings = false,
        level_select = false,
        collection = false,
        running = false,
        paused = false,
        ended = false
    }
}

function love.load()
    s1 = ""
    cards = {}
    for i = 1, #card_files do
        cards[i] = lg.newImage("assets/cards/" .. card_files[i])
    end

    avatars.ice_king = love.graphics.newImage("assets/opponents/ice_king.jpg")
    avatars.princess_bubblegum = love.graphics.newImage("assets/opponents/princess_bubblegum.png")
    avatars.marcelline = love.graphics.newImage("assets/opponents/marcelline.jpg")

    icons.audio_enabled = love.graphics.newImage("assets/icons/audio_enabled.png")
    icons.audio_disabled = love.graphics.newImage("assets/icons/audio_disabled.png")

    love.window.setMode(window_width, window_height)
    new_background()

    buttons.menu["Play Game"] = button("Play Game", update_game_state, "level_select", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 - 100, button_width, button_height, font, 9, 4, debugger)
    buttons.menu["Collection"] = button("Collection", update_game_state, "collection", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2, button_width, button_height, font, 11, 4, debugger)
    buttons.menu["Settings"] = button("Settings", update_game_state, "settings", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 + 100, button_width, button_height, font, 19, 4, debugger)
    buttons.menu["New Background"] = button("New Back", new_background, nil, lg.getWidth() - button_width - 5, 5, button_width, button_height, font, 19, 4, debugger)

    buttons.collection["Collection Header"] = button("Collection", nil, nil, lg.getWidth() / 2 - button_width / 2, 5, button_width, button_height, font, 14, 4, debugger)
    buttons.collection["Collection To Menu"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.level_select["Level Select To Menu"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.level_select["Select Opponent"] = button("Select Opponent", nil, nil, 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.level_select["Ice King"] = opponent("Ice King", update_game_state, "Ice King", 109, 20, font, opponent_button_width, opponent_button_height, avatars.ice_king, 1, debugger)
    buttons.level_select["Princess Bubblegum"] = opponent("  Princess\nBubblegum", update_game_state, "Princess Bubblegum", 80, 0, font, opponent_button_width, opponent_button_height, avatars.princess_bubblegum, 1, debugger)
    buttons.level_select["Marcelline"] = opponent("Marcelline", update_game_state, "Marcelline", 84, 20, font, opponent_button_width, opponent_button_height, avatars.marcelline, 1, debugger)

    buttons.settings["Toggle Audio"] = button("Toggle Audio", toggle_audio, nil, lg.getWidth() / 2 - button_width * 1/4, lg.getHeight() / 2 - 100, button_width * 1.315, button_height, font, 19, 4, debugger)
    buttons.settings["Audio Enabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_enabled)
    buttons.settings["Audio Disabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_disabled)
    buttons.settings["Settings To Menu"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
end

function toggle_audio()
    audio = not audio
end

function new_background()
    local num = math.random(1, #background_files)
    background = lg.newImage("assets/backgrounds/" .. background_files[num])
end


function debugger(debug_text)
    debug = debug_text
end

function love.update(dt)

end

function love.mousepressed(x, y, button, istouch, presses)
    for state, bs in pairs(buttons) do
        if game.state[state] then
            if button == 1 and buttons[state] then
                for k, v in pairs(buttons[state]) do
                    v:checkPressed(x, y)
                end
            end
        end
    end
end

function love.wheelmoved(x, y)
    if scroll_offset_y + y < 0 then
        scroll_offset_y = scroll_offset_y + y * 2
    else
        scroll_offset_y = 0
    end
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

function update_game_state(state)
    count = count + 1
    for k, v in pairs(game.state) do
        if v == true then
            game.state[k] = false
        elseif k == state then
            game.state[k] = true
        end
    end
end

local function renderBackground()
    lg.scale(3/4) -- can just be 2 as window is unable to be resized
    lg.setColor(1, 1, 1)
    if not test then
        lg.draw(background, -(1500 - window_width) / 2, 0)
    end
    lg.scale(4/3)
end

local function render_main_menu()
    renderBackground()
    buttons.menu["Play Game"]:draw()
    buttons.menu["Collection"]:draw()
    buttons.menu["Settings"]:draw()
    buttons.menu["New Background"]:draw()
end

local function render_cards()
    local img_widths = cards[1]:getWidth()
    local img_heights = cards[1]:getHeight()
    local offset_x = 69
    local offset_y = scroll_offset_y * 5 or 0
    if offset_y > 0 then
        offset_y = 0
    end
    renderBackground()
    for c, s in pairs(cards) do
        if offset_x + img_widths > love.graphics.getWidth() then
            offset_x = 69
            offset_y = offset_y + img_heights
        end

        love.graphics.draw(s, offset_x, offset_y + button_height + 10)
        offset_x = offset_x + img_widths
    end
    buttons.collection["Collection Header"]:draw()
    buttons.collection["Collection To Menu"]:draw()
end

local function render_settings()
    renderBackground()
    buttons.settings["Settings To Menu"]:draw()
    buttons.settings["Toggle Audio"]:draw()
    if audio then
        buttons.settings["Audio Enabled"]:draw()
    else
        buttons.settings["Audio Disabled"]:draw()
    end
end

local function render_level_select()
    local x, y = 45, 100
    renderBackground()
    buttons.level_select["Princess Bubblegum"]:draw(x, y)
    buttons.level_select["Ice King"]:draw(x + 400, y)
    buttons.level_select["Marcelline"]:draw(x + 800, y)
    buttons.level_select["Level Select To Menu"]:draw(0, 800)
end

function love.draw()
    if game.state["menu"] then
        render_main_menu()
    elseif game.state["level_select"] then
        render_level_select()
    elseif game.state["collection"] then
        render_cards()
    elseif game.state["settings"] then
        render_settings()
    end

    if debugger_enabled then
        lg.setColor(1, 0, 0)
        lg.printf(debug, debug_font, 10, 50, window_width)
        lg.print(debug2, 20, 100)
        lg.print(debug3, 20, 140)
        lg.setColor(1, 1, 1)
    end
end

