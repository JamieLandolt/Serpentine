local love = require "love"
local lg = love.graphics
local la = love.audio
local button = require "Button"
local avatar = require "Avatar"
local scandir = require "scandir"
local card = require "Card"
local biome = require "Biome"

local biome_width, biome_height = 200, 300

local debug = "Debug Text"
local debug2 = "Debug Text"
local debugger_enabled = true

local debug_font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 20)
local font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 50)

local audio = false

local card_files = {"Beach_Mum.png", "Big_Foot.png", "Big_Foot_Gold.png", "Blue_Slimey.png", "Blueberry_Djini.png", "Brain_Gooey.png", "Burning_Hand.png", "Cerebral_Bloodstorm.png", "Cornball.png", "Cornball_Gold.png", "Dark_Angel.png", "Dragon_claw.png", "Ghost_Djini.png", "Ghost_Ninja.png", "Ghost_Ninja_Gold.png", "Giant_Mummy_Hand.png", "Grape_Slimey.png", "Gray_Eyebat.png", "Gray_Eyebat_Gold.png", "Green_Cactaball.png", "Green_Cactaball_Gold.png", "Green_Mermaid.png", "Green_Merman.png", "Green_Merman_Gold.png", "Heavenly_Gazer_Gold.png", "Huskerbat.png", "Lime_slimey.png", "Mud_Angel_Gold.png", "Nicelands_Eye_Bat.png", "Orange_Slimey.png", "Ordinary_Ninja.png", "Peach_djini.png", "Sand_Angel.png", "Sand_Angel_Gold.png", "Sand_eyebat.png", "Sandfoot.png", "Travelin%27_Farmer.png", "Travelin%27_Skeleton.png", "Travelin_Wizard.png", "Unicycle_Knight.png", "Unicyclops.png", "Wall_Of_Sand.png", "Wall_of_Chocolate.png", "Wall_of_Ears.png"}
local background_files = {"background10.jpg", "background2.jpg", "background3.jpg", "background6.jpg", "background7.jpg", "background8.jpg"}
local opponent_files = {"ice_king.png", "marcelline.jpg", "princess_bubblegum.jpeg"}

local chosen_background = ""

local card_background_height = lg.getHeight() * 3/8 + 10
local card_background_width = lg.getWidth()*5/8 - 96
local card_hitboxes = {} --x, y, width, height

local button_width = 200
local button_height = 60
local opponent_button_width = 355
local opponent_button_height = 500

local opponent_pic_width = 355
local opponent_pic_height = 400

local window_width = 1250
local window_height = 800

local default_button_size = 10
local letter_sizes = {
    a = 18,
    b = 18,
    c = 18,
    d = 18,
    e = 18,
    f = 15,
    g = 18,
    h = 15,
    i = 6,
    j = 9,
    k = 15,
    l = 6,
    m = 28,
    n = 18,
    o = 18,
    p = 18,
    q = 18,
    r = 17,
    s = 18,
    t = 15,
    u = 18,
    v = 18,
    w = 28,
    x = 18,
    y = 18,
    z = 20,
    A = 19,
    B = 19,
    C = 19,
    D = 19,
    E = 19,
    F = 19,
    G = 19,
    H = 19,
    I = 6,
    J = 19,
    K = 19,
    L = 19,
    M = 28,
    N = 19,
    O = 19,
    P = 19,
    Q = 19,
    R = 19,
    S = 20,
    T = 17,
    U = 19,
    V = 19,
    W = 28,
    X = 19,
    Y = 19,
    Z = 19,
    [" "] = 10,
    ["'"] = 6,
    ["1"] = 9,
    ["2"] = 19,
    ["3"] = 17,
    ["4"] = 17,
    ["5"] = 17,
    ["6"] = 19,
    ["7"] = 17,
    ["8"] = 19,
    ["9"] = 19,
    ["0"] = 17,
    [":"] = 6
}

local L1_x = 235 - 17
local L2_x = 440 - 17
local L3_x = 645 - 17
local L4_x = 850 - 17
local opp_L_y = 100
local L_y = 405

local lane_to_x = {L1 = L1_x, L2 = L2_x, L3 = L3_x, L4 = L4_x}

local biomes = {"B", "D", "N", "S", "C"}
local player_biome_counts = {1, 1, 1, 1}

local fields = {
    Player = {}
}

local magic_points = 1
local health_points = 100

local opponent_magic_points = 1
local opponent_health_points = 100


