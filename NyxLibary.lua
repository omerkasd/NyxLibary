-- ============================================================
-- NyxUI Library v0.2
-- ScreenGui tabanli Roblox GUI kutuphanesi
-- Yenilikler: Flag sistemi, Config, Temalar, ColorPicker,
--             Search, Settings tab, KeySystem, Anti-detect,
--             Executor detect, Toggle tusu, Mobil destek,
--             Animasyon polish, Rejoin, pcall wrap
-- ============================================================

local NyxUI    = {}
NyxUI.__index  = NyxUI
NyxUI.Flags    = {}   -- global flag deposu
NyxUI.Version  = "0.2"

-- ============================================================
-- Servisler
-- ============================================================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local CoreGui          = game:GetService("CoreGui")

local LP = Players.LocalPlayer

-- ============================================================
-- Executor Detect
-- ============================================================
local Executor = "Unknown"
local function detectExecutor()
    if syn then return "Synapse X"
    elseif KRNL_LOADED then return "Krnl"
    elseif celery then return "Celery"
    elseif fluxus then return "Fluxus"
    elseif getexecutorname then
        local ok, name = pcall(getexecutorname)
        if ok and name then return name end
    end
    return "Unknown"
end
local ok, res = pcall(detectExecutor)
Executor = ok and res or "Unknown"

-- writefile/readfile destegi
local function canSaveFiles()
    return (writefile ~= nil and readfile ~= nil)
end

