local love = require "love"
local lg = love.graphics
local la = love.audio
local button = require "Button"
local avatar = require "Avatar"
local scandir = require "scandir"
local card = require "Card"
local stats = require "Stats"

reference_window_width = nil
reference_window_height = nil


local debug = "Debug Text"
local debug2 = "Debug Text"
local debugger_enabled = true

local debug_font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 20)
local font = love.graphics.newFont("assets/Jersey15-Regular.ttf", 50)

local audio = false

local card_files = {"Beach_Mum.png", "Big_Foot.png", "Big_Foot_Gold.png", "Blue_Slimey.png", "Blueberry_Djini.png", "Brain_Gooey.png", "Burning_Hand.png", "Cerebral_Bloodstorm.png", "Cornball.png", "Cornball_Gold.png", "Dark_Angel.png", "Dragon_claw.png", "Ghost_Djini.png", "Ghost_Ninja.png", "Ghost_Ninja_Gold.png", "Giant_Mummy_Hand.png", "Grape_Slimey.png", "Gray_Eyebat.png", "Gray_Eyebat_Gold.png", "Green_Cactaball.png", "Green_Cactaball_Gold.png", "Green_Mermaid.png", "Green_Merman.png", "Green_Merman_Gold.png", "Heavenly_Gazer_Gold.png", "Huskerbat.png", "Lime_slimey.png", "Mud_Angel_Gold.png", "Nicelands_Eye_Bat.png", "Orange_Slimey.png", "Ordinary_Ninja.png", "Peach_djini.png", "Sand_Angel.png", "Sand_Angel_Gold.png", "Sand_eyebat.png", "Sandfoot.png", "Travelin%27_Farmer.png", "Travelin%27_Skeleton.png", "Travelin_Wizard.png", "Unicycle_Knight.png", "Unicyclops.png", "Wall_Of_Sand.png", "Wall_of_Chocolate.png", "Wall_of_Ears.png"}
local background_files = {"background10.jpg", "background2.jpg", "background3.jpg", "background6.jpg", "background7.jpg", "background8.jpg"}

local chosen_background = ""

local w = 1440
local h = 900

local card_background_height = (lg.getHeight() * 3/8 + 10)
local card_background_width = (lg.getWidth()*5/8 - 96)

local card_hitboxes = {} --x, y, width, height

local button_width = 200
local button_height = 60
local opponent_button_width = 355
local opponent_button_height = 500

local opponent_pic_width = 355
local opponent_pic_height = 400

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

local L1_x = 218
local L2_x = 423
local L3_x = 628
local L4_x = 833
local opp_L_y = 100
local L_y = 405

local lane_to_x = {L1 = L1_x, L2 = L2_x, L3 = L3_x, L4 = L4_x}

local fields = {
    Player = {}
}

local magic_points = 1
local health_points = 100
local opponent_magic_points = 1
local opponent_health_points = 100

local resized

-- NOT LOCAL
mouse = {}
chosen_avatar = "Jamie"
chosen_opponent = "Ice King"
scroll_offset_y = 0
count = 0
mouse_over_hand = false
characters = {"Alem", "Gabe", "Jamie", "Darcy", "Josh", "Michael"}
played_cards = {}

animation_time = 0 -- how long it has been playing
animation_length = 0.1 -- how long it lasts
animation = false
animation_next_screen = nil

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

local card_stats = {
    Snake = stats(2, 3, 2, "N/A", 1),
    Big_Snake = stats(3, 3, 10, "N/A", 2),
    Baby_Snake = stats(1, 6, 1, "N/A", 2),
    Well_Fed_Snake = stats(2, 4, 2, "N/A", 1),
    Anaconda = stats(6, 8, 8, "N/A", 3),
    Copperhead = stats(5, 10, 5, "N/A", 3),
    Zombie_Snake = stats(3, 5, 5, "N/A", 2),
    Cannibal_Snake = stats(3, 12, 3, "N/A", 2),
    Cobra = stats(4, 8, 15, "N/A", 3)
}