fields["Princess Bubblegum"] = {biome("N", lane_to_x["L1"], opp_L_y, biome_width, biome_height), biome("N", lane_to_x["L2"], opp_L_y, biome_width, biome_height), biome("N", lane_to_x["L3"], opp_L_y, biome_width, biome_height), biome("N", lane_to_x["L4"], opp_L_y, biome_width, biome_height)}
fields["Marcelline"] = {biome("S", lane_to_x["L1"], opp_L_y, biome_width, biome_height), biome("C", lane_to_x["L2"], opp_L_y, biome_width, biome_height), biome("S", lane_to_x["L3"], opp_L_y, biome_width, biome_height), biome("C", lane_to_x["L4"], opp_L_y, biome_width, biome_height)}
fields["Ice King"] = {biome("B", lane_to_x["L1"], opp_L_y, biome_width, biome_height), biome("D", lane_to_x["L2"], opp_L_y, biome_width, biome_height), biome("B", lane_to_x["L3"], opp_L_y, biome_width, biome_height), biome("D", lane_to_x["L4"], opp_L_y, biome_width, biome_height)}

-- NOT LOCAL
mouse = {}
chosen_avatar = "Jamie"
chosen_opponent = "Ice King"
scroll_offset_y = 0
count = 0
mouse_over_hand = false
characters = {"Alem", "Gabe", "Jamie", "Darcy", "Josh", "Michael"}



local opponents = {"Ice King", "Princess Bubblegum", "Marcelline"}
local avatars = {}
local cards = {}
local icons = {}

local player_hand = {}
local held_card

local buttons = {
    menu = {},
    settings = {},
    level_select = {},
    character_select = {},
    collection = {},
    biome_select = {},
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
        biome_select = false,
        playing = false,
        paused = false,
        ended = false
    }
}

local function get_button_size(text)
    local button_size = default_button_size
    for letter in string.gmatch(text, ".") do
        button_size = button_size + letter_sizes[letter] + 4
    end
    return button_size
end

local function placeholder() end

