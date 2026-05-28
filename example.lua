local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SairyTheKing/SairyLibrary/refs/heads/main/main.lua"))()

local win = library:window({
    Name = "Sairy Library",
    Icon = "lucide:gem",
    Loading = true
})

local elements = win:Tab({ Name = "Elements", Icon = "lucide:layers" })

local inputs = elements:Section({ Name = "Input Elements", side = "left" })

inputs:Label({ Name = "Basic interactive components for user input and control." })

inputs:Button({
    Name = "Standard Button",
    Callback = function()
        library:create_notification({ Name = "Button clicked!", duration = 2 })
    end
})

local myToggle = inputs:Toggle({
    Name = "Feature Toggle",
    default = false,
    Callback = function(state)
        library:create_notification({ Name = "Toggle: " .. tostring(state), duration = 2 })
    end
})

inputs:Slider({
    Name = "Volume",
    min = 0,
    max = 100,
    default = 65,
    decimals = 0,
    Callback = function(val)
    end
})

inputs:Slider({
    Name = "Sensitivity",
    min = 0.1,
    max = 5.0,
    default = 1.0,
    decimals = 2,
    Callback = function(val)
    end
})

inputs:Textbox({
    Name = "Username",
    Placeholder = "Enter username...",
    Callback = function(text)
        library:create_notification({ Name = "Text: " .. text, duration = 3 })
    end
})

local selects = elements:Section({ Name = "Selection Elements", side = "right" })

selects:Label({ Name = "Dropdowns, keybinds, and color selection components." })

local dropdown = selects:Dropdown({
    Name = "Fruit",
    items = {"Apple", "Banana", "Cherry", "Dragonfruit", "Elderberry"},
    default = "Apple",
    Callback = function(val)
        library:create_notification({ Name = "Selected: " .. tostring(val), duration = 2 })
    end
})

local multiDropdown = selects:Dropdown({
    Name = "Skills",
    items = {"Speed", "Power", "Agility", "Defense", "Magic"},
    multi = true,
    default = {"Speed", "Power"},
    Callback = function(val)
    end
})

selects:Colorpicker({
    Name = "Primary Color",
    default = Color3.fromRGB(100, 150, 255),
    Callback = function(color)
    end
})

selects:Colorpicker({
    Name = "Secondary Color",
    default = Color3.fromRGB(255, 100, 150),
    Callback = function(color)
    end
})

selects:Keybind({
    Name = "Aimbot Key",
    default = Enum.KeyCode.E,
    Callback = function(key)
        library:create_notification({ Name = "Key set: " .. key.Name, duration = 2 })
    end
})

local subElements = win:Tab({ Name = "Sub-Elements", Icon = "lucide:component" })

local statusSection = subElements:Section({ Name = "Status Display", side = "left" })

statusSection:Label({ Name = "Live status information with updateable lines." })

local status = statusSection:Status({ Name = "Player Status" })
local healthLine = status:AddStatus("Health: 100%")
local armorLine = status:AddStatus("Armor: 50%")
local speedLine = status:AddStatus("Speed: 32 studs/s")

statusSection:Button({
    Name = "Update Random Status",
    Callback = function()
        healthLine:set("Health: " .. math.random(1, 100) .. "%")
        armorLine:set("Armor: " .. math.random(1, 100) .. "%")
        speedLine:set("Speed: " .. math.random(10, 50) .. " studs/s")
    end
})

local listSection = subElements:Section({ Name = "Reorderable List", side = "right" })

listSection:Label({ Name = "Drag items using arrows to reorder." })

local myList = listSection:List({
    Name = "Priority Queue",
    items = {"Task Alpha", "Task Beta", "Task Gamma", "Task Delta", "Task Epsilon"},
    Callback = function(order)
    end
})

local toggleExtras = subElements:Section({ Name = "Toggle Extensions", side = "left" })

local extendedToggle = toggleExtras:Toggle({
    Name = "Advanced Mode",
    default = true,
    Callback = function(state)
    end
})

extendedToggle:Slider({
    Name = "Intensity",
    min = 1,
    max = 10,
    default = 5,
    decimals = 0,
    Callback = function(val)
    end
})

extendedToggle:Dropdown({
    Name = "Mode",
    items = {"Easy", "Normal", "Hard", "Expert"},
    default = "Normal",
    Callback = function(val)
    end
})