local deck1 = {
    "Snake",
    "Big_Snake",
    "Baby_Snake",
    "Well_Fed_Snake",
    "Anaconda",
    "Copperhead",
    "Zombie_Snake",
    "Cannibal_Snake",
    "Cobra"
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


    reference_window_width = 1440
    reference_window_height = 872

    --love.window.setFullscreen(true)
    love.window.setMode(reference_window_width, reference_window_height, {resizable=true, vsync=0, minwidth=reference_window_width/2, minheight=reference_window_height/2})

    local button_background_width, button_background_height = resize(240, 1), resize(425, 2)

    for i, card in pairs(scandir("/Users/jameslandolt/IdeaProjects/SnakeGame/assets/Snake_Cards")) do
        if i > 3 then
            cards[i-3] = lg.newImage("assets/Snake_Cards/" .. card)
        end
    end

    img_widths = cards[1]:getWidth()
    img_heights = cards[1]:getHeight()

    hover_sound = la.newSource("assets/audio/hover.mp3", "static")

    --shader = lg.newShader(shader_code)

    avatars.gabe = love.graphics.newImage("assets/characters/gabe.jpg")
    avatars.jamie = love.graphics.newImage("assets/characters/jamie.jpg")
    avatars.alem = love.graphics.newImage("assets/characters/alem.jpg")
    avatars.josh = love.graphics.newImage("assets/characters/josh.jpg")
    avatars.michael = love.graphics.newImage("assets/characters/michael.jpg")
    avatars.darcy = love.graphics.newImage("assets/characters/darcy.jpg")

    icons.audio_enabled = love.graphics.newImage("assets/icons/audio_enabled.png")
    icons.audio_disabled = love.graphics.newImage("assets/icons/audio_disabled.png")

    --love.window.setMode(reference_window_width, reference_window_height)

    new_background()

    -- If adding new button, remember to draw it, may need to add game state too
    buttons.menu["Play Game"] = button("Play Game", update_animation_screen, "playing", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 - 150, button_width, button_height, font, 9, 4, debugger)
    buttons.menu["Collection"] = button("Collection", update_animation_screen, "collection", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 - 50, button_width, button_height, font, 11, 4, debugger)
    buttons.menu["Character"] = button("Character", update_animation_screen, "character_select", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 + 50, button_width, button_height, font, 6, 4, debugger)
    buttons.menu["Settings"] = button("Settings", update_animation_screen, "settings", lg.getWidth() / 2 - button_width / 2, lg.getHeight() / 2 + 150, button_width, button_height, font, 19, 4, debugger)
    buttons.menu["Button Background"] = button("", nil, nil, lg.getWidth() / 2 - button_background_width / 2, lg.getHeight() / 2 - button_background_height / 2 + resize(30, 2), button_background_width, button_background_height, font, 19, 4, debugger, nil, nil, nil, nil, true)

    buttons.menu["Switch Background"] = button("Switch Background", new_background, nil, lg.getWidth() - get_button_size("Switch Background") - 5, 5, get_button_size("Switch Background"), button_height, font, 5, 4, debugger)

    buttons.collection["Collection Header"] = button("Collection", nil, nil, lg.getWidth() / 2 - button_width / 2, 5, button_width, button_height, font, 14, 4, debugger)
    buttons.collection["Back"] = button("Back", update_animation_screen, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.settings["Toggle Audio"] = button("Toggle Audio", toggle_audio, nil, lg.getWidth() / 2 - button_width * 1/4, lg.getHeight() / 2 - 100, button_width * 1.315, button_height, font, 19, 4, debugger)
    buttons.settings["Audio Enabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_enabled, 1/4, -6, 16)
    buttons.settings["Audio Disabled"] = button("", nil, nil, lg.getWidth() / 2 - button_width * 3/4, lg.getHeight() / 2 - 100, button_width * 0.3, button_height, font, 19, 4, debugger, icons.audio_disabled, 1/4, -6, 16)
    buttons.settings["Back"] = button("Back", update_animation_screen, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.level_select["Back"] = button("Back", update_animation_screen, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.level_select["Select Opponent"] = button("Select Opponent", nil, nil, 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)

    buttons.character_select["Back"] = button("Back", update_animation_screen, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.character_select["Gabe"] = avatar("Gabe", "Gabe", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.gabe, 0.7, debugger)
    buttons.character_select["Jamie"] = avatar("Jamie", "Jamie", update_game_state, "menu", 85, 20, font, opponent_button_width, opponent_button_height, avatars.jamie, 0.7, debugger)
    buttons.character_select["Michael"] = avatar("Michael", "Michael", update_game_state, "menu", 75, 20, font, opponent_button_width, opponent_button_height, avatars.michael, 0.7, debugger)
    buttons.character_select["Josh"] = avatar("Josh", "Josh", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.josh, 0.7, debugger)
    buttons.character_select["Alem"] = avatar("Alem", "Alem", update_game_state, "menu", 95, 20, font, opponent_button_width, opponent_button_height, avatars.alem, 0.7, debugger)
    buttons.character_select["Darcy"] = avatar("Darcy", "Darcy", update_game_state, "menu", 85, 20, font, opponent_button_width, opponent_button_height, avatars.darcy, 0.7, debugger)

    buttons.playing["Back"] = button("Back", update_animation_screen, "menu", 5, 5, button_width * 5/8, button_height, font, 19, 4, debugger)
    buttons.playing["Card Background"] = button("Hand", placeholder, nil, 5, lg.getHeight() - card_background_height - 5, card_background_width, card_background_height, font, 19, 4, debugger)


    buttons.playing["You"] = button("You", nil, nil, 5 + lg.getWidth() - (827 + get_button_size("You")) / 2, 715, get_button_size("You"), button_height, font, 3, 5, debugger)
    buttons.playing["You Stats"] = button("You", nil, nil, 375 - get_button_size("Ice King"), 400 + button_height + 10, get_button_size("You"), button_height, font, 3, 5, debugger)

    buttons.playing["MP"] = button("MP: " .. opponent_magic_points, nil, nil, 425 - 10 - get_button_size("MP: 10") - 10, 400 - button_height - 10, get_button_size("MP: 10"), button_height, font, 13, 4, debugger)
    buttons.playing["HP"] = button("HP: " .. opponent_health_points, nil, nil, 425 - 50 - get_button_size("HP: 100") - get_button_size("MP: 10") - 10, 400 - button_height - 10, get_button_size("HP: 100") + 5, button_height, font, 13, 4, debugger)

    buttons.playing["Your MP"] = button("MP: " .. magic_points, nil, nil, 425 - 10 - get_button_size("MP: 10") - 10, 415, get_button_size("MP: 10"), button_height, font, 13, 4, debugger)
    buttons.playing["Your HP"] = button("HP: " .. health_points, nil, nil, 425 - 50 - get_button_size("HP: 100") - get_button_size("MP: 10") - 10, 415, get_button_size("HP: 100") + 5, button_height, font, 13, 4, debugger)

    buttons.playing["Floop L1"] = button("Floop" .. health_points, nil, nil, 425 - 50 - get_button_size("HP: 100") - get_button_size("MP: 10") - 10, 415, get_button_size("HP: 100") + 5, button_height, font, 13, 4, debugger)

end

function resize(num, type)
    -- type 1: x, type2: y
    if type == 1 then
        return num * lg.getWidth() / reference_window_width
    elseif type == 2 then
        return num * lg.getHeight() / reference_window_height
    else
        error("Unrecognised Type: (" .. tostring(type) .. ") passed to function: resize")
    end
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
    --repeat
    --    num = math.random(1, #background_files)
    --until background_files[num] ~= chosen_background
    --
    --chosen_background = background_files[num]
    --background = lg.newImage("assets/backgrounds/" .. chosen_background)
    background = lg.newImage("assets/backgrounds/SnakeBackground.png")
end

function debugger(debug_text)
    debug = debug_text
end

function print_kvarray(arr) -- can only be used in the love.draw function
    x_pos = 10
    y_pos = 200
    lg.setColor(0, 0, 0)
    for k, v in pairs(arr) do
        lg.print(tostring(k) .. ": " .. tostring(v), x_pos, y_pos)
        y_pos = y_pos + 20
    end
end

function print_array(arr, y_offset) -- can only be used in the love.draw function
    x_pos = 10
    y_pos = 200
    lg.setColor(1, 0, 0)
    for i, v in ipairs(arr) do
        lg.print(tostring(v), x_pos, y_pos + y_offset)
        x_pos = x_pos + 100
        if x_pos > 1000 then
            x_pos = 20
            y_pos = y_pos + 20
        end
    end
end

function update_animation_screen(screen)
    animation_next_screen = screen
end


function update_game_state(state)
    for state_name, state_value in pairs(game.state) do
        game.state[state_name] = false
    end
    game.state[state] = true
    animation = false
end

local function renderBackground()
    lg.scale(3/4) -- can just be 2 as window is unable to be resized
    lg.setColor(1, 1, 1)
    lg.draw(background, 0, 0)
    lg.scale(4/3)
end

local function render_main_menu()
    scroll_offset_y = 0
    renderBackground()
    buttons.menu["Button Background"]:draw()
    buttons.menu["Play Game"]:draw()
    buttons.menu["Collection"]:draw()
    buttons.menu["Character"]:draw()
    buttons.menu["Settings"]:draw()
    --buttons.menu["Avatar " .. chosen_avatar]:draw()
    --buttons.menu["Switch Background"]:draw()
    --buttons.menu["nums"]:draw()
end

local function render_cards()
    local offset_x = 69
    local offset_y = scroll_offset_y * 5 or 0
    if offset_y > 0 then
        offset_y = 0
    end
    renderBackground()
    print(lg.getWidth())
    for c, s in pairs(cards) do
        if offset_x + resize(img_widths, 1) > love.graphics.getWidth() then
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

    --buttons.character_select["Gabe"]:draw(150, 50 + scroll_offset_y * 5)
    --buttons.character_select["Jamie"]:draw(550, 50 + scroll_offset_y * 5)
    --buttons.character_select["Alem"]:draw(950, 50 + scroll_offset_y * 5)
    --
    --buttons.character_select["Michael"]:draw(150, 550 + scroll_offset_y * 5)
    --buttons.character_select["Darcy"]:draw(550, 550 + scroll_offset_y * 5)
    --buttons.character_select["Josh"]:draw(950, 550 + scroll_offset_y * 5)

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
    while #player_hand < 8 do
        local index = math.random(1, #deck1)
        if not contains(chosen_indices, index) then
            table.insert(player_hand, card(deck1[index] .. ".png", img_widths, img_heights))
            table.insert(chosen_indices, index)
        end
    end
end


local function render_playing_state()
    renderBackground()

    -- Draw Opponent
    --buttons.playing[chosen_opponent]:draw()
    --buttons.playing["You"]:draw()

    --buttons.playing["HP"]:draw()
    --buttons.playing["MP"]:draw()
    --
    --buttons.playing["Your HP"]:draw()
    --buttons.playing["Your MP"]:draw()

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
            card_hitboxes[card] = {(vertical_x_pos - vertical_x_offset * (#player_hand - 1)/2) * 7/10 + translation_x, (vertical_y_pos) * 7/10 + translation_y, 110, (img_heights/2) * 7/10}
        end
        vertical_x_pos = vertical_x_pos + vertical_x_offset
    end
    love.graphics.pop()

    if held_card then
        held_card:draw((mouse.x - img_widths/4) * 10/7, (mouse.y - img_heights/4) * 10/7, 0)
    end
end

local function abs(x)
    if x < 0 then
        return -x
    else
        return x
    end
end

function love.update(dt)
    local aspect_ratio = 1440 / 872
    if abs(w / h - aspect_ratio) > 0.008 then
        -- Width is too wide, so adjust height
        h = w / aspect_ratio
        love.window.setMode(w, h, {resizable=true})
    elseif abs(w / h - aspect_ratio) > 0.008 then
        -- Height is too tall, so adjust width
        w = h * aspect_ratio
        love.window.setMode(w, h, {resizable=true})
    end
    w = lg.getWidth()
    h = lg.getHeight()

    if game.state["playing"] then
        player_turn()
    end

    mouse.x, mouse.y = love.mouse.getPosition()

    if animation then
        animation_time = animation_time + dt
        if animation_time > animation_length * 3 and animation_next_screen then
            update_game_state(animation_next_screen)
            update_animation_screen(nil)
        end
    else
        animation_time = 0
    end

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


        if game.state["playing"] then
            local card_number = 0
            --if held_card then
            --    -- Check if biome is clicked with card in hand
            --    for lane, hitbox in pairs(player_biome_hitboxes) do
            --        if x > hitbox[1] and x < hitbox[1] + hitbox[3] and y > hitbox[2] and y < hitbox[2] + hitbox[4] then
            --            played_cards[lane] = held_card
            --            held_card = nil
            --            break
            --        end
            --    end
            --else
            --    -- Check if card is clicked with no card in hand
            --    for card, hitbox in pairs(card_hitboxes) do
            --        card_number = card_number + 1
            --        if x > hitbox[1] and x < hitbox[1] + hitbox[3] and y > hitbox[2] and y < hitbox[2] + hitbox[4] then
            --            -- Find index of clicked card
            --            for i, c in pairs(player_hand) do
            --                if c == card then
            --                    table.remove(player_hand, i)
            --                end
            --            end
            --            card_hitboxes[card] = nil
            --            held_card = card
            --        end
            --    end
            --end
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
    lg.scale(lg.getWidth()/reference_window_width)
    --lg.setShader(shader)
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
--    lg.setShader()

    debugger(tostring(lg.getWidth()) .. tostring(reference_window_width))
    if debugger_enabled then
        lg.setColor(1, 0, 0)
        lg.printf(debug, debug_font, 10, 70, reference_window_width)
        lg.print(debug2, 20, 260)
        --lg.print(debug3, 20, 140)

        lg.setColor(1, 1, 1)
    end
    lg.scale(reference_window_width/lg.getWidth())
end