function love.load()
    math.randomseed(os.time())
    for i = 1, #card_files do
        cards[i] = lg.newImage("assets/cards/" .. card_files[i])
    end

    img_widths = cards[1]:getWidth()
    img_heights = cards[1]:getHeight()

    hover_sound = la.newSource("assets/audio/hover.mp3", "static")

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
    --buttons.menu["nums"] = button("1234567890 :", update_game_state, "settings", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 + 250, button_width, button_height, font, 19, 4, debugger)

    buttons.menu["Avatar Jamie"] = button("Avatar: Jamie", nil, nil, 5, 5, button_width + 85, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Darcy"] = button("Avatar: Darcy", nil, nil, 5, 5, button_width + 85, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Michael"] = button("Avatar: Michael", nil, nil, 5, 5, button_width + 115, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Gabe"] = button("Avatar: Gabe", nil, nil, 5, 5, button_width + 65, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Josh"] = button("Avatar: Josh", nil, nil, 5, 5, button_width + 65, button_height, font, 16, 4, debugger)
    buttons.menu["Avatar Alem"] = button("Avatar: Alem", nil, nil, 5, 5, button_width + 65, button_height, font, 16, 4, debugger)

    buttons.menu["Switch Background"] = button("Switch Background", new_background, nil, lg.getWidth() - get_button_size("Switch Background") - 5, 5, get_button_size("Switch Background"), button_height, font, 5, 4, debugger)

    buttons.collection["Collection Header"] = button("Collection", nil, nil, lg.getWidth() / 2 - button_width / 2, 5, button_width, button_height, font, 14, 4, debugger)
    buttons.collection["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.settings["Toggle Audio"] = button("Toggle Audio", toggle_audio, nil, lg.getWidth() / 2 - button_width * 1/4, lg.getHeight() / 2 - 100, button_width * 1.315, button_height, font, 19, 4, debugger)
    buttons.settings["Audio Enabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_enabled, 1/4, -6, 16)
    buttons.settings["Audio Disabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_disabled, 1/4, -6, 16)
    buttons.settings["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.level_select["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.level_select["Select Opponent"] = button("Select Opponent", nil, nil, 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.level_select["Ice King"] = avatar("Ice King", "Ice King", update_game_state, "biome_select", 109, 20, font, opponent_button_width, opponent_button_height, avatars.ice_king, 1, debugger)
    buttons.level_select["Princess Bubblegum"] = avatar("  Princess\nBubblegum", "Princess Bubblegum", update_game_state, "biome_select", 80, 0, font, opponent_button_width, opponent_button_height, avatars.princess_bubblegum, 1, debugger)
    buttons.level_select["Marcelline"] = avatar("Marcelline", "Marcelline", update_game_state, "biome_select", 84, 20, font, opponent_button_width, opponent_button_height, avatars.marcelline, 1, debugger)

    buttons.biome_select["L1 Previous Biome"] = button("", prev_biome, 1, L1_x + 5, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/left_arrow.png"), 1/8, -56, -8)
    buttons.biome_select["L1 Next Biome"] = button("", next_biome, 1, L1_x + 145, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/right_arrow.png"), 1/8, -56, -8)

    buttons.biome_select["L2 Previous Biome"] = button("", prev_biome, 2, L2_x + 5, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/left_arrow.png"), 1/8, -56, -8)
    buttons.biome_select["L2 Next Biome"] = button("", next_biome, 2, L2_x + 145, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/right_arrow.png"), 1/8, -56, -8)

    buttons.biome_select["L3 Previous Biome"] = button("", prev_biome, 3, L3_x + 5, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/left_arrow.png"), 1/8, -56, -8)
    buttons.biome_select["L3 Next Biome"] = button("", next_biome, 3, L3_x + 145, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/right_arrow.png"), 1/8, -56, -8)

    buttons.biome_select["L4 Previous Biome"] = button("", prev_biome, 4, L4_x + 5, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/left_arrow.png"), 1/8, -56, -8)
    buttons.biome_select["L4 Next Biome"] = button("", next_biome, 4, L4_x + 145, L_y - 5 + biome_height - button_height, button_width * 2/8, button_height, font, 5, 5, debugger, lg.newImage("assets/icons/right_arrow.png"), 1/8, -56, -8)

    buttons.biome_select["Back"] = button("Back", update_game_state, "level_select", 5, 5, button_width * 3.9/8, button_height, font, 5, 5, debugger)
    buttons.biome_select["Play"] = button("Play", update_game_state, "playing", lg.getWidth() - button_width * 3.5/8 - 5, lg.getHeight() - button_height - 5, button_width * 3.5/8, button_height, font, 5, 5, debugger)

    buttons.biome_select["Princess Bubblegum"] = button("Princess's Bubblegum Biomes", nil, nil, 5 + (lg.getWidth() - get_button_size("Princess's Bubblegum Biomes")) / 2, 100 - button_height - 10, get_button_size("Princess's Bubblegum Biomes"), button_height, font, 13, 5, debugger)
    buttons.biome_select["Ice King"] = button("Ice King's Biomes", nil, nil, 5 + (lg.getWidth() - get_button_size("Ice King's Biomes")) / 2, 100 - button_height - 10, get_button_size("Ice King's Biomes"), button_height, font, 13, 5, debugger)
    buttons.biome_select["Marcelline"] = button("Marcelline's Biomes", nil, nil, 5 + (lg.getWidth() - get_button_size("Marcelline's Biomes")) / 2, 100 - button_height - 10, get_button_size("Marcelline's Biomes"), button_height, font, 13, 5, debugger)
    buttons.biome_select["Your Biomes"] = button("Your Biomes", nil, nil, 5 + (lg.getWidth() - get_button_size("Your Biomes")) / 2, 715, get_button_size("Your Biomes"), button_height, font, 8, 5, debugger)

    buttons.character_select["Back"] = button("Back", update_game_state, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.character_select["Gabe"] = avatar("Gabe", "Gabe", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.gabe, 0.7, debugger)
    buttons.character_select["Jamie"] = avatar("Jamie", "Jamie", update_game_state, "menu", 85, 20, font, opponent_button_width, opponent_button_height, avatars.jamie, 0.7, debugger)
    buttons.character_select["Michael"] = avatar("Michael", "Michael", update_game_state, "menu", 75, 20, font, opponent_button_width, opponent_button_height, avatars.michael, 0.7, debugger)
    buttons.character_select["Josh"] = avatar("Josh", "Josh", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.josh, 0.7, debugger)
    buttons.character_select["Alem"] = avatar("Alem", "Alem", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.alem, 0.7, debugger)
    buttons.character_select["Darcy"] = avatar("Darcy", "Darcy", update_game_state, "menu", 85, 20, font, opponent_button_width, opponent_button_height, avatars.darcy, 0.7, debugger)

    buttons.playing["Back"] = button("Back", update_game_state, "level_select", lg.getWidth() - button_width * 5/8 - 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.playing["Card Background"] = button("Hand", placeholder, nil, 5, lg.getHeight() - card_background_height - 5, card_background_width, card_background_height, font, 19, 4, debugger)

    buttons.playing["Princess Bubblegum"] = button("Princess Bubblegum", nil, nil, 5 + lg.getWidth() - (827 + get_button_size("Princess Bubblegum")) / 2, 100 - button_height - 10, get_button_size("Princess Bubblegum"), button_height, font, 13, 5, debugger)
    buttons.playing["Ice King"] = button("Ice King", nil, nil, 5 + lg.getWidth() - (827 + get_button_size("Ice King")) / 2, 100 - button_height - 10, get_button_size("Ice King"), button_height, font, 7, 5, debugger)
    buttons.playing["Marcelline"] = button("Marcelline", nil, nil, 5 + lg.getWidth() - (827 + get_button_size("Marcelline")) / 2, 100 - button_height - 10, get_button_size("Marcelline"), button_height, font, 13, 5, debugger)

    buttons.playing["You"] = button("You", nil, nil, 5 + lg.getWidth() - (827 + get_button_size("You")) / 2, 715, get_button_size("You"), button_height, font, 3, 5, debugger)
    buttons.playing["You Stats"] = button("You", nil, nil, 375 - get_button_size("Ice King"), 400 + button_height + 10, get_button_size("You"), button_height, font, 3, 5, debugger)

    buttons.playing["MP"] = button("MP: " .. magic_points, nil, nil, 425 - 10 - get_button_size("MP: 10") - 10, 400 - button_height - 10, get_button_size("MP: 10"), button_height, font, 13, 4, debugger)
    buttons.playing["HP"] = button("HP: " .. health_points, nil, nil, 425 - 50 - get_button_size("HP: 100") - get_button_size("MP: 10") - 10, 400 - button_height - 10, get_button_size("HP: 100") + 5, button_height, font, 13, 4, debugger)

    buttons.playing["Your MP"] = button("MP: " .. magic_points, nil, nil, 425 - 10 - get_button_size("MP: 10") - 10, 415, get_button_size("MP: 10"), button_height, font, 13, 4, debugger)
    buttons.playing["Your HP"] = button("HP: " .. health_points, nil, nil, 425 - 50 - get_button_size("HP: 100") - get_button_size("MP: 10") - 10, 415, get_button_size("HP: 100") + 5, button_height, font, 13, 4, debugger)

    --buttons.playing["Ice King"] = avatar("Ice King", "Ice King", nil, nil, 60, 11, font, opponent_button_width, opponent_button_height, avatars.ice_king, opponent_scale, debugger)
    --buttons.playing["Princess Bubblegum"] = avatar("  Princess\nBubblegum", "Princess Bubblegum", nil, nil, 43, 0, font, opponent_button_width, opponent_button_height, avatars.princess_bubblegum, opponent_scale, debugger)
    --buttons.playing["Marcelline"] = avatar("Marcelline", "Marcelline", nil, nil, 44, 11, font, opponent_button_width, opponent_button_height, avatars.marcelline, opponent_scale, debugger)
end

function play_sound(sound)
    if audio then
        la.play(sound)
    end
end

function toggle_audio()
    audio = not audio
end

function new_background()
    local num
    repeat
        num = math.random(1, #background_files)
    until background_files[num] ~= chosen_background

    chosen_background = background_files[num]
    background = lg.newImage("assets/backgrounds/" .. chosen_background)
end

function debugger(debug_text)
    debug = debug_text
end

function print_kvarray(arr)
    x_pos = 10
    y_pos = 200
    lg.setColor(0, 0, 0)
    for k, v in pairs(arr) do
        lg.print(tostring(k) .. ": " .. tostring(v), x_pos, y_pos)
        y_pos = y_pos + 20
    end
end

function print_array(arr)
    x_pos = 10
    y_pos = 200
    lg.setColor(1, 0, 0)
    for i, v in ipairs(arr) do
        lg.print(tostring(v), x_pos, y_pos)
        x_pos = x_pos + 100
        if x_pos > 1000 then
            x_pos = 20
            y_pos = y_pos + 20
        end
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
    lg.draw(background, -(1500 - window_width) / 2, 0)
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
    buttons.menu["Switch Background"]:draw()
    --buttons.menu["nums"]:draw()
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
    while #player_hand < 8 and count < 50 do
        local index = math.random(1, #card_files)
        if not contains(chosen_indices, index) then
            table.insert(player_hand, card(card_files[index], img_widths, img_heights))
            table.insert(chosen_indices, index)
        end
    end
end

function next_biome(lane)
    local val = player_biome_counts[lane] + 1
    if val == -1 then
        val = 5
    elseif val == 6 then
        val = 1
    end
    player_biome_counts[lane] = val
end

function prev_biome(lane)
    local val = player_biome_counts[lane] - 1
    if val == 0 then
        val = 5
    elseif val == 6 then
        val = 0
    end
    player_biome_counts[lane] = val
end

local function render_biomes(x_offset, y_offset)
    for i, biome_type in ipairs(fields[chosen_opponent]) do
        biome_type:draw(x_offset, y_offset)
    end

    for i, biome_num in ipairs(player_biome_counts) do
        biome(biomes[biome_num], lane_to_x["L" .. i], L_y, biome_width, biome_height):draw(x_offset, y_offset)
    end
end

local function render_biome_select()
    renderBackground()
    buttons.biome_select["Back"]:draw()
    buttons.biome_select["Play"]:draw()

    render_biomes(0, 0)

    for name, button in pairs(buttons.biome_select) do
        if not contains(opponents, name) then
            button:draw()
        end
    end
    buttons.biome_select[chosen_opponent]:draw()
end

local function render_playing_state()
    renderBackground()

    render_biomes(210, 0)

    count = count + 1

    -- Draw Opponent
    buttons.playing[chosen_opponent]:draw()
    buttons.playing["You"]:draw()

    buttons.playing["HP"]:draw()
    buttons.playing["MP"]:draw()

    buttons.playing["Your HP"]:draw()
    buttons.playing["Your MP"]:draw()

    buttons.playing["Back"]:draw()
    buttons.playing["Card Background"]:draw()


    local rotation = -#player_hand/2 * 0.1
    local rotation_difference = 0.1 -- Amount to rotate next drawn card
    local x_pos = -img_widths * 0.3 - 1
    local x_offset = 0
    local y_pos = - lg.getHeight() / 2 - img_heights

    local vertical_rotation = 0
    local vertical_rotation_difference = 0
    local vertical_x_pos = -img_widths * 0.3 - 30
    local vertical_x_offset = 45
    local vertical_y_pos = - lg.getHeight() / 2 - img_heights + 25

    local translation_x = 207
    local translation_y = lg.getHeight() * 5/4 + lg.getHeight() * 1/16 - 10

    love.graphics.push()
    love.graphics.translate(translation_x, translation_y)

    for i, card in ipairs(player_hand) do
        if mouse_over_hand then
            card:draw(vertical_x_pos - vertical_x_offset * (#player_hand - 1)/2, vertical_y_pos, vertical_rotation + vertical_rotation_difference * (i-1))
        else
            card:draw(x_pos - x_offset * (#player_hand - 1)/2, y_pos, rotation + rotation_difference * (i-1))
        end

        --Track Card Hitboxes
        if i ~= #player_hand then
            card_hitboxes[card] = {(vertical_x_pos - vertical_x_offset * (#player_hand - 1)/2) * 7/10 + translation_x, (vertical_y_pos) * 7/10 + translation_y, vertical_x_offset * 7/10, (img_heights/2) * 7/10}
        else
            card_hitboxes[card] = {(vertical_x_pos - vertical_x_offset * (#player_hand - 1)/2) * 7/10 + translation_x, (vertical_y_pos) * 7/10 + translation_y, (img_widths/2) * 7/10, (img_heights/2) * 7/10}
        end
        vertical_x_pos = vertical_x_pos + vertical_x_offset
    end
    love.graphics.pop()

    if held_card then
        held_card:draw((mouse.x - img_widths/4) * 10/7, (mouse.y - img_heights/4) * 10/7, 0)
    end

end

function love.update(dt)
    if game.state["playing"] then
        player_turn()
    end

    mouse.x, mouse.y = love.mouse.getPosition()

    if buttons.playing["Card Background"]:hover() then
        mouse_over_hand = true
    else
        mouse_over_hand = false
    end
end

local function get_game_state()
    for state, val in pairs(game.state) do
        if val == true then
            return state
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        -- Check if button is clicked
        for button_name, button in pairs(buttons[get_game_state()]) do
            button:checkPressed(x, y)
        end

        -- Check if card is clicked
        if game.state["playing"] then
            local card_number = 0
            for card, hitbox in pairs(card_hitboxes) do
                card_number = card_number + 1
                if x > hitbox[1] and x < hitbox[1] + hitbox[3] and y > hitbox[2] and y < hitbox[2] + hitbox[4] then
                    --Find index of card
                    for i, c in pairs(player_hand) do
                        if c == card then
                            table.remove(player_hand, i)
                        end
                    end
                    card_hitboxes[card] = nil
                    held_card = card
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
    elseif game.state["biome_select"] then
        render_biome_select()
    end

    if debugger_enabled then
        lg.setColor(1, 0, 0)
        lg.printf(debug, debug_font, 10, 70, window_width)
        lg.print(debug2, 20, 260)
        --lg.print(debug3, 20, 140)
        print_array(player_hand)
        lg.setColor(1, 1, 1)
    end
end