-- ============================================================
-- Anti-detect: ScreenGui ismi randomize
-- ============================================================
local function randomGuiName()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local name  = ""
    for i = 1, 12 do
        local idx = math.random(1, #chars)
        name = name .. chars:sub(idx, idx)
    end
    return name
end

-- ============================================================
-- Yardimci
-- ============================================================
local function tween(obj, props, t, style, dir)
    if not obj or not obj.Parent then return end
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
    tw:Play()
    return tw
end

local function make(class, props, parent)
    local ok2, obj = pcall(Instance.new, class)
    if not ok2 then return nil end
    for k, v in pairs(props) do
        pcall(function() obj[k] = v end)
    end
    if parent then obj.Parent = parent end
    return obj
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- JSON encode/decode (basit, nested desteklemez; HttpService kullan)
local function jsonEncode(t)
    local ok3, res3 = pcall(HttpService.JSONEncode, HttpService, t)
    return ok3 and res3 or nil
end
local function jsonDecode(s)
    local ok3, res3 = pcall(HttpService.JSONDecode, HttpService, s)
    return ok3 and res3 or nil
end

-- ============================================================
-- TEMALAR
-- ============================================================
local Themes = {
    Nyx = {
        name        = "Nyx",
        BG          = Color3.fromRGB(14,14,22),
        BG2         = Color3.fromRGB(11,11,19),
        BG3         = Color3.fromRGB(13,13,24),
        Border      = Color3.fromRGB(30,30,46),
        Border2     = Color3.fromRGB(24,24,42),
        Accent      = Color3.fromRGB(124,106,255),
        AccentLight = Color3.fromRGB(167,139,250),
        Text        = Color3.fromRGB(136,136,176),
        TextDim     = Color3.fromRGB(58,58,90),
        TextBright  = Color3.fromRGB(226,226,240),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Midnight = {
        name        = "Midnight",
        BG          = Color3.fromRGB(8,8,18),
        BG2         = Color3.fromRGB(6,6,14),
        BG3         = Color3.fromRGB(10,10,22),
        Border      = Color3.fromRGB(20,30,60),
        Border2     = Color3.fromRGB(16,24,50),
        Accent      = Color3.fromRGB(50,120,255),
        AccentLight = Color3.fromRGB(100,160,255),
        Text        = Color3.fromRGB(120,140,190),
        TextDim     = Color3.fromRGB(50,60,100),
        TextBright  = Color3.fromRGB(210,220,255),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Blood = {
        name        = "Blood",
        BG          = Color3.fromRGB(14,8,8),
        BG2         = Color3.fromRGB(10,6,6),
        BG3         = Color3.fromRGB(18,10,10),
        Border      = Color3.fromRGB(50,20,20),
        Border2     = Color3.fromRGB(38,16,16),
        Accent      = Color3.fromRGB(200,40,40),
        AccentLight = Color3.fromRGB(255,80,80),
        Text        = Color3.fromRGB(180,120,120),
        TextDim     = Color3.fromRGB(80,40,40),
        TextBright  = Color3.fromRGB(255,220,220),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Forest = {
        name        = "Forest",
        BG          = Color3.fromRGB(8,14,8),
        BG2         = Color3.fromRGB(6,10,6),
        BG3         = Color3.fromRGB(10,18,10),
        Border      = Color3.fromRGB(20,50,20),
        Border2     = Color3.fromRGB(16,38,16),
        Accent      = Color3.fromRGB(40,180,80),
        AccentLight = Color3.fromRGB(80,220,120),
        Text        = Color3.fromRGB(120,170,120),
        TextDim     = Color3.fromRGB(40,80,40),
        TextBright  = Color3.fromRGB(210,255,210),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Ocean = {
        name        = "Ocean",
        BG          = Color3.fromRGB(8,14,18),
        BG2         = Color3.fromRGB(6,10,14),
        BG3         = Color3.fromRGB(10,16,22),
        Border      = Color3.fromRGB(20,40,60),
        Border2     = Color3.fromRGB(16,32,50),
        Accent      = Color3.fromRGB(0,180,210),
        AccentLight = Color3.fromRGB(60,220,240),
        Text        = Color3.fromRGB(100,160,180),
        TextDim     = Color3.fromRGB(40,70,90),
        TextBright  = Color3.fromRGB(200,240,255),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Sunset = {
        name        = "Sunset",
        BG          = Color3.fromRGB(16,10,6),
        BG2         = Color3.fromRGB(12,8,4),
        BG3         = Color3.fromRGB(20,12,8),
        Border      = Color3.fromRGB(60,30,16),
        Border2     = Color3.fromRGB(46,24,12),
        Accent      = Color3.fromRGB(255,120,30),
        AccentLight = Color3.fromRGB(255,170,80),
        Text        = Color3.fromRGB(200,150,100),
        TextDim     = Color3.fromRGB(90,55,30),
        TextBright  = Color3.fromRGB(255,235,200),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Rose = {
        name        = "Rose",
        BG          = Color3.fromRGB(16,8,14),
        BG2         = Color3.fromRGB(12,6,10),
        BG3         = Color3.fromRGB(20,10,18),
        Border      = Color3.fromRGB(60,20,50),
        Border2     = Color3.fromRGB(46,16,40),
        Accent      = Color3.fromRGB(220,60,140),
        AccentLight = Color3.fromRGB(255,110,180),
        Text        = Color3.fromRGB(190,120,160),
        TextDim     = Color3.fromRGB(80,40,70),
        TextBright  = Color3.fromRGB(255,210,240),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Mono = {
        name        = "Mono",
        BG          = Color3.fromRGB(10,10,10),
        BG2         = Color3.fromRGB(7,7,7),
        BG3         = Color3.fromRGB(13,13,13),
        Border      = Color3.fromRGB(35,35,35),
        Border2     = Color3.fromRGB(26,26,26),
        Accent      = Color3.fromRGB(200,200,200),
        AccentLight = Color3.fromRGB(240,240,240),
        Text        = Color3.fromRGB(160,160,160),
        TextDim     = Color3.fromRGB(70,70,70),
        TextBright  = Color3.fromRGB(240,240,240),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Cyber = {
        name        = "Cyber",
        BG          = Color3.fromRGB(6,6,14),
        BG2         = Color3.fromRGB(4,4,10),
        BG3         = Color3.fromRGB(8,8,18),
        Border      = Color3.fromRGB(0,60,80),
        Border2     = Color3.fromRGB(0,46,60),
        Accent      = Color3.fromRGB(0,240,200),
        AccentLight = Color3.fromRGB(80,255,220),
        Text        = Color3.fromRGB(100,200,180),
        TextDim     = Color3.fromRGB(30,80,70),
        TextBright  = Color3.fromRGB(200,255,245),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
    Gold = {
        name        = "Gold",
        BG          = Color3.fromRGB(14,12,6),
        BG2         = Color3.fromRGB(10,8,4),
        BG3         = Color3.fromRGB(18,14,8),
        Border      = Color3.fromRGB(60,50,16),
        Border2     = Color3.fromRGB(46,38,12),
        Accent      = Color3.fromRGB(220,180,40),
        AccentLight = Color3.fromRGB(255,220,80),
        Text        = Color3.fromRGB(190,170,100),
        TextDim     = Color3.fromRGB(80,70,30),
        TextBright  = Color3.fromRGB(255,245,190),
        Success     = Color3.fromRGB(40,200,64),
        Warning     = Color3.fromRGB(254,188,46),
        Error       = Color3.fromRGB(255,95,87),
        White       = Color3.fromRGB(255,255,255),
    },
}

local ThemeNames = {}
for k in pairs(Themes) do table.insert(ThemeNames, k) end
table.sort(ThemeNames)

local ActiveTheme = Themes.Nyx
local ThemeCallbacks = {}  -- tema degisince rebuild icin

-- ============================================================
-- CONFIG SİSTEMİ
-- ============================================================
local CONFIG_FOLDER = "NyxUI_Configs"
local MAX_SLOTS     = 10

local function ensureFolder()
    if not canSaveFiles() then return end
    pcall(function()
        if not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
    end)
end

local function configPath(slotName)
    return CONFIG_FOLDER .. "/" .. slotName .. ".json"
end

local function listConfigs()
    if not canSaveFiles() then return {} end
    local list = {}
    pcall(function()
        ensureFolder()
        local files = listfiles(CONFIG_FOLDER)
        for _, f in ipairs(files) do
            local name = f:match("([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
    end)
    return list
end

local function saveConfig(slotName)
    if not canSaveFiles() then return false, "Executor dosya yazmayı desteklemiyor" end
    ensureFolder()
    local data = {}
    for flag, val in pairs(NyxUI.Flags) do
        -- Color3 serialize
        if typeof(val) == "Color3" then
            data[flag] = { __type="Color3", r=val.R, g=val.G, b=val.B }
        else
            data[flag] = val
        end
    end
    local json = jsonEncode(data)
    if not json then return false, "JSON encode hatasi" end
    local ok2, err = pcall(writefile, configPath(slotName), json)
    return ok2, err
end

local function loadConfig(slotName)
    if not canSaveFiles() then return false, "Executor dosya okumayı desteklemiyor" end
    local ok2, content = pcall(readfile, configPath(slotName))
    if not ok2 then return false, "Dosya okunamadi" end
    local data = jsonDecode(content)
    if not data then return false, "JSON decode hatasi" end
    for flag, val in pairs(data) do
        if type(val) == "table" and val.__type == "Color3" then
            NyxUI.Flags[flag] = Color3.new(val.r, val.g, val.b)
        else
            NyxUI.Flags[flag] = val
        end
    end
    -- flag callback'lerini tetikle
    if NyxUI._flagCallbacks then
        for flag, cb in pairs(NyxUI._flagCallbacks) do
            if NyxUI.Flags[flag] ~= nil then
                pcall(cb, NyxUI.Flags[flag])
            end
        end
    end
    return true
end

local function deleteConfig(slotName)
    if not canSaveFiles() then return false end
    local ok2 = pcall(delfile, configPath(slotName))
    return ok2
end

NyxUI._flagCallbacks = {}

local function registerFlag(flag, default, callback)
    if flag == nil or flag == "" then return end
    if NyxUI.Flags[flag] == nil then
        NyxUI.Flags[flag] = default
    end
    if callback then
        NyxUI._flagCallbacks[flag] = callback
    end
end

-- ============================================================
-- GUI KURULUM
-- ============================================================
local function setupGui()
    local guiName = randomGuiName()
    local gui
    -- CoreGui'ye koymayı dene (daha iyi anti-detect)
    local ok2 = pcall(function()
        gui = make("ScreenGui", {
            Name           = guiName,
            ResetOnSpawn   = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
        }, CoreGui)
    end)
    if not ok2 or not gui then
        -- fallback: PlayerGui
        local existing = LP.PlayerGui:FindFirstChild(guiName)
        if existing then existing:Destroy() end
        gui = make("ScreenGui", {
            Name           = guiName,
            ResetOnSpawn   = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
        }, LP.PlayerGui)
    end
    return gui
end

-- ============================================================
-- DRAG
-- ============================================================
local function makeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
    handle.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================
-- RESIZE
-- ============================================================
local function makeResizable(handle, target, minW, minH, onResize)
    local resizing, startMouse, startSize = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing   = true
            startMouse = Vector2.new(input.Position.X, input.Position.Y)
            startSize  = Vector2.new(target.AbsoluteSize.X, target.AbsoluteSize.Y)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not resizing then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - startMouse
            local nw = math.max(minW, startSize.X + delta.X)
            local nh = math.max(minH, startSize.Y + delta.Y)
            target.Size = UDim2.new(0, nw, 0, nh)
            if onResize then onResize(nw, nh) end
        end
    end)
end

-- ============================================================
-- COLOR PICKER YARDIMCILARI
-- ============================================================
local function hsvToRgb(h, s, v)
    if s == 0 then return v, v, v end
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p, q, t2 = v*(1-s), v*(1-f*s), v*(1-(1-f)*s)
    i = i % 6
    if i==0 then return v,t2,p elseif i==1 then return q,v,p
    elseif i==2 then return p,v,t2 elseif i==3 then return p,q,v
    elseif i==4 then return t2,p,v else return v,p,q end
end

local function rgbToHsv(r, g, b)
    local max, min2 = math.max(r,g,b), math.min(r,g,b)
    local v2 = max
    local d  = max - min2
    local s2 = max == 0 and 0 or d/max
    local h2 = 0
    if max ~= min2 then
        if max==r then h2=(g-b)/d+(g<b and 6 or 0)
        elseif max==g then h2=(b-r)/d+2
        else h2=(r-g)/d+4 end
        h2 = h2/6
    end
    return h2, s2, v2
end

-- ============================================================
-- ANA WINDOW
-- ============================================================
function NyxUI:Window(config)
    -- config = { title, subtitle, key, theme, toggleKey }
    config = config or {}
    local title      = config.title    or "NyxUI"
    local subtitle   = config.subtitle or NyxUI.Version
    local keyNeeded  = config.key      -- nil ise key system yok
    local themeName  = config.theme    or "Nyx"
    local toggleKey  = config.toggleKey or Enum.KeyCode.RightControl

    -- Tema uygula
    if Themes[themeName] then
        ActiveTheme = Themes[themeName]
    end
    local T = ActiveTheme  -- kisa alias

    local gui     = setupGui()
    local visible = true

    -- ============================================================
    -- KEY SYSTEM
    -- ============================================================
    if keyNeeded then
        local keyValid = false
        local keyFrame = make("Frame", {
            Size             = UDim2.new(0,340,0,160),
            Position         = UDim2.new(0.5,-170,0.5,-80),
            BackgroundColor3 = T.BG,
            BorderSizePixel  = 0,
        }, gui)
        make("UICorner", {CornerRadius=UDim.new(0,10)}, keyFrame)
        make("UIStroke",  {Color=T.Border, Thickness=1}, keyFrame)

        make("TextLabel", {
            Size=UDim2.new(1,0,0,40), Position=UDim2.new(0,0,0,10),
            BackgroundTransparency=1, Text="Key Doğrulama",
            TextColor3=T.TextBright, Font=Enum.Font.GothamBold, TextSize=16,
        }, keyFrame)
        make("TextLabel", {
            Size=UDim2.new(1,-20,0,20), Position=UDim2.new(0,10,0,46),
            BackgroundTransparency=1, Text="Lütfen geçerli key'i girin.",
            TextColor3=T.TextDim, Font=Enum.Font.Gotham, TextSize=12,
        }, keyFrame)

        local keyInput = make("TextBox", {
            Size=UDim2.new(1,-24,0,34), Position=UDim2.new(0,12,0,74),
            BackgroundColor3=T.BG3, BorderSizePixel=0,
            Text="", PlaceholderText="Key girin...",
            PlaceholderColor3=T.TextDim, TextColor3=T.Text,
            Font=Enum.Font.Code, TextSize=13,
            ClearTextOnFocus=false,
        }, keyFrame)
        make("UICorner",{CornerRadius=UDim.new(0,6)}, keyInput)
        make("UIStroke",{Color=T.Border2, Thickness=1}, keyInput)
        make("UIPadding",{PaddingLeft=UDim.new(0,10)}, keyInput)

        local keyStatus = make("TextLabel", {
            Size=UDim2.new(1,0,0,20), Position=UDim2.new(0,0,0,116),
            BackgroundTransparency=1, Text="",
            TextColor3=T.Error, Font=Enum.Font.Gotham, TextSize=11,
        }, keyFrame)

        local keyBtn = make("TextButton", {
            Size=UDim2.new(0,80,0,30), Position=UDim2.new(1,-92,0,118),
            BackgroundColor3=T.Accent, BorderSizePixel=0,
            Text="Doğrula", TextColor3=T.White,
            Font=Enum.Font.GothamBold, TextSize=12,
            AutoButtonColor=false,
        }, keyFrame)
        make("UICorner",{CornerRadius=UDim.new(0,6)}, keyBtn)

        -- Key doğrulama: string veya fonksiyon destekler
        keyBtn.MouseButton1Click:Connect(function()
            local entered = keyInput.Text
            local valid   = false
            if type(keyNeeded) == "string" then
                valid = (entered == keyNeeded)
            elseif type(keyNeeded) == "function" then
                local ok2, res2 = pcall(keyNeeded, entered)
                valid = ok2 and res2
            end
            if valid then
                keyFrame:Destroy()
                keyValid = true
            else
                keyStatus.Text = "Geçersiz key!"
                tween(keyFrame, {Position=UDim2.new(0.5,-178,0.5,-80)}, 0.05, Enum.EasingStyle.Quad)
                task.delay(0.05, function()
                    tween(keyFrame, {Position=UDim2.new(0.5,-162,0.5,-80)}, 0.05, Enum.EasingStyle.Quad)
                    task.delay(0.05, function()
                        tween(keyFrame, {Position=UDim2.new(0.5,-170,0.5,-80)}, 0.08, Enum.EasingStyle.Back)
                    end)
                end)
            end
        end)

        -- Key girilene kadar bekle
        repeat task.wait(0.1) until keyValid
    end

    -- ============================================================
    -- ANA PENCERE
    -- ============================================================
    local win = make("Frame", {
        Name             = "NyxWindow",
        Size             = UDim2.new(0,580,0,420),
        Position         = UDim2.new(0.5,-290,0.5,-210),
        BackgroundColor3 = T.BG,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, gui)
    make("UICorner", {CornerRadius=UDim.new(0,10)}, win)
    make("UIStroke",  {Color=T.Border, Thickness=1}, win)

    -- Giriş animasyonu
    win.Size             = UDim2.new(0,580,0,0)
    win.BackgroundTransparency = 1
    tween(win, {Size=UDim2.new(0,580,0,420), BackgroundTransparency=0}, 0.4, Enum.EasingStyle.Back)

    -- ============================================================
    -- TITLEBAR
    -- ============================================================
    local titlebar = make("Frame", {
        Name             = "Titlebar",
        Size             = UDim2.new(1,0,0,46),
        BackgroundColor3 = T.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 2,
    }, win)
    make("UIStroke", {Color=T.Border, Thickness=1, ApplyStrokeMode=Enum.ApplyStrokeMode.Border}, titlebar)

    -- Logo
    local logo = make("Frame", {
        Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,12,0.5,-12),
        BackgroundColor3=T.Accent, BorderSizePixel=0,
    }, titlebar)
    make("UICorner",   {CornerRadius=UDim.new(0,6)}, logo)
    make("UIGradient", {Color=ColorSequence.new(T.Accent,T.AccentLight), Rotation=135}, logo)
    make("TextLabel",  {
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="N", TextColor3=T.White, Font=Enum.Font.GothamBold, TextSize=12,
    }, logo)

    make("TextLabel", {
        Size=UDim2.new(0,200,1,0), Position=UDim2.new(0,44,0,0),
        BackgroundTransparency=1, Text=title,
        TextColor3=T.TextBright, Font=Enum.Font.GothamBold, TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, titlebar)
    make("TextLabel", {
        Size=UDim2.new(0,80,1,0), Position=UDim2.new(0,44+200,0,0),
        BackgroundTransparency=1, Text=subtitle,
        TextColor3=T.TextDim, Font=Enum.Font.Code, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, titlebar)

    -- Executor badge
    make("TextLabel", {
        Size=UDim2.new(0,120,0,18), Position=UDim2.new(0.5,-60,0.5,-9),
        BackgroundColor3=T.BG3, BorderSizePixel=0,
        Text=Executor, TextColor3=T.TextDim,
        Font=Enum.Font.Code, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Center,
    }, titlebar):Parent and make("UICorner",{CornerRadius=UDim.new(0,4)}, titlebar:FindFirstChildWhichIsA("TextLabel", true))

    -- Pencere butonları
    local ctrlFrame = make("Frame", {
        Size=UDim2.new(0,62,0,26), Position=UDim2.new(1,-72,0.5,-13),
        BackgroundTransparency=1,
    }, titlebar)
    make("UIListLayout", {
        FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,6),
        VerticalAlignment=Enum.VerticalAlignment.Center,
    }, ctrlFrame)

    local function makeWinBtn(text, color)
        local btn = make("TextButton", {
            Size=UDim2.new(0,26,0,26),
            BackgroundColor3=color,
            BorderSizePixel=0,
            Text=text,
            TextColor3=Color3.fromRGB(0,0,0),
            Font=Enum.Font.GothamBold,
            TextSize=13,
            AutoButtonColor=false,
        }, ctrlFrame)
        make("UICorner", {CornerRadius=UDim.new(0,6)}, btn)
        btn.MouseEnter:Connect(function() tween(btn,{BackgroundTransparency=0.25},0.1) end)
        btn.MouseLeave:Connect(function() tween(btn,{BackgroundTransparency=0},0.1) end)
        btn.MouseButton1Down:Connect(function() tween(btn,{Size=UDim2.new(0,22,0,22)},0.07,Enum.EasingStyle.Quad) end)
        btn.MouseButton1Up:Connect(function() tween(btn,{Size=UDim2.new(0,26,0,26)},0.12,Enum.EasingStyle.Back) end)
        return btn
    end

    local minimized = false
    local miniBtn  = makeWinBtn("−", T.Warning)
    local closeBtn = makeWinBtn("✕", T.Error)

    miniBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(win,{Size=UDim2.new(0,580,0,46)},0.25,Enum.EasingStyle.Quart)
        else
            tween(win,{Size=UDim2.new(0,580,0,420)},0.32,Enum.EasingStyle.Back)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        tween(win,{Size=UDim2.new(0,580,0,0),BackgroundTransparency=1},0.25,Enum.EasingStyle.Quart)
        task.delay(0.3, function() gui:Destroy() end)
    end)

    makeDraggable(titlebar, win)

    -- ============================================================
    -- TAB BARI
    -- ============================================================
    local tabbar = make("Frame", {
        Name=             "Tabbar",
        Size=             UDim2.new(1,0,0,36),
        Position=         UDim2.new(0,0,0,46),
        BackgroundColor3= T.BG2,
        BorderSizePixel=  0,
    }, win)
    make("UIStroke", {Color=T.Border, Thickness=1, ApplyStrokeMode=Enum.ApplyStrokeMode.Border}, tabbar)
    make("UIListLayout", {
        FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,2),
        VerticalAlignment=Enum.VerticalAlignment.Bottom,
    }, tabbar)
    make("UIPadding", {PaddingLeft=UDim.new(0,4)}, tabbar)

    -- ============================================================
    -- GÖVDE
    -- ============================================================
    local body = make("Frame", {
        Name=            "Body",
        Size=            UDim2.new(1,0,1,-82),
        Position=        UDim2.new(0,0,0,82),
        BackgroundTransparency=1,
        BorderSizePixel= 0,
        ClipsDescendants=true,
    }, win)

    -- Sidebar
    local sidebar = make("Frame", {
        Name=            "Sidebar",
        Size=            UDim2.new(0,114,1,0),
        BackgroundColor3=T.BG2,
        BorderSizePixel= 0,
    }, body)
    make("UIStroke", {Color=T.Border,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border}, sidebar)
    make("UIListLayout", {
        FillDirection=Enum.FillDirection.Vertical,
        Padding=UDim.new(0,6),
        SortOrder=Enum.SortOrder.LayoutOrder,
    }, sidebar)
    make("UIPadding", {PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,10)}, sidebar)

    -- İçerik alanı
    local contentArea = make("Frame", {
        Name=            "ContentArea",
        Size=            UDim2.new(1,-114,1,0),
        Position=        UDim2.new(0,114,0,0),
        BackgroundTransparency=1,
        BorderSizePixel= 0,
        ClipsDescendants=true,
    }, body)

    -- Resize
    local resizeBtn = make("TextButton", {
        Name="ResizeBtn",
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new(1,-20,1,-20),
        BackgroundTransparency=1,
        Text="⌟", TextColor3=T.AccentLight,
        Font=Enum.Font.GothamBold, TextSize=16,
        TextTransparency=0.6, ZIndex=10,
        AutoButtonColor=false,
    }, win)
    resizeBtn.MouseEnter:Connect(function() tween(resizeBtn,{TextTransparency=0},0.15) end)
    resizeBtn.MouseLeave:Connect(function() tween(resizeBtn,{TextTransparency=0.6},0.15) end)
    makeResizable(resizeBtn, win, 400, 280, function(nw, nh)
        body.Size = UDim2.new(1,0,1,-82)
    end)

    -- ============================================================
    -- BİLDİRİM CONTAINER
    -- ============================================================
    local notifHolder = make("Frame", {
        Name="NotifHolder",
        Size=UDim2.new(0,270,1,0),
        Position=UDim2.new(1,-280,0,0),
        BackgroundTransparency=1,
        ZIndex=200,
    }, gui)
    local notifLayout = make("UIListLayout", {
        FillDirection=Enum.FillDirection.Vertical,
        Padding=UDim.new(0,8),
        VerticalAlignment=Enum.VerticalAlignment.Bottom,
        SortOrder=Enum.SortOrder.LayoutOrder,
    }, notifHolder)
    make("UIPadding", {PaddingBottom=UDim.new(0,16)}, notifHolder)

    -- ============================================================
    -- TAB YÖNETİMİ
    -- ============================================================
    local tabs      = {}
    local activeTab = nil

    local function switchTab(tabObj)
        if activeTab == tabObj then return end
        if activeTab then
            tween(activeTab.content,    {Position=UDim2.new(-1,0,0,0)}, 0.2, Enum.EasingStyle.Quart)
            tween(activeTab.btn,        {TextColor3=T.TextDim},          0.15)
            tween(activeTab.indicator,  {BackgroundTransparency=1},      0.15)
            tween(activeTab.searchBar,  {Size=UDim2.new(0,0,0,26)},      0.2)
        end
        activeTab = tabObj
        tabObj.content.Position = UDim2.new(1,0,0,0)
        tween(tabObj.content,   {Position=UDim2.new(0,0,0,0)},    0.22, Enum.EasingStyle.Quart)
        tween(tabObj.btn,       {TextColor3=T.AccentLight},        0.15)
        tween(tabObj.indicator, {BackgroundTransparency=0},        0.15)
    end

    -- ============================================================
    -- WINDOW OBJESİ
    -- ============================================================
    local winObj = {}

    -- ============================================================
    -- TAB
    -- ============================================================
    function winObj:Tab(name, icon)
        local btn = make("TextButton", {
            Size=UDim2.new(0,0,0,32),
            AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,
            Text= icon and (icon.." "..name) or name,
            TextColor3=T.TextDim,
            Font=Enum.Font.GothamSemibold,
            TextSize=12,
            BorderSizePixel=0,
            AutoButtonColor=false,
        }, tabbar)
        make("UIPadding", {PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14)}, btn)

        local indicator = make("Frame", {
            Size=UDim2.new(1,0,0,2),
            BackgroundColor3=T.AccentLight,
            BorderSizePixel=0,
            BackgroundTransparency=1,
        }, btn)
        make("UICorner",   {CornerRadius=UDim.new(0,2)}, indicator)
        make("UIGradient", {Color=ColorSequence.new(T.Accent,T.AccentLight),Rotation=90}, indicator)

        -- İçerik
        local contentWrap = make("Frame", {
            Size=UDim2.new(1,0,1,0),
            Position=UDim2.new(1,0,0,0),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ClipsDescendants=true,
        }, contentArea)

        -- Arama kutusu
        local searchBar = make("TextBox", {
            Size=UDim2.new(0,0,0,26),
            Position=UDim2.new(0,10,0,8),
            BackgroundColor3=T.BG3,
            BorderSizePixel=0,
            Text="",
            PlaceholderText="🔍  Ara...",
            PlaceholderColor3=T.TextDim,
            TextColor3=T.Text,
            Font=Enum.Font.Gotham,
            TextSize=11,
            ClearTextOnFocus=false,
            Visible=false,
        }, contentWrap)
        make("UICorner",  {CornerRadius=UDim.new(0,6)}, searchBar)
        make("UIStroke",  {Color=T.Border2, Thickness=1}, searchBar)
        make("UIPadding", {PaddingLeft=UDim.new(0,8)}, searchBar)

        -- Arama toggle butonu (tab'ın yanında)
        -- Scroll content
        local content = make("ScrollingFrame", {
            Size=UDim2.new(1,0,1,-0,0),
            Position=UDim2.new(0,0,0,0),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ScrollBarThickness=3,
            ScrollBarImageColor3=T.TextDim,
            CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            ClipsDescendants=true,
        }, contentWrap)
        make("UIListLayout", {
            FillDirection=Enum.FillDirection.Vertical,
            Padding=UDim.new(0,6),
            SortOrder=Enum.SortOrder.LayoutOrder,
        }, content)
        make("UIPadding", {
            PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10),
            PaddingTop=UDim.new(0,10),  PaddingBottom=UDim.new(0,10),
        }, content)

        -- Arama işlevi
        local searchOpen = false
        searchBar:GetPropertyChangedSignal("Text"):Connect(function()
            local query = searchBar.Text:lower()
            for _, child in ipairs(content:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    local lbl = child:FindFirstChildWhichIsA("TextLabel")
                    if lbl then
                        local match = query == "" or lbl.Text:lower():find(query, 1, true)
                        child.Visible = match ~= nil
                    end
                end
            end
        end)

        local tabObj = {btn=btn, content=content, indicator=indicator, searchBar=searchBar, contentWrap=contentWrap}
        table.insert(tabs, tabObj)

        btn.MouseButton1Click:Connect(function() switchTab(tabObj) end)
        btn.MouseEnter:Connect(function()
            if activeTab~=tabObj then tween(btn,{TextColor3=T.Text},0.12) end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab~=tabObj then tween(btn,{TextColor3=T.TextDim},0.12) end
        end)

        if #tabs == 1 then switchTab(tabObj) end

        -- ============================================================
        -- SECTION
        -- ============================================================
        local tabContent = content
        local sectionObj = {}

        function sectionObj:Section(sectionName)
            local sec = make("Frame", {
                Size=UDim2.new(1,0,0,26),
                BackgroundTransparency=1,
                BorderSizePixel=0,
            }, tabContent)
            make("TextLabel", {
                Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1,
                Text=sectionName:upper(),
                TextColor3=T.TextDim,
                Font=Enum.Font.Code,
                TextSize=9,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, sec)
            make("Frame", {
                Size=UDim2.new(1,0,0,1),
                Position=UDim2.new(0,0,1,-1),
                BackgroundColor3=T.Border2,
                BorderSizePixel=0,
            }, sec)

            local itemObj = {}

            -- ================================================
            -- TOGGLE
            -- ================================================
            function itemObj:Toggle(opts)
                opts = type(opts)=="table" and opts or {label=opts, flag=opts}
                local label   = opts.label   or "Toggle"
                local flag    = opts.flag    or label
                local default = opts.default or false
                local callback= opts.callback

                registerFlag(flag, default, callback)
                local state = NyxUI.Flags[flag]

                local row = make("TextButton", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                    Text="", AutoButtonColor=false,
                }, tabContent)
                make("UICorner", {CornerRadius=UDim.new(0,7)}, row)
                make("UIStroke", {Color=T.Border2, Thickness=1}, row)

                local lbl = make("TextLabel", {
                    Size=UDim2.new(1,-54,1,0), Position=UDim2.new(0,12,0,0),
                    BackgroundTransparency=1, Text=label,
                    TextColor3=T.Text, Font=Enum.Font.GothamSemibold, TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, row)

                local track = make("Frame", {
                    Size=UDim2.new(0,34,0,18), Position=UDim2.new(1,-46,0.5,-9),
                    BackgroundColor3=state and T.Accent or T.BG2,
                    BorderSizePixel=0,
                }, row)
                make("UICorner",{CornerRadius=UDim.new(1,0)}, track)

                local knob = make("Frame", {
                    Size=UDim2.new(0,12,0,12),
                    Position=state and UDim2.new(0,19,0.5,-6) or UDim2.new(0,3,0.5,-6),
                    BackgroundColor3=T.White, BorderSizePixel=0,
                }, track)
                make("UICorner",{CornerRadius=UDim.new(1,0)}, knob)

                local function setState(v, silent)
                    state = v
                    NyxUI.Flags[flag] = v
                    tween(track, {BackgroundColor3=v and T.Accent or T.BG2}, 0.18)
                    tween(knob,  {Position=v and UDim2.new(0,19,0.5,-6) or UDim2.new(0,3,0.5,-6)}, 0.18)
                    if not silent and callback then pcall(callback, v) end
                end

                row.MouseButton1Click:Connect(function()
                    setState(not state)
                    tween(row, {BackgroundColor3=Color3.fromRGB(16,16,28)}, 0.07)
                    task.delay(0.07, function() tween(row, {BackgroundColor3=T.BG3}, 0.15) end)
                end)
                row.MouseEnter:Connect(function() tween(row,{BackgroundColor3=Color3.fromRGB(15,15,26)},0.12) end)
                row.MouseLeave:Connect(function() tween(row,{BackgroundColor3=T.BG3},0.12) end)

                local ctrl = {}
                function ctrl:Set(v) setState(v, false) end
                function ctrl:Get() return state end
                NyxUI._flagCallbacks[flag] = function(v) setState(v, true) end
                return ctrl
            end

            -- ================================================
            -- SLIDER
            -- ================================================
            function itemObj:Slider(opts)
                opts = type(opts)=="table" and opts or {label=opts}
                local label    = opts.label    or "Slider"
                local flag     = opts.flag     or label
                local min      = opts.min      or 0
                local max      = opts.max      or 100
                local default  = opts.default  or min
                local suffix   = opts.suffix   or ""
                local callback = opts.callback
                local step     = opts.step     or 1

                registerFlag(flag, default, callback)
                local value = NyxUI.Flags[flag]

                local row = make("Frame", {
                    Size=UDim2.new(1,0,0,52),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                }, tabContent)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, row)
                make("UIStroke",{Color=T.Border2, Thickness=1}, row)

                make("TextLabel", {
                    Size=UDim2.new(1,-70,0,26), Position=UDim2.new(0,12,0,0),
                    BackgroundTransparency=1, Text=label,
                    TextColor3=T.Text, Font=Enum.Font.GothamSemibold, TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, row)

                local valLbl = make("TextLabel", {
                    Size=UDim2.new(0,58,0,26), Position=UDim2.new(1,-70,0,0),
                    BackgroundTransparency=1,
                    Text=tostring(value)..suffix,
                    TextColor3=T.AccentLight, Font=Enum.Font.Code, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Right,
                }, row)

                local trackBG = make("Frame", {
                    Size=UDim2.new(1,-24,0,4), Position=UDim2.new(0,12,1,-16),
                    BackgroundColor3=T.BG2, BorderSizePixel=0,
                }, row)
                make("UICorner",{CornerRadius=UDim.new(1,0)}, trackBG)

                local rel0 = (value-min)/(max-min)
                local fill = make("Frame", {
                    Size=UDim2.new(rel0,0,1,0),
                    BackgroundColor3=T.Accent, BorderSizePixel=0,
                }, trackBG)
                make("UICorner",{CornerRadius=UDim.new(1,0)}, fill)
                make("UIGradient",{Color=ColorSequence.new(T.Accent,T.AccentLight)}, fill)

                local thumb = make("Frame", {
                    Size=UDim2.new(0,14,0,14),
                    Position=UDim2.new(rel0,-7,0.5,-7),
                    BackgroundColor3=T.AccentLight, BorderSizePixel=0, ZIndex=2,
                }, trackBG)
                make("UICorner",{CornerRadius=UDim.new(1,0)}, thumb)

                local draggingSlider = false
                local function updateSlider(x)
                    local rel = math.clamp((x - trackBG.AbsolutePosition.X)/trackBG.AbsoluteSize.X,0,1)
                    local raw = min + (max-min)*rel
                    local snapped = math.floor(raw/step+0.5)*step
                    value = math.clamp(snapped, min, max)
                    NyxUI.Flags[flag] = value
                    local r2 = (value-min)/(max-min)
                    fill.Size      = UDim2.new(r2,0,1,0)
                    thumb.Position = UDim2.new(r2,-7,0.5,-7)
                    valLbl.Text    = tostring(value)..suffix
                    if callback then pcall(callback, value) end
                end
                trackBG.InputBegan:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                        draggingSlider=true; updateSlider(inp.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if draggingSlider and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                        updateSlider(inp.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                        draggingSlider=false
                    end
                end)

                local ctrl = {}
                function ctrl:Set(v)
                    value=math.clamp(v,min,max); NyxUI.Flags[flag]=value
                    local r2=(value-min)/(max-min)
                    fill.Size=UDim2.new(r2,0,1,0); thumb.Position=UDim2.new(r2,-7,0.5,-7)
                    valLbl.Text=tostring(value)..suffix
                end
                function ctrl:Get() return value end
                NyxUI._flagCallbacks[flag] = function(v) ctrl:Set(v) end
                return ctrl
            end

            -- ================================================
            -- BUTTON
            -- ================================================
            function itemObj:Button(opts)
                opts = type(opts)=="table" and opts or {label=opts}
                local label    = opts.label    or "Button"
                local callback = opts.callback

                local btn = make("TextButton", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                    Text=label, TextColor3=T.Text,
                    Font=Enum.Font.GothamSemibold, TextSize=12,
                    AutoButtonColor=false,
                }, tabContent)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, btn)
                make("UIStroke",{Color=T.Border2,Thickness=1}, btn)

                btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=Color3.fromRGB(15,15,28),TextColor3=T.AccentLight},0.15) end)
                btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=T.BG3,TextColor3=T.Text},0.15) end)
                btn.MouseButton1Down:Connect(function() tween(btn,{BackgroundColor3=Color3.fromRGB(20,16,40)},0.07) end)
                btn.MouseButton1Up:Connect(function() tween(btn,{BackgroundColor3=Color3.fromRGB(15,15,28)},0.1) end)
                btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
            end

            -- ================================================
            -- DROPDOWN
            -- ================================================
            function itemObj:Dropdown(opts)
                opts = type(opts)=="table" and opts or {label=opts}
                local label    = opts.label    or "Dropdown"
                local flag     = opts.flag     or label
                local options  = opts.options  or {}
                local default  = opts.default  or options[1]
                local callback = opts.callback

                registerFlag(flag, default, callback)
                local selected = NyxUI.Flags[flag]
                local open     = false

                local container = make("Frame", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundTransparency=1, BorderSizePixel=0,
                    ClipsDescendants=false, ZIndex=5,
                }, tabContent)

                local row = make("TextButton", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                    Text="", AutoButtonColor=false, ZIndex=5,
                }, container)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, row)
                make("UIStroke",{Color=T.Border2,Thickness=1}, row)

                make("TextLabel", {
                    Size=UDim2.new(0.55,0,1,0), Position=UDim2.new(0,12,0,0),
                    BackgroundTransparency=1, Text=label,
                    TextColor3=T.Text, Font=Enum.Font.GothamSemibold, TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=5,
                }, row)

                local valLbl = make("TextLabel", {
                    Size=UDim2.new(0.45,-28,1,0), Position=UDim2.new(0.55,0,0,0),
                    BackgroundTransparency=1, Text=tostring(selected),
                    TextColor3=T.TextDim, Font=Enum.Font.Code, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Right, ZIndex=5,
                }, row)

                local arrow = make("TextLabel", {
                    Size=UDim2.new(0,22,1,0), Position=UDim2.new(1,-26,0,0),
                    BackgroundTransparency=1, Text="▾",
                    TextColor3=T.TextDim, Font=Enum.Font.GothamBold, TextSize=12, ZIndex=5,
                }, row)

                local itemH  = 28
                local fullH  = #options*(itemH+2)+14

                local dropdown = make("Frame", {
                    Size=UDim2.new(1,0,0,0),
                    Position=UDim2.new(0,0,1,4),
                    BackgroundColor3=Color3.fromRGB(10,10,18),
                    BorderSizePixel=0, ClipsDescendants=true,
                    ZIndex=20, Visible=false,
                }, container)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, dropdown)
                make("UIStroke",{Color=T.Border,Thickness=1}, dropdown)
                make("UIListLayout",{Padding=UDim.new(0,2)}, dropdown)
                make("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6)}, dropdown)

                for _, opt in ipairs(options) do
                    local optBtn = make("TextButton", {
                        Size=UDim2.new(1,0,0,itemH),
                        BackgroundTransparency=1,
                        Text=tostring(opt), TextColor3=opt==selected and T.AccentLight or T.Text,
                        Font=Enum.Font.GothamSemibold, TextSize=12,
                        BorderSizePixel=0, AutoButtonColor=false, ZIndex=21,
                    }, dropdown)
                    make("UICorner",{CornerRadius=UDim.new(0,5)}, optBtn)
                    optBtn.MouseEnter:Connect(function() tween(optBtn,{BackgroundTransparency=0.82,TextColor3=T.AccentLight},0.1) end)
                    optBtn.MouseLeave:Connect(function() tween(optBtn,{BackgroundTransparency=1,TextColor3=opt==selected and T.AccentLight or T.Text},0.1) end)
                    optBtn.MouseButton1Click:Connect(function()
                        selected=opt; NyxUI.Flags[flag]=opt; valLbl.Text=tostring(opt)
                        if callback then pcall(callback, opt) end
                        open=false
                        tween(dropdown,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quart)
                        tween(arrow,{Rotation=0},0.18)
                        task.delay(0.2,function() dropdown.Visible=false end)
                        container.Size=UDim2.new(1,0,0,36)
                    end)
                end

                row.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        dropdown.Visible=true; dropdown.Size=UDim2.new(1,0,0,0)
                        tween(dropdown,{Size=UDim2.new(1,0,0,fullH)},0.22,Enum.EasingStyle.Back)
                        tween(arrow,{Rotation=180},0.18)
                        container.Size=UDim2.new(1,0,0,36+fullH+4)
                    else
                        tween(dropdown,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quart)
                        tween(arrow,{Rotation=0},0.18)
                        task.delay(0.2,function() dropdown.Visible=false end)
                        container.Size=UDim2.new(1,0,0,36)
                    end
                end)
                row.MouseEnter:Connect(function() tween(row,{BackgroundColor3=Color3.fromRGB(15,15,26)},0.12) end)
                row.MouseLeave:Connect(function() tween(row,{BackgroundColor3=T.BG3},0.12) end)

                local ctrl={}
                function ctrl:Get() return selected end
                function ctrl:Set(v) selected=v; NyxUI.Flags[flag]=v; valLbl.Text=tostring(v) end
                NyxUI._flagCallbacks[flag]=function(v) ctrl:Set(v) end
                return ctrl
            end

            -- ================================================
            -- COLOR PICKER
            -- ================================================
            function itemObj:ColorPicker(opts)
                opts = type(opts)=="table" and opts or {label=opts}
                local label    = opts.label    or "Color"
                local flag     = opts.flag     or label
                local default  = opts.default  or Color3.fromRGB(255,255,255)
                local callback = opts.callback

                registerFlag(flag, default, callback)
                local color = NyxUI.Flags[flag]
                local h0,s0,v0 = rgbToHsv(color.R, color.G, color.B)
                local hue,sat,val2 = h0,s0,v0
                local open = false

                local row = make("TextButton", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                    Text="", AutoButtonColor=false,
                }, tabContent)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, row)
                make("UIStroke",{Color=T.Border2,Thickness=1}, row)

                make("TextLabel", {
                    Size=UDim2.new(1,-56,1,0), Position=UDim2.new(0,12,0,0),
                    BackgroundTransparency=1, Text=label,
                    TextColor3=T.Text, Font=Enum.Font.GothamSemibold, TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, row)

                local swatch = make("Frame", {
                    Size=UDim2.new(0,24,0,24), Position=UDim2.new(1,-36,0.5,-12),
                    BackgroundColor3=color, BorderSizePixel=0,
                }, row)
                make("UICorner",{CornerRadius=UDim.new(0,5)}, swatch)
                make("UIStroke",{Color=T.Border,Thickness=1}, swatch)

                -- Picker panel
                local picker = make("Frame", {
                    Size=UDim2.new(1,0,0,0),
                    Position=UDim2.new(0,0,1,4),
                    BackgroundColor3=Color3.fromRGB(10,10,18),
                    BorderSizePixel=0, ClipsDescendants=true,
                    ZIndex=15, Visible=false,
                }, row)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, picker)
                make("UIStroke",{Color=T.Border,Thickness=1}, picker)

                local pickerH = 160

                -- SV Square
                local svBox = make("ImageLabel", {
                    Size=UDim2.new(1,-28,0,110),
                    Position=UDim2.new(0,10,0,10),
                    BackgroundColor3=Color3.fromHSV(hue,1,1),
                    BorderSizePixel=0, ZIndex=16,
                    Image="rbxassetid://4155801252", -- white->transparent gradient
                    ScaleType=Enum.ScaleType.Stretch,
                }, picker)
                make("UICorner",{CornerRadius=UDim.new(0,5)}, svBox)

                -- Siyah gradient üstüne
                local svDark = make("Frame", {
                    Size=UDim2.new(1,0,1,0),
                    BackgroundColor3=Color3.new(0,0,0),
                    BackgroundTransparency=0.0001,
                    BorderSizePixel=0, ZIndex=16,
                }, svBox)
                make("UICorner",{CornerRadius=UDim.new(0,5)}, svDark)
                make("UIGradient",{Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
                    ColorSequenceKeypoint.new(1, Color3.new(0,0,0)),
                }), Transparency=NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0),
                }), Rotation=90}, svDark)

                -- SV cursor
                local svCursor = make("Frame", {
                    Size=UDim2.new(0,10,0,10),
                    Position=UDim2.new(sat,-5,1-val2,-5),
                    BackgroundColor3=Color3.new(1,1,1),
                    BorderSizePixel=0, ZIndex=17,
                }, svBox)
                make("UICorner",{CornerRadius=UDim.new(1,0)}, svCursor)
                make("UIStroke",{Color=Color3.new(0,0,0),Thickness=1.5}, svCursor)

                -- Hue slider
                local hueBar = make("Frame", {
                    Size=UDim2.new(0,14,0,110),
                    Position=UDim2.new(1,-22,0,10),
                    BackgroundColor3=Color3.new(1,1,1),
                    BorderSizePixel=0, ZIndex=16,
                }, picker)
                make("UICorner",{CornerRadius=UDim.new(0,4)}, hueBar)

                -- Hue gradient
                local hueGrad = make("UIGradient", {
                    Color=ColorSequence.new({
                        ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,1,1)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)),
                        ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,1,1)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1,1)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)),
                        ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,1,1)),
                    }),
                    Rotation=90,
                }, hueBar)

                local hueCursor = make("Frame", {
                    Size=UDim2.new(1,4,0,4),
                    Position=UDim2.new(0,-2,hue,-2),
                    BackgroundColor3=Color3.new(1,1,1),
                    BorderSizePixel=0, ZIndex=17,
                }, hueBar)
                make("UICorner",{CornerRadius=UDim.new(0,2)}, hueCursor)
                make("UIStroke",{Color=Color3.new(0,0,0),Thickness=1.5}, hueCursor)

                -- Hex input
                local function colorToHex(c)
                    return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
                end
                local hexInput = make("TextBox", {
                    Size=UDim2.new(1,-20,0,24),
                    Position=UDim2.new(0,10,1,-32),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                    Text=colorToHex(color),
                    TextColor3=T.Text, Font=Enum.Font.Code, TextSize=11,
                    ClearTextOnFocus=false, ZIndex=16,
                }, picker)
                make("UICorner",{CornerRadius=UDim.new(0,5)}, hexInput)
                make("UIStroke",{Color=T.Border2,Thickness=1}, hexInput)
                make("UIPadding",{PaddingLeft=UDim.new(0,8)}, hexInput)

                local function updateColor()
                    local r,g,b = hsvToRgb(hue,sat,val2)
                    color = Color3.new(r,g,b)
                    NyxUI.Flags[flag] = color
                    swatch.BackgroundColor3 = color
                    svBox.BackgroundColor3  = Color3.fromHSV(hue,1,1)
                    hexInput.Text = colorToHex(color)
                    if callback then pcall(callback, color) end
                end

                -- SV drag
                local draggingSV = false
                svBox.InputBegan:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                        draggingSV=true
                        local rel = svBox.AbsoluteSize
                        sat  = math.clamp((inp.Position.X-svBox.AbsolutePosition.X)/rel.X,0,1)
                        val2 = 1-math.clamp((inp.Position.Y-svBox.AbsolutePosition.Y)/rel.Y,0,1)
                        svCursor.Position=UDim2.new(sat,-5,1-val2,-5)
                        updateColor()
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if draggingSV and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                        local rel = svBox.AbsoluteSize
                        sat  = math.clamp((inp.Position.X-svBox.AbsolutePosition.X)/rel.X,0,1)
                        val2 = 1-math.clamp((inp.Position.Y-svBox.AbsolutePosition.Y)/rel.Y,0,1)
                        svCursor.Position=UDim2.new(sat,-5,1-val2,-5)
                        updateColor()
                    end
                    if draggingHue and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                        hue=math.clamp((inp.Position.Y-hueBar.AbsolutePosition.Y)/hueBar.AbsoluteSize.Y,0,1)
                        hueCursor.Position=UDim2.new(0,-2,hue,-2)
                        updateColor()
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                        draggingSV=false; draggingHue=false
                    end
                end)

                local draggingHue = false
                hueBar.InputBegan:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                        draggingHue=true
                        hue=math.clamp((inp.Position.Y-hueBar.AbsolutePosition.Y)/hueBar.AbsoluteSize.Y,0,1)
                        hueCursor.Position=UDim2.new(0,-2,hue,-2)
                        updateColor()
                    end
                end)

                -- Hex input
                hexInput.FocusLost:Connect(function()
                    local hex = hexInput.Text:gsub("#","")
                    if #hex==6 then
                        local r2 = tonumber(hex:sub(1,2),16) or 0
                        local g2 = tonumber(hex:sub(3,4),16) or 0
                        local b2 = tonumber(hex:sub(5,6),16) or 0
                        color = Color3.fromRGB(r2,g2,b2)
                        hue,sat,val2 = rgbToHsv(color.R,color.G,color.B)
                        svCursor.Position=UDim2.new(sat,-5,1-val2,-5)
                        hueCursor.Position=UDim2.new(0,-2,hue,-2)
                        svBox.BackgroundColor3=Color3.fromHSV(hue,1,1)
                        swatch.BackgroundColor3=color
                        NyxUI.Flags[flag]=color
                        if callback then pcall(callback,color) end
                    end
                end)

                -- Aç/kapat
                row.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        picker.Visible=true; picker.Size=UDim2.new(1,0,0,0)
                        tween(picker,{Size=UDim2.new(1,0,0,pickerH)},0.22,Enum.EasingStyle.Back)
                    else
                        tween(picker,{Size=UDim2.new(1,0,0,0)},0.18,Enum.EasingStyle.Quart)
                        task.delay(0.2,function() picker.Visible=false end)
                    end
                end)
                row.MouseEnter:Connect(function() tween(row,{BackgroundColor3=Color3.fromRGB(15,15,26)},0.12) end)
                row.MouseLeave:Connect(function() tween(row,{BackgroundColor3=T.BG3},0.12) end)

                local ctrl={}
                function ctrl:Get() return color end
                function ctrl:Set(c)
                    color=c; NyxUI.Flags[flag]=c; swatch.BackgroundColor3=c
                    hue,sat,val2=rgbToHsv(c.R,c.G,c.B)
                    svBox.BackgroundColor3=Color3.fromHSV(hue,1,1)
                    svCursor.Position=UDim2.new(sat,-5,1-val2,-5)
                    hueCursor.Position=UDim2.new(0,-2,hue,-2)
                    hexInput.Text=colorToHex(c)
                end
                NyxUI._flagCallbacks[flag]=function(v) ctrl:Set(v) end
                return ctrl
            end

            -- ================================================
            -- KEYBIND
            -- ================================================
            function itemObj:Keybind(opts)
                opts = type(opts)=="table" and opts or {label=opts}
                local label    = opts.label    or "Keybind"
                local flag     = opts.flag     or label
                local default  = opts.default  or Enum.KeyCode.Unknown
                local callback = opts.callback

                registerFlag(flag, default, callback)
                local bound   = NyxUI.Flags[flag]
                local waiting = false

                local row = make("TextButton", {
                    Size=UDim2.new(1,0,0,36),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                    Text="", AutoButtonColor=false,
                }, tabContent)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, row)
                make("UIStroke",{Color=T.Border2,Thickness=1}, row)

                make("TextLabel",{
                    Size=UDim2.new(1,-100,1,0), Position=UDim2.new(0,12,0,0),
                    BackgroundTransparency=1, Text=label,
                    TextColor3=T.Text, Font=Enum.Font.GothamSemibold, TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, row)

                local keyBtn = make("TextButton", {
                    Size=UDim2.new(0,80,0,24), Position=UDim2.new(1,-88,0.5,-12),
                    BackgroundColor3=T.BG2, BorderSizePixel=0,
                    Text=tostring(bound.Name),
                    TextColor3=T.AccentLight, Font=Enum.Font.Code, TextSize=11,
                    AutoButtonColor=false,
                }, row)
                make("UICorner",{CornerRadius=UDim.new(0,5)}, keyBtn)
                make("UIStroke",{Color=T.Border,Thickness=1}, keyBtn)

                keyBtn.MouseButton1Click:Connect(function()
                    waiting=true
                    keyBtn.Text="..."
                    tween(keyBtn,{BackgroundColor3=T.Accent},0.1)
                end)

                UserInputService.InputBegan:Connect(function(inp, gp)
                    if not waiting or gp then return end
                    if inp.UserInputType==Enum.UserInputType.Keyboard then
                        waiting=false
                        bound=inp.KeyCode
                        NyxUI.Flags[flag]=bound
                        keyBtn.Text=tostring(bound.Name)
                        tween(keyBtn,{BackgroundColor3=T.BG2},0.15)
                        if callback then pcall(callback,bound) end
                    end
                end)

                local ctrl={}
                function ctrl:Get() return bound end
                function ctrl:Set(k) bound=k; NyxUI.Flags[flag]=k; keyBtn.Text=tostring(k.Name) end
                NyxUI._flagCallbacks[flag]=function(v) ctrl:Set(v) end
                return ctrl
            end

            -- ================================================
            -- TEXTBOX
            -- ================================================
            function itemObj:TextBox(opts)
                opts = type(opts)=="table" and opts or {label=opts}
                local label       = opts.label       or "Input"
                local flag        = opts.flag        or label
                local placeholder = opts.placeholder or ""
                local default     = opts.default     or ""
                local callback    = opts.callback

                registerFlag(flag, default, callback)

                local row = make("Frame", {
                    Size=UDim2.new(1,0,0,52),
                    BackgroundColor3=T.BG3, BorderSizePixel=0,
                }, tabContent)
                make("UICorner",{CornerRadius=UDim.new(0,7)}, row)
                make("UIStroke",{Color=T.Border2,Thickness=1}, row)

                make("TextLabel",{
                    Size=UDim2.new(1,-24,0,20), Position=UDim2.new(0,12,0,4),
                    BackgroundTransparency=1, Text=label,
                    TextColor3=T.TextDim, Font=Enum.Font.Code, TextSize=10,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, row)

                local input = make("TextBox",{
                    Size=UDim2.new(1,-24,0,24), Position=UDim2.new(0,12,0,24),
                    BackgroundTransparency=1,
                    Text=NyxUI.Flags[flag] or default,
                    PlaceholderText=placeholder, PlaceholderColor3=T.TextDim,
                    TextColor3=T.Text, Font=Enum.Font.Code, TextSize=12,
                    ClearTextOnFocus=false, BorderSizePixel=0,
                }, row)

                input.Focused:Connect(function()    tween(row,{BackgroundColor3=Color3.fromRGB(15,15,26)},0.15) end)
                input.FocusLost:Connect(function()
                    tween(row,{BackgroundColor3=T.BG3},0.15)
                    NyxUI.Flags[flag]=input.Text
                    if callback then pcall(callback,input.Text) end
                end)

                local ctrl={}
                function ctrl:Get() return input.Text end
                function ctrl:Set(v) input.Text=v; NyxUI.Flags[flag]=v end
                return ctrl
            end

            return itemObj
        end -- Section

        return sectionObj
    end -- Tab

    -- ============================================================
    -- SIDEBAR
    -- ============================================================
    function winObj:Sidebar()
        local sideObj = {}

        function sideObj:Label(title, sub)
            local item = make("Frame", {
                Size=UDim2.new(1,0,0,46),
                BackgroundColor3=T.BG3, BorderSizePixel=0,
            }, sidebar)
            make("UICorner",{CornerRadius=UDim.new(0,6)}, item)
            make("UIStroke",{Color=T.Border2,Thickness=1}, item)
            make("TextLabel",{
                Size=UDim2.new(1,-12,0,22), Position=UDim2.new(0,10,0,4),
                BackgroundTransparency=1, Text=title,
                TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, item)
            local subLbl = make("TextLabel",{
                Size=UDim2.new(1,-12,0,16), Position=UDim2.new(0,10,0,26),
                BackgroundTransparency=1, Text=sub or "",
                TextColor3=T.TextDim, Font=Enum.Font.Code, TextSize=9,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, item)
            local ctrl={}
            function ctrl:SetSub(v) subLbl.Text=v end
            return ctrl
        end

        function sideObj:Avatar()
            local userId   = LP.UserId
            local thumbUrl = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", userId)

            local card = make("Frame", {
                Size=UDim2.new(1,0,0,94),
                BackgroundColor3=T.BG3, BorderSizePixel=0, LayoutOrder=999,
            }, sidebar)
            make("UICorner",{CornerRadius=UDim.new(0,8)}, card)
            make("UIStroke",{Color=T.Border2,Thickness=1}, card)

            local imgFrame = make("Frame", {
                Size=UDim2.new(0,56,0,56), Position=UDim2.new(0.5,-28,0,8),
                BackgroundColor3=T.BG2, BorderSizePixel=0,
            }, card)
            make("UICorner",{CornerRadius=UDim.new(0,8)}, imgFrame)
            make("UIStroke",{Color=T.Accent,Thickness=1.5,Transparency=0.5}, imgFrame)

            local img = make("ImageLabel",{
                Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1,
                Image=thumbUrl,
                ScaleType=Enum.ScaleType.Crop,
            }, imgFrame)
            make("UICorner",{CornerRadius=UDim.new(0,7)}, img)

            make("TextLabel",{
                Size=UDim2.new(1,-8,0,18), Position=UDim2.new(0,4,1,-22),
                BackgroundTransparency=1, Text=LP.Name,
                TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=10,
                TextXAlignment=Enum.TextXAlignment.Center,
            }, card)
        end

        function sideObj:Button(label, callback)
            local btn = make("TextButton", {
                Size=UDim2.new(1,0,0,32),
                BackgroundColor3=T.BG3, BorderSizePixel=0,
                Text=label, TextColor3=T.Text,
                Font=Enum.Font.GothamSemibold, TextSize=11,
                AutoButtonColor=false,
            }, sidebar)
            make("UICorner",{CornerRadius=UDim.new(0,6)}, btn)
            make("UIStroke",{Color=T.Border2,Thickness=1}, btn)
            btn.MouseEnter:Connect(function() tween(btn,{TextColor3=T.AccentLight,BackgroundColor3=Color3.fromRGB(16,14,28)},0.15) end)
            btn.MouseLeave:Connect(function() tween(btn,{TextColor3=T.Text,BackgroundColor3=T.BG3},0.15) end)
            btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
        end

        return sideObj
    end

    -- ============================================================
    -- SETTINGS TAB (otomatik eklenir)
    -- ============================================================
    local settingsTab = winObj:Tab("⚙ Settings")
    local settingsSec = settingsTab:Section("Genel")

    -- Toggle tuşu
    local currentToggleKey = toggleKey
    settingsSec:Keybind({
        label    = "GUI Aç/Kapat Tuşu",
        flag     = "_nyxToggleKey",
        default  = currentToggleKey,
        callback = function(k) currentToggleKey = k end,
    })

    -- Tema seçici
    settingsSec:Dropdown({
        label    = "Tema",
        flag     = "_nyxTheme",
        options  = ThemeNames,
        default  = themeName,
        callback = function(name)
            if Themes[name] then
                ActiveTheme = Themes[name]
                -- Tema değişimini bildir (tam rebuild olmadan renk güncelleme zor,
                -- bu yüzden notify + rejoin öneri)
                winObj:Notify("Tema", name.." uygulandı. Scripti yeniden çalıştır.", 4, "info")
            end
        end,
    })

    -- Rejoin
    local rejoinSec = settingsTab:Section("Oyun")
    rejoinSec:Button({
        label    = "Rejoin",
        callback = function()
            local placeId  = game.PlaceId
            local serverId = game.JobId
            TeleportService:TeleportToPlaceInstance(placeId, serverId, LP)
        end,
    })

    -- Config bölümü
    local configSec = settingsTab:Section("Config")

    local function buildConfigUI()
        -- Slot listesi dropdown
        local slots    = listConfigs()
        local allSlots = {}
        for i=1,MAX_SLOTS do
            local name = "Slot "..i
            -- Mevcut kayıtlı slotları da ekle
            allSlots[i] = name
        end
        for _, s in ipairs(slots) do
            local found = false
            for _, a in ipairs(allSlots) do if a==s then found=true break end end
            if not found then table.insert(allSlots, s) end
        end

        local selectedSlot = allSlots[1]
        local slotDD = configSec:Dropdown({
            label   = "Slot Seç",
            flag    = "_nyxConfigSlot",
            options = allSlots,
            default = allSlots[1],
            callback= function(v) selectedSlot=v end,
        })

        configSec:Button({label="💾 Kaydet", callback=function()
            local ok2, err = saveConfig(selectedSlot)
            winObj:Notify("Config", ok2 and (selectedSlot.." kaydedildi.") or ("Hata: "..(err or "")), 3, ok2 and "success" or "error")
        end})

        configSec:Button({label="📂 Yükle", callback=function()
            local ok2, err = loadConfig(selectedSlot)
            winObj:Notify("Config", ok2 and (selectedSlot.." yüklendi.") or ("Hata: "..(err or "")), 3, ok2 and "success" or "error")
        end})

        configSec:Button({label="🗑 Sil", callback=function()
            local ok2 = deleteConfig(selectedSlot)
            winObj:Notify("Config", ok2 and (selectedSlot.." silindi.") or "Silinemedi.", 3, ok2 and "info" or "error")
        end})
    end
    buildConfigUI()

    -- Executor bilgisi
    local infoSec = settingsTab:Section("Sistem")
    infoSec:Button({label="Executor: "..Executor, callback=function() end})
    infoSec:Button({label="NyxUI v"..NyxUI.Version, callback=function() end})

    -- ============================================================
    -- TOGGLE TUŞU
    -- ============================================================
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == currentToggleKey then
                visible = not visible
                if visible then
                    win.Visible = true
                    tween(win, {BackgroundTransparency=0}, 0.2)
                else
                    tween(win, {BackgroundTransparency=1}, 0.18)
                    task.delay(0.2, function() win.Visible=false end)
                end
            end
        end
    end)

    -- ============================================================
    -- BİLDİRİM
    -- ============================================================
    function winObj:Notify(title, message, duration, notifType)
        duration  = duration  or 3
        notifType = notifType or "info"
        local T2  = ActiveTheme

        local accentColor = ({
            info    = T2.AccentLight,
            success = T2.Success,
            warning = T2.Warning,
            error   = T2.Error,
        })[notifType] or T2.AccentLight

        local notif = make("Frame", {
            Size=UDim2.new(1,0,0,70),
            BackgroundColor3=Color3.fromRGB(10,10,18),
            BorderSizePixel=0,
            BackgroundTransparency=1,
            ZIndex=200,
        }, notifHolder)
        make("UICorner",{CornerRadius=UDim.new(0,8)}, notif)
        make("UIStroke",{Color=T2.Border,Thickness=1}, notif)

        -- Sol bar
        local bar = make("Frame",{
            Size=UDim2.new(0,3,1,-14),
            Position=UDim2.new(0,7,0.5,0), AnchorPoint=Vector2.new(0,0.5),
            BackgroundColor3=accentColor, BorderSizePixel=0,
        }, notif)
        make("UICorner",{CornerRadius=UDim.new(1,0)}, bar)

        make("TextLabel",{
            Size=UDim2.new(1,-44,0,22), Position=UDim2.new(0,18,0,8),
            BackgroundTransparency=1, Text=title,
            TextColor3=T2.TextBright, Font=Enum.Font.GothamBold, TextSize=13,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=201,
        }, notif)

        make("TextLabel",{
            Size=UDim2.new(1,-28,0,26), Position=UDim2.new(0,18,0,30),
            BackgroundTransparency=1, Text=message,
            TextColor3=T2.Text, Font=Enum.Font.Gotham, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextWrapped=true, ZIndex=201,
        }, notif)

        -- Progres bar
        local progBG = make("Frame",{
            Size=UDim2.new(1,-14,0,2), Position=UDim2.new(0,7,1,-4),
            BackgroundColor3=T2.Border, BorderSizePixel=0, ZIndex=201,
        }, notif)
        make("UICorner",{CornerRadius=UDim.new(1,0)}, progBG)

        local prog = make("Frame",{
            Size=UDim2.new(1,0,1,0),
            BackgroundColor3=accentColor, BorderSizePixel=0, ZIndex=202,
        }, progBG)
        make("UICorner",{CornerRadius=UDim.new(1,0)}, prog)

        -- Kapat butonu
        local xBtn = make("TextButton",{
            Size=UDim2.new(0,20,0,20), Position=UDim2.new(1,-24,0,6),
            BackgroundTransparency=1, Text="✕",
            TextColor3=T2.TextDim, Font=Enum.Font.GothamBold, TextSize=12,
            AutoButtonColor=false, ZIndex=202,
        }, notif)
        xBtn.MouseButton1Click:Connect(function()
            tween(notif,{BackgroundTransparency=1,Position=UDim2.new(1,10,0,0)},0.2,Enum.EasingStyle.Quart)
            task.delay(0.25,function() notif:Destroy() end)
        end)

        -- Giriş
        notif.Position = UDim2.new(1,10,0,0)
        tween(notif,{BackgroundTransparency=0, Position=UDim2.new(0,0,0,0)},0.3,Enum.EasingStyle.Back)
        tween(prog,{Size=UDim2.new(0,0,1,0)},duration,Enum.EasingStyle.Linear)

        task.delay(duration,function()
            tween(notif,{BackgroundTransparency=1,Position=UDim2.new(1,10,0,0)},0.22,Enum.EasingStyle.Quart)
            task.delay(0.25,function() notif:Destroy() end)
        end)
    end

    return winObj
end

-- ============================================================
-- Export
-- ============================================================
return NyxUI