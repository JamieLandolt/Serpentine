local love = require "love"
local lg = love.graphics
local button = require "Button"
local avatar = require "Avatar"
local scandir = require "scandir"
local card = require "Card"

local magic_points = 1
local button_width = 200
local button_height = 60
local opponent_button_width = 355
local opponent_button_height = 500
local opponent_pic_width = 355
local opponent_pic_height = 400
local window_width = 1250
local window_height = 800
local debug = "Debug Text"
local debug2 = "Debug Text"
local debug3 = "Debug Text"
local debugger_enabled = true
local audio = true
local card_files = {"Beach_Mum.png", "Big_Foot.png", "Big_Foot_Gold.png", "Blue_Slimey.png", "Blueberry_Djini.png", "Brain_Gooey.png", "Burning_Hand.png", "Cerebral_Bloodstorm.png", "Cornball.png", "Cornball_Gold.png", "Dark_Angel.png", "Dragon_claw.png", "Ghost_Djini.png", "Ghost_Ninja.png", "Ghost_Ninja_Gold.png", "Giant_Mummy_Hand.png", "Grape_Slimey.png", "Gray_Eyebat.png", "Gray_Eyebat_Gold.png", "Green_Cactaball.png", "Green_Cactaball_Gold.png", "Green_Mermaid.png", "Green_Merman.png", "Green_Merman_Gold.png", "Heavenly_Gazer_Gold.png", "Huskerbat.png", "Lime_slimey.png", "Mud_Angel_Gold.png", "Nicelands_Eye_Bat.png", "Orange_Slimey.png", "Ordinary_Ninja.png", "Peach_djini.png", "Sand_Angel.png", "Sand_Angel_Gold.png", "Sand_eyebat.png", "Sandfoot.png", "Travelin%27_Farmer.png", "Travelin%27_Skeleton.png", "Travelin_Wizard.png", "Unicycle_Knight.png", "Unicyclops.png", "Wall_Of_Sand.png", "Wall_of_Chocolate.png", "Wall_of_Ears.png"}
local background_files = {"background10.jpg", "background2.jpg", "background3.jpg", "background4.jpeg", "background5.jpg", "background6.jpg", "background7.jpg", "background8.jpg", "collection_background.png"}
local opponent_files = {"ice_king.png", "marcelline.jpg", "princess_bubblegum.jpeg"}
local font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 50)
local debug_font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 20)
local test = false
local opponent_scale = 0.5

-- NOT LOCAL
chosen_avatar = "Gabe"
chosen_opponent = "Ice King"
scroll_offset_y = 0
characters  = {"Alem", "Gabe", "Jamie", "Darcy", "Josh", "Michael"}
count = 0

local avatars = {}
local cards = {}
local icons = {}
local audio_files = {}
local player_hand = {}

local buttons = {
    menu = {},
    settings = {},
    level_select = {},
    character_select = {},
    collection = {},
    playing = {},
    paused = {},
    ended = {}
}

local game = {
    state = {
        menu = true,
        settings = false,
        level_select = false,
        character_select = false,
        collection = false,
        playing = false,
        paused = false,
        ended = false
    }
}