extendedToggle:Colorpicker({
    Name = "Glow Color",
    default = Color3.fromRGB(0, 255, 100),
    Callback = function(color)
    end
})

extendedToggle:Keybind({
    Name = "Quick Toggle",
    default = Enum.KeyCode.F,
    Callback = function(key)
    end
})

local collapsedToggle = toggleExtras:Toggle({
    Name = "Simple Mode",
    default = false,
    Callback = function(state)
    end
})

collapsedToggle:Slider({
    Name = "Threshold",
    min = 0,
    max = 50,
    default = 10,
    decimals = 1,
    Callback = function(val)
    end
})

local premiumDemo = win:Tab({ Name = "Premium Demo", Icon = "lucide:crown" })

local premiumSection = premiumDemo:Section({ Name = "Premium Features", side = "left" })

premiumSection:Label({ Name = "Elements with premium overlay lock indicator." })

premiumSection:Button({
    Name = "Premium Button",
    Premium = true,
    Callback = function()
    end
})

premiumSection:Toggle({
    Name = "Premium Toggle",
    Premium = true,
    default = false,
    Callback = function(state)
    end
})

premiumSection:Slider({
    Name = "Premium Slider",
    min = 0,
    max = 100,
    default = 50,
    Premium = true,
    Callback = function(val)
    end
})

premiumSection:Dropdown({
    Name = "Premium Dropdown",
    items = {"Alpha", "Beta", "Gamma"},
    Premium = true,
    Callback = function(val)
    end
})

local notificationsTab = win:Tab({ Name = "Notifications", Icon = "lucide:bell" })

local notifSection = notificationsTab:Section({ Name = "Notification Tester", side = "left" })

notifSection:Label({ Name = "Send test notifications with various durations." })

notifSection:Button({
    Name = "Short Notification (1s)",
    Callback = function()
        library:create_notification({ Name = "Quick update!", duration = 1 })
    end
})

notifSection:Button({
    Name = "Standard Notification (3s)",
    Callback = function()
        library:create_notification({ Name = "Standard notification message.", duration = 3 })
    end
})

notifSection:Button({
    Name = "Long Notification (6s)",
    Callback = function()
        library:create_notification({ Name = "This notification stays for 6 seconds.", duration = 6 })
    end
})

notifSection:Button({
    Name = "Notification Spam (5x)",
    Callback = function()
        for i = 1, 5 do
            task.delay(i * 0.1, function()
                library:create_notification({ Name = "Notification #" .. i, duration = 3 })
            end)
        end
    end
})

local dynamicTab = win:Tab({ Name = "Dynamic", Icon = "lucide:refresh-cw" })

local dynamicSection = dynamicTab:Section({ Name = "Dynamic Controls", side = "left" })

dynamicSection:Label({ Name = "Programmatically update dropdowns and toggle state." })

dynamicSection:Button({
    Name = "Update Fruit Dropdown",
    Callback = function()
        local newFruits = {}
        for i = 1, math.random(3, 6) do
            table.insert(newFruits, "Fruit_" .. math.random(100, 999))
        end
        dropdown:set_items(newFruits)
        library:create_notification({ Name = "Dropdown updated!", duration = 2 })
    end
})

dynamicSection:Button({
    Name = "Select Random Fruit",
    Callback = function()
        local fruits = {"Apple", "Banana", "Cherry", "Dragonfruit", "Elderberry"}
        dropdown:set_value(fruits[math.random(1, #fruits)])
    end
})

dynamicSection:Button({
    Name = "Toggle Feature On",
    Callback = function()
        myToggle:set(true)
    end
})

dynamicSection:Button({
    Name = "Toggle Feature Off",
    Callback = function()
        myToggle:set(false)
    end
})

local refreshSection = dynamicTab:Section({ Name = "Mobile Buttons", side = "right" })

refreshSection:Label({ Name = "Refresh the mobile floating button list." })

refreshSection:Button({
    Name = "Refresh Mobile Buttons",
    Callback = function()
        win:RefreshMobileList()
        library:create_notification({ Name = "Mobile button list refreshed!", duration = 2 })
    end
})

library:create_notification({ Name = "Showcase loaded successfully!", duration = 4 })

task.delay(2, function()
    library:create_notification({ Name = "Explore all tabs to see every element.", duration = 5 })
end)

task.delay(4, function()
    library:create_notification({ Name = "Try the UI Settings tab to customize colors.", duration = 5 })
end)
