local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SairyTheKing/SairyLibrary/main/main.lua"))()

local Window = Library:window({
    name = "Sairy Hub",
    Loading = true,
    icon = "lucide:layout-dashboard"
})

local Main = Window:Tab({
    name = "Main",
    icon = "lucide:sword",
    GlowColor = Color3.fromRGB(0,170,255)
})

local Player = Window:Tab({
    name = "Player",
    icon = "lucide:user",
    GlowColor = Color3.fromRGB(0,255,170)
})

local Misc = Window:Tab({
    name = "Misc",
    icon = "lucide:settings",
    GlowColor = Color3.fromRGB(255,170,0)
})

-- MAIN SECTION

local Combat = Main:Section({
    name = "Combat",
    side = "left"
})

Combat:Button({
    name = "Kill All",
    Callback = function()
        Library:create_notification({
            name = "Killed everyone",
            duration = 3
        })
    end
})

Combat:Button({
    name = "Give Sword",
    Callback = function()
        print("Sword given")
    end
})

local Aura = Combat:Toggle({
    name = "Kill Aura",
    default = false,
    Callback = function(state)
        print("Kill Aura:", state)
    end
})

Aura:Slider({
    name = "Aura Range",
    min = 1,
    max = 100,
    default = 25,
    decimals = 0,
    Callback = function(value)
        print(value)
    end
})

Aura:Dropdown({
    name = "Target",
    items = {
        "Nearest",
        "Random",
        "Lowest HP"
    },
    default = "Nearest",
    Callback = function(option)
        print(option)
    end
})

-- PLAYER SECTION

local Movement = Player:Section({
    name = "Movement",
    side = "left"
})

Movement:Slider({
    name = "WalkSpeed",
    min = 16,
    max = 200,
    default = 16,
    decimals = 0,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character

        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

Movement:Slider({
    name = "JumpPower",
    min = 50,
    max = 250,
    default = 50,
    decimals = 0,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character

        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end
})

Movement:Toggle({
    name = "Infinite Jump",
    default = false,
    Callback = function(state)
        print(state)
    end
})

Movement:Textbox({
    name = "Teleport Player",
    placeholder = "Player name...",
    Callback = function(text)
        print("Teleport to:", text)
    end
})

-- MISC SECTION

local UI = Misc:Section({
    name = "UI",
    side = "left"
})

UI:Button({
    name = "Send Notification",
    Callback = function()
        Library:create_notification({
            name = "Hello from SairyLibrary",
            duration = 5
        })
    end
})

UI:Colorpicker({
    name = "UI Accent",
    default = Color3.fromRGB(0,170,255),
    Callback = function(color)
        print(color)
    end
})

UI:Keybind({
    name = "Panic Key",
    default = Enum.KeyCode.P,
    Callback = function(key)
        print(key)
    end
})

UI:Dropdown({
    name = "Theme",
    items = {
        "Dark",
        "Light",
        "Purple"
    },
    default = "Dark",
    Callback = function(option)
        print(option)
    end
})

UI:Button({
    name = "Unload",
    Callback = function()
        Library:Unload()
    end
})

Window:RefreshMobileList()

Library:create_notification({
    name = "Sairy Hub Loaded",
    duration = 5
})