function love.load()
    math.randomseed(os.time())
    for i = 1, #card_files do
        cards[i] = lg.newImage("assets/cards/" .. card_files[i])
    end

    img_widths = cards[1]:getWidth()
    img_heights = cards[1]:getHeight()

    avatars.ice_king = love.graphics.newImage("assets/opponents/ice_king.jpg")
    avatars.princess_bubblegum = love.graphics.newImage("assets/opponents/princess_bubblegum.png")
    avatars.marcelline = love.graphics.newImage("assets/opponents/marcelline.jpg")

    avatars.gabe = love.graphics.newImage("assets/characters/gabe.jpg")
    avatars.jamie = love.graphics.newImage("assets/characters/jamie.jpg")
    avatars.alem = love.graphics.newImage("assets/characters/alem.jpg")
    avatars.josh = love.graphics.newImage("assets/characters/josh.jpg")
    avatars.michael = love.graphics.newImage("assets/characters/michael.jpg")
    avatars.darcy = love.graphics.newImage("assets/characters/darcy.jpg")

    icons.audio_enabled = love.graphics.newImage("assets/icons/audio_enabled.png")
    icons.audio_disabled = love.graphics.newImage("assets/icons/audio_disabled.png")

    love.window.setMode(window_width, window_height)
    new_background()

    -- If adding new button, remember to draw it, may need to add game state too
    buttons.menu["Play Game"] = button("Play Game", update_game_state, "level_select", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 - 150, button_width, button_height, font, 9, 4, debugger)
    buttons.menu["Collection"] = button("Collection", update_game_state, "collection", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 - 50, button_width, button_height, font, 11, 4, debugger)
    buttons.menu["Character"] = button("Character", update_game_state, "character_select", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 + 50, button_width, button_height, font, 6, 4, debugger)
    buttons.menu["Settings"] = button("Settings", update_game_state, "settings", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 + 150, button_width, button_height, font, 19, 4, debugger)

    buttons.menu["Avatar Jamie"] = button("Avatar: Jamie", nil, nil, 5, 5, button_width + 85, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Darcy"] = button("Avatar: Darcy", nil, nil, 5, 5, button_width + 85, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Michael"] = button("Avatar: Michael", nil, nil, 5, 5, button_width + 115, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Gabe"] = button("Avatar: Gabe", nil, nil, 5, 5, button_width + 65, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Josh"] = button("Avatar: Josh", nil, nil, 5, 5, button_width + 65, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Alem"] = button("Avatar: Alem", nil, nil, 5, 5, button_width + 65, button_height, font, 16, 4, debugger)

    buttons.menu["New Background"] = button("New Back", new_background, nil, lg.getWidth() - button_width - 5, 5, button_width, button_height, font, 16, 4, debugger)

    buttons.collection["Collection Header"] = button("Collection", nil, nil, lg.getWidth() / 2 - button_width / 2, 5, button_width, button_height, font, 14, 4, debugger)
    buttons.collection["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.settings["Toggle Audio"] = button("Toggle Audio", toggle_audio, nil, lg.getWidth() / 2 - button_width * 1/4, lg.getHeight() / 2 - 100, button_width * 1.315, button_height, font, 19, 4, debugger)
    buttons.settings["Audio Enabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_enabled)
    buttons.settings["Audio Disabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_disabled)
    buttons.settings["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.level_select["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.level_select["Select Opponent"] = button("Select Opponent", nil, nil, 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.level_select["Ice King"] = avatar("Ice King", "Ice King", update_game_state, "playing", 109, 20, font, opponent_button_width, opponent_button_height, avatars.ice_king, 1, debugger)
    buttons.level_select["Princess Bubblegum"] = avatar("  Princess\nBubblegum", "Princess Bubblegum", update_game_state, "playing", 80, 0, font, opponent_button_width, opponent_button_height, avatars.princess_bubblegum, 1, debugger)
    buttons.level_select["Marcelline"] = avatar("Marcelline", "Marcelline", update_game_state, "playing", 84, 20, font, opponent_button_width, opponent_button_height, avatars.marcelline, 1, debugger)

    buttons.character_select["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.character_select["Gabe"] = avatar("Gabe", "Gabe", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.gabe, 0.7, debugger)
    buttons.character_select["Jamie"] = avatar("Jamie", "Jamie", update_game_state, "menu", 85, 20, font, opponent_button_width, opponent_button_height, avatars.jamie, 0.7, debugger)
    buttons.character_select["Michael"] = avatar("Michael", "Michael", update_game_state, "menu", 75, 20, font, opponent_button_width, opponent_button_height, avatars.michael, 0.7, debugger)
    buttons.character_select["Josh"] = avatar("Josh", "Josh", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.josh, 0.7, debugger)
    buttons.character_select["Alem"] = avatar("Alem", "Alem", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.alem, 0.7, debugger)
    buttons.character_select["Darcy"] = avatar("Darcy", "Darcy", update_game_state, "menu", 85, 20, font, opponent_button_width, opponent_button_height, avatars.darcy, 0.7, debugger)

    buttons.playing["Ice King"] = avatar("Ice King", "Ice King", nil, nil, 109, 20, font, opponent_button_width, opponent_button_height, avatars.ice_king, opponent_scale, debugger)
    buttons.playing["Back"] = button("Back", update_game_state, "level_select", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.playing["Princess Bubblegum"] = avatar("  Princess\nBubblegum", "Princess Bubblegum", nil, nil, 80, 0, font, opponent_button_width, opponent_button_height, avatars.princess_bubblegum, opponent_scale, debugger)
    buttons.playing["Marcelline"] = avatar("Marcelline", "Marcelline", nil, nil, 84, 20, font, opponent_button_width, opponent_button_height, avatars.marcelline, opponent_scale, debugger)

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


function print_kvarray(arr)
    x_pos = 10
    y_pos = 200
    lg.setColor(0, 0, 0)
    for k, v in pairs(arr) do
        lg.print(k .. ": " .. tostring(v), x_pos, y_pos)
        y_pos = y_pos + 20
    end
end

function print_array(arr)
    x_pos = 10
    y_pos = 200
    lg.setColor(0, 0, 0)
    for i, v in ipairs(arr) do
        lg.print(tostring(v), x_pos, y_pos)
        y_pos = y_pos + 20
    end
end

function update_game_state(state)
    for state_name, state_value in pairs(game.state) do
        game.state[state_name] = false
    end
    game.state[state] = true
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
    scroll_offset_y = 0
    renderBackground()
    buttons.menu["Play Game"]:draw()
    buttons.menu["Collection"]:draw()
    buttons.menu["Character"]:draw()
    buttons.menu["Settings"]:draw()
    buttons.menu["Avatar " .. chosen_avatar]:draw()
    buttons.menu["New Background"]:draw()
end

local function render_cards()
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
    buttons.collection["Back"]:draw()
end

local function render_character_select()
    renderBackground()

    buttons.character_select["Gabe"]:draw(150, 50 + scroll_offset_y * 5)
    buttons.character_select["Jamie"]:draw(550, 50 + scroll_offset_y * 5)
    buttons.character_select["Alem"]:draw(950, 50 + scroll_offset_y * 5)

    buttons.character_select["Michael"]:draw(150, 550 + scroll_offset_y * 5)
    buttons.character_select["Darcy"]:draw(550, 550 + scroll_offset_y * 5)
    buttons.character_select["Josh"]:draw(950, 550 + scroll_offset_y * 5)

    buttons.character_select["Back"]:draw()
end

local function render_settings()
    renderBackground()
    buttons.settings["Back"]:draw()
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
    buttons.level_select["Back"]:draw(0, 800)
end

local function inc(x)
    x = x + 1
end

function contains(table, val)
    for _, v in ipairs(table) do
        if v == val then
            return true
        end
    end
    return false
end

local function player_turn()
    inc(magic_points)
    local chosen_indices = {}


    -- Choose initially/Add cards to hand when low
    while #player_hand < math.floor(count / 50) do
        local index = math.random(1, #card_files)
        if not contains(chosen_indices, index) then
            table.insert(player_hand, card("assets/cards/" .. card_files[index], img_widths, img_heights))
            table.insert(chosen_indices, index)
        end
    end
end

local card_spacing = {0.1, 0.09, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03}

local function get_card_spacing(num)
    return 0.1*(3/140 * num^2 - 59/140 * num + 71/14)
end

local function render_playing_state()
    local rotation
    local rotation_difference

    renderBackground()
    count = count + 1
    if count > 12000/20 then
        count = 0
    end
    local pic_offset = -50
    local text_offset = -40

    -- Draw Opponent
    buttons.playing[chosen_opponent]:draw(lg.getWidth() - opponent_pic_width/2 - 5, 5, pic_offset, text_offset)
    buttons.playing["Back"]:draw(0, 0)

    rotation = card_spacing[#player_hand + 1]
    rotation_difference = card_spacing[#player_hand + 1] -- Amount to rotate next drawn card

    love.graphics.push()
    love.graphics.translate(250, lg.getHeight()* 5/4)

    local x_pos = - img_widths * 0.6
    local y_pos = - lg.getHeight() / 2 + 200 - img_heights

    debug2 = ""
    lg.scale(6/5)
    --Draw Hand
    for i, card in ipairs(player_hand) do
        --debug2 = debug2 .. tostring(x_pos + next_card_x_offset * (i-1)) .. tostring(y_pos + next_card_y_offset * (i-1)) .. tostring(rotation + rotation_difference * (i-1)) .. "\n"
        card:draw(x_pos - img_widths/2, y_pos - img_heights/2, rotation + rotation_difference * (i-1))
    end
    --love.graphics.draw(player_hand[1], X, Y, math.deg(90), 1, 1, image:getWidth()/2, image:getHeight()/2)
    lg.scale(5/6)
    love.graphics.pop()
end

function love.update(dt)
    if game.state["playing"] then
        player_turn()
    end
end

local function get_game_state()
    --debug2 = ""
    for state, val in pairs(game.state) do
        --debug2 = debug2 .. tostring(state) .. " " .. tostring(val) .. "--"
        if val == true then
            return state
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for button_name, button in pairs(buttons[get_game_state()]) do
            button:checkPressed(x, y)
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

function love.draw()
    if game.state["menu"] then
        render_main_menu()
    elseif game.state["level_select"] then
        render_level_select()
    elseif game.state["character_select"] then
        render_character_select()
    elseif game.state["collection"] then
        render_cards()
    elseif game.state["settings"] then
        render_settings()
    elseif game.state["playing"] then
        render_playing_state()
    end

    print_array(buttons.menu)

    if debugger_enabled then
        lg.setColor(1, 0, 0)
        lg.printf(debug, debug_font, 10, 70, window_width)
        lg.print(debug2, 20, 120)
        --lg.print(debug3, 20, 140)
        lg.setColor(1, 1, 1)
    end
end
