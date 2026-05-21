local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Library = {
    Icons = {},
    Themes = {
        ["Dark"]     = {Main = Color3.fromRGB(18, 18, 18), Accent = Color3.fromRGB(100, 200, 255), Outline = Color3.fromRGB(45, 45, 50), Text = Color3.fromRGB(235, 235, 235), Secondary = Color3.fromRGB(30, 30, 35), Success = Color3.fromRGB(80, 200, 120), Danger = Color3.fromRGB(230, 80, 80)},
        ["Light"]    = {Main = Color3.fromRGB(245, 245, 245), Accent = Color3.fromRGB(60, 140, 255), Outline = Color3.fromRGB(190, 190, 200), Text = Color3.fromRGB(30, 30, 35), Secondary = Color3.fromRGB(225, 225, 230), Success = Color3.fromRGB(60, 180, 110), Danger = Color3.fromRGB(210, 70, 70)},
        ["Nebula"]   = {Main = Color3.fromRGB(18, 12, 32), Accent = Color3.fromRGB(180, 80, 255), Outline = Color3.fromRGB(70, 45, 110), Text = Color3.fromRGB(245, 240, 255), Secondary = Color3.fromRGB(35, 25, 55), Success = Color3.fromRGB(100, 220, 140), Danger = Color3.fromRGB(255, 90, 110)},
        ["Obsidian"] = {Main = Color3.fromRGB(12, 12, 14), Accent = Color3.fromRGB(140, 140, 160), Outline = Color3.fromRGB(35, 35, 40), Text = Color3.fromRGB(210, 210, 220), Secondary = Color3.fromRGB(22, 22, 26), Success = Color3.fromRGB(90, 190, 130), Danger = Color3.fromRGB(220, 85, 85)},
        ["Aurora"]   = {Main = Color3.fromRGB(10, 28, 22), Accent = Color3.fromRGB(0, 255, 170), Outline = Color3.fromRGB(35, 75, 60), Text = Color3.fromRGB(235, 255, 245), Secondary = Color3.fromRGB(18, 45, 38), Success = Color3.fromRGB(80, 230, 150), Danger = Color3.fromRGB(255, 110, 100)},
        ["Eclipse"]  = {Main = Color3.fromRGB(16, 16, 22), Accent = Color3.fromRGB(255, 130, 60), Outline = Color3.fromRGB(50, 45, 55), Text = Color3.fromRGB(255, 235, 225), Secondary = Color3.fromRGB(28, 26, 36), Success = Color3.fromRGB(110, 210, 130), Danger = Color3.fromRGB(240, 95, 95)},
        ["Carbon"]   = {Main = Color3.fromRGB(22, 22, 24), Accent = Color3.fromRGB(255, 70, 70), Outline = Color3.fromRGB(55, 55, 60), Text = Color3.fromRGB(225, 225, 230), Secondary = Color3.fromRGB(32, 32, 36), Success = Color3.fromRGB(85, 195, 125), Danger = Color3.fromRGB(235, 75, 75)},
        ["Ember"]    = {Main = Color3.fromRGB(28, 16, 12), Accent = Color3.fromRGB(255, 145, 50), Outline = Color3.fromRGB(75, 45, 30), Text = Color3.fromRGB(255, 245, 235), Secondary = Color3.fromRGB(42, 28, 22), Success = Color3.fromRGB(100, 200, 110), Danger = Color3.fromRGB(255, 100, 90)},
        ["Glacier"]  = {Main = Color3.fromRGB(14, 22, 34), Accent = Color3.fromRGB(80, 210, 255), Outline = Color3.fromRGB(45, 70, 95), Text = Color3.fromRGB(235, 250, 255), Secondary = Color3.fromRGB(24, 35, 50), Success = Color3.fromRGB(90, 205, 145), Danger = Color3.fromRGB(225, 95, 105)},
        ["Volt"]     = {Main = Color3.fromRGB(18, 18, 12), Accent = Color3.fromRGB(230, 255, 80), Outline = Color3.fromRGB(60, 60, 35), Text = Color3.fromRGB(245, 255, 225), Secondary = Color3.fromRGB(30, 30, 22), Success = Color3.fromRGB(110, 220, 130), Danger = Color3.fromRGB(255, 110, 100)},
        ["Nova"]     = {Main = Color3.fromRGB(24, 12, 32), Accent = Color3.fromRGB(255, 70, 220), Outline = Color3.fromRGB(75, 35, 95), Text = Color3.fromRGB(255, 235, 250), Secondary = Color3.fromRGB(38, 22, 48), Success = Color3.fromRGB(95, 215, 135), Danger = Color3.fromRGB(245, 85, 115)},
        ["Aether"]   = {Main = Color3.fromRGB(12, 14, 32), Accent = Color3.fromRGB(100, 240, 255), Outline = Color3.fromRGB(40, 45, 85), Text = Color3.fromRGB(225, 245, 255), Secondary = Color3.fromRGB(22, 24, 48), Success = Color3.fromRGB(90, 225, 160), Danger = Color3.fromRGB(235, 100, 110)}
    },
    CurrentTheme = nil,
    Windows = {},
    Notifications = {}
}

Library.CurrentTheme = Library.Themes["Dark"]

local iconSuccess, iconData = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub/main/everylucideassetin.lua"))()
end)
if iconSuccess and type(iconData) == "table" then Library.Icons = iconData end

function Library:SetTheme(name)
    if Library.Themes[name] then
        Library.CurrentTheme = Library.Themes[name]
    end
end

local function CreateNotification(title, text, duration, iconName)
    local theme = Library.CurrentTheme
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Voidseen_Notif"
    NotifGui.ResetOnSpawn = false
    NotifGui.Parent = gethui and gethui() or game:GetService("CoreGui")

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 280, 0, 80)
    NotifFrame.Position = UDim2.new(1, -300, 1, -100)
    NotifFrame.BackgroundColor3 = theme.Main
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifGui
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    local nStroke = Instance.new("UIStroke", NotifFrame)
    nStroke.Color = theme.Outline
    nStroke.Thickness = 1.2

    local nTitle = Instance.new("TextLabel", NotifFrame)
    nTitle.Size = UDim2.new(1, -70, 0, 26)
    nTitle.Position = UDim2.new(0, 12, 0, 8)
    nTitle.BackgroundTransparency = 1
    nTitle.Text = title
    nTitle.TextColor3 = theme.Text
    nTitle.Font = Enum.Font.GothamBold
    nTitle.TextSize = 13
    nTitle.TextXAlignment = Enum.TextXAlignment.Left

    local nText = Instance.new("TextLabel", NotifFrame)
    nText.Size = UDim2.new(1, -70, 0, 32)
    nText.Position = UDim2.new(0, 12, 0, 32)
    nText.BackgroundTransparency = 1
    nText.Text = text
    nText.TextColor3 = theme.Text
    nText.TextTransparency = 0.1
    nText.Font = Enum.Font.Gotham
    nText.TextSize = 12
    nText.TextXAlignment = Enum.TextXAlignment.Left
    nText.TextWrapped = true

    if iconName and Library.Icons[iconName] then
        local nIcon = Instance.new("ImageLabel", NotifFrame)
        nIcon.Size = UDim2.new(0, 20, 0, 20)
        nIcon.Position = UDim2.new(0, 12, 0, 8)
        nIcon.BackgroundTransparency = 1
        nIcon.Image = Library.Icons[iconName]
        nIcon.ImageColor3 = theme.Accent
        nTitle.Position = UDim2.new(0, 40, 0, 8)
    end

    local closeNotif = Instance.new("TextButton", NotifFrame)
    closeNotif.Size = UDim2.new(0, 24, 0, 24)
    closeNotif.Position = UDim2.new(1, -32, 0, 8)
    closeNotif.BackgroundTransparency = 1
    closeNotif.Text = "×"
    closeNotif.TextColor3 = theme.Text
    closeNotif.TextSize = 18
    closeNotif.Font = Enum.Font.Gotham

    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -300, 1, -100 - (#Library.Notifications * 90)}):Play()

    table.insert(Library.Notifications, NotifGui)

    closeNotif.Activated:Connect(function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset)}):Play()
        task.wait(0.4)
        NotifGui:Destroy()
        table.remove(Library.Notifications, table.find(Library.Notifications, NotifGui))
    end)

    task.delay(duration or 5, function()
        if NotifGui.Parent then
            TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset)}):Play()
            task.wait(0.4)
            NotifGui:Destroy()
            table.remove(Library.Notifications, table.find(Library.Notifications, NotifGui))
        end
    end)
end

function Library:Notify(title, text, duration, iconName)
    CreateNotification(title, text, duration, iconName)
end

function Library:CreateWindow(title, iconName)
    local theme = Library.CurrentTheme
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Voidseen"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 560, 0, 380)
    Main.Position = UDim2.new(0.5, -280, 0.5, -190)
    Main.BackgroundColor3 = theme.Main
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = theme.Outline
    Stroke.Thickness = 1.5

    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 42)
    TitleBar.BackgroundColor3 = theme.Secondary
    TitleBar.BorderSizePixel = 0
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

    local Header = Instance.new("TextLabel", TitleBar)
    Header.Size = UDim2.new(1, -90, 1, 0)
    Header.BackgroundTransparency = 1
    Header.Text = (iconName and "        " or "   ") .. title
    Header.TextColor3 = theme.Text
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 14

    if iconName and Library.Icons[iconName] then
        local TitleIcon = Instance.new("ImageLabel", TitleBar)
        TitleIcon.Size = UDim2.new(0, 20, 0, 20)
        TitleIcon.Position = UDim2.new(0, 12, 0.5, -10)
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.Image = Library.Icons[iconName]
        TitleIcon.ImageColor3 = theme.Accent
    end

    local CloseBtn = Instance.new("TextButton", TitleBar)
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -16)
    CloseBtn.BackgroundColor3 = theme.Danger
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    CloseBtn.Activated:Connect(function() ScreenGui:Destroy() end)

    local MinimizeBtn = Instance.new("TextButton", TitleBar)
    MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
    MinimizeBtn.Position = UDim2.new(1, -76, 0.5, -16)
    MinimizeBtn.BackgroundColor3 = theme.Secondary
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = theme.Text
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(0, 140, 1, -42)
    TabHolder.Position = UDim2.new(0, 0, 0, 42)
    TabHolder.BackgroundColor3 = theme.Secondary
    TabHolder.BorderSizePixel = 0
    Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 10)

    local TabList = Instance.new("ScrollingFrame", TabHolder)
    TabList.Size = UDim2.new(1, -8, 1, -12)
    TabList.Position = UDim2.new(0, 4, 0, 8)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = theme.Accent
    local TabLayout = Instance.new("UIListLayout", TabList)
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentHolder = Instance.new("Frame", Main)
    ContentHolder.Size = UDim2.new(1, -148, 1, -50)
    ContentHolder.Position = UDim2.new(0, 144, 0, 46)
    ContentHolder.BackgroundTransparency = 1

    local Pages = {}

    local window = {
        Tabs = {},
        CurrentTab = nil
    }

    function window:CreateTab(tabName, iconName)
        local TabBtn = Instance.new("TextButton", TabList)
        TabBtn.Size = UDim2.new(1, -8, 0, 36)
        TabBtn.BackgroundColor3 = theme.Secondary
        TabBtn.Text = (iconName and "     " or "") .. tabName
        TabBtn.TextColor3 = theme.Text
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        if iconName and Library.Icons[iconName] then
            local tIcon = Instance.new("ImageLabel", TabBtn)
            tIcon.Size = UDim2.new(0, 18, 0, 18)
            tIcon.Position = UDim2.new(0, 10, 0.5, -9)
            tIcon.BackgroundTransparency = 1
            tIcon.Image = Library.Icons[iconName]
            tIcon.ImageColor3 = theme.Accent
        end

        local Page = Instance.new("ScrollingFrame", ContentHolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = theme.Accent
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = false
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local tab = {Elements = {}, Page = Page}

        function tab:Show()
            for _, p in pairs(Pages) do p.Visible = false end
            Page.Visible = true
            window.CurrentTab = tab
        end

        TabBtn.Activated:Connect(tab.Show)

        table.insert(Pages, Page)
        table.insert(window.Tabs, tab)

        if #Pages == 1 then tab:Show() end

        local Elements = {}

        function Elements:Label(text)
            local Label = Instance.new("TextLabel", Page)
            Label.Size = UDim2.new(1, -12, 0, 22)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:Button(text, iconName, callback)
            local Button = Instance.new("TextButton", Page)
            Button.Size = UDim2.new(1, -12, 0, 38)
            Button.BackgroundColor3 = theme.Secondary
            Button.Text = (iconName and "       " or "") .. text
            Button.TextColor3 = theme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 13
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.AutoButtonColor = false
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

            if iconName and Library.Icons[iconName] then
                local Icon = Instance.new("ImageLabel", Button)
                Icon.Size = UDim2.new(0, 18, 0, 18)
                Icon.Position = UDim2.new(0, 12, 0.5, -9)
                Icon.BackgroundTransparency = 1
                Icon.Image = Library.Icons[iconName]
                Icon.ImageColor3 = theme.Accent
            end

            Button.Activated:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.12, Enum.EasingStyle.Quint), {BackgroundColor3 = theme.Accent, TextColor3 = theme.Main}):Play()
                task.wait(0.13)
                TweenService:Create(Button, TweenInfo.new(0.12, Enum.EasingStyle.Quint), {BackgroundColor3 = theme.Secondary, TextColor3 = theme.Text}):Play()
                if callback then callback() end
            end)
        end

        function Elements:Toggle(text, default, callback)
            local toggled = default or false
            local ToggleFrame = Instance.new("Frame", Page)
            ToggleFrame.Size = UDim2.new(1, -12, 0, 38)
            ToggleFrame.BackgroundColor3 = theme.Secondary
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

            local ToggleLabel = Instance.new("TextLabel", ToggleFrame)
            ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = theme.Text
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)

            local ToggleSwitch = Instance.new("Frame", ToggleFrame)
            ToggleSwitch.Size = UDim2.new(0, 42, 0, 22)
            ToggleSwitch.Position = UDim2.new(1, -54, 0.5, -11)
            ToggleSwitch.BackgroundColor3 = toggled and theme.Accent or theme.Outline
            Instance.new("UICorner", ToggleSwitch).CornerRadius = UDim.new(1, 0)

            local ToggleCircle = Instance.new("Frame", ToggleSwitch)
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

            local function UpdateToggle()
                TweenService:Create(ToggleSwitch, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = toggled and theme.Accent or theme.Outline}):Play()
                TweenService:Create(ToggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
                if callback then callback(toggled) end
            end

            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggled = not toggled
                    UpdateToggle()
                end
            end)
        end

        function Elements:Slider(text, min, max, default, callback)
            local value = math.clamp(default or min, min, max)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(1, -12, 0, 52)
            SliderFrame.BackgroundColor3 = theme.Secondary
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local SliderLabel = Instance.new("TextLabel", SliderFrame)
            SliderLabel.Size = UDim2.new(1, -60, 0, 20)
            SliderLabel.Position = UDim2.new(0, 12, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = theme.Text
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextSize = 13
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -58, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(value)
            ValueLabel.TextColor3 = theme.Accent
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 13
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Instance.new("Frame", SliderFrame)
            Bar.Size = UDim2.new(1, -24, 0, 6)
            Bar.Position = UDim2.new(0, 12, 1, -18)
            Bar.BackgroundColor3 = theme.Outline
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = theme.Accent
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local dragging = false
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + (max - min) * pos)
                value = newVal
                ValueLabel.Text = tostring(value)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                if callback then callback(value) end
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end

        function Elements:Dropdown(text, list, callback)
            local DropdownFrame = Instance.new("Frame", Page)
            DropdownFrame.Size = UDim2.new(1, -12, 0, 38)
            DropdownFrame.BackgroundColor3 = theme.Secondary
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)

            local DropBtn = Instance.new("TextButton", DropdownFrame)
            DropBtn.Size = UDim2.new(1, 0, 0, 38)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = text .. " ▼"
            DropBtn.TextColor3 = theme.Text
            DropBtn.Font = Enum.Font.GothamSemibold
            DropBtn.TextSize = 13
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            DropBtn.Position = UDim2.new(0, 12, 0, 0)

            local OptionList = Instance.new("ScrollingFrame", DropdownFrame)
            OptionList.Size = UDim2.new(1, -8, 0, 160)
            OptionList.Position = UDim2.new(0, 4, 0, 42)
            OptionList.BackgroundTransparency = 1
            OptionList.ScrollBarThickness = 4
            OptionList.ScrollBarImageColor3 = theme.Accent
            OptionList.AutomaticCanvasSize = Enum.AutomaticSize.Y

            local OptionLayout = Instance.new("UIListLayout", OptionList)
            OptionLayout.Padding = UDim.new(0, 2)

            local open = false
            DropBtn.Activated:Connect(function()
                open = not open
                local targetHeight = open and math.min(#list * 32 + 48, 200) or 38
                TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(1, -12, 0, targetHeight)}):Play()
                DropBtn.Text = text .. (open and " ▲" or " ▼")
            end)

            for _, option in ipairs(list) do
                local OptBtn = Instance.new("TextButton", OptionList)
                OptBtn.Size = UDim2.new(1, -8, 0, 30)
                OptBtn.BackgroundColor3 = theme.Main
                OptBtn.Text = option
                OptBtn.TextColor3 = theme.Text
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 6)

                OptBtn.Activated:Connect(function()
                    open = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -12, 0, 38)}):Play()
                    DropBtn.Text = text .. " ▼"
                    if callback then callback(option) end
                end)
            end
        end

        function Elements:Textbox(text, default, callback)
            local TextboxFrame = Instance.new("Frame", Page)
            TextboxFrame.Size = UDim2.new(1, -12, 0, 38)
            TextboxFrame.BackgroundColor3 = theme.Secondary
            Instance.new("UICorner", TextboxFrame).CornerRadius = UDim.new(0, 8)

            local Box = Instance.new("TextBox", TextboxFrame)
            Box.Size = UDim2.new(1, -24, 1, 0)
            Box.Position = UDim2.new(0, 12, 0, 0)
            Box.BackgroundTransparency = 1
            Box.Text = default or ""
            Box.PlaceholderText = text
            Box.TextColor3 = theme.Text
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 13
            Box.TextXAlignment = Enum.TextXAlignment.Left
            Box.ClearTextOnFocus = false

            Box.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then callback(Box.Text) end
            end)
        end

        function Elements:Keybind(text, defaultKey, callback)
            local key = defaultKey or Enum.KeyCode.Unknown
            local KeyFrame = Instance.new("Frame", Page)
            KeyFrame.Size = UDim2.new(1, -12, 0, 38)
            KeyFrame.BackgroundColor3 = theme.Secondary
            Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)

            local KeyLabel = Instance.new("TextLabel", KeyFrame)
            KeyLabel.Size = UDim2.new(0.65, 0, 1, 0)
            KeyLabel.BackgroundTransparency = 1
            KeyLabel.Text = text
            KeyLabel.TextColor3 = theme.Text
            KeyLabel.Font = Enum.Font.GothamSemibold
            KeyLabel.TextSize = 13
            KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeyLabel.Position = UDim2.new(0, 12, 0, 0)

            local KeyBtn = Instance.new("TextButton", KeyFrame)
            KeyBtn.Size = UDim2.new(0, 90, 0, 26)
            KeyBtn.Position = UDim2.new(1, -104, 0.5, -13)
            KeyBtn.BackgroundColor3 = theme.Outline
            KeyBtn.Text = key.Name
            KeyBtn.TextColor3 = theme.Text
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.TextSize = 12
            Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)

            local listening = false
            KeyBtn.Activated:Connect(function()
                listening = true
                KeyBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input)
                if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
                    key = input.KeyCode
                    KeyBtn.Text = key.Name
                    listening = false
                    if callback then callback(key) end
                end
            end)
        end

        function Elements:Colorpicker(text, defaultColor, callback)
            local color = defaultColor or Color3.fromRGB(255, 100, 100)
            local CPFrame = Instance.new("Frame", Page)
            CPFrame.Size = UDim2.new(1, -12, 0, 38)
            CPFrame.BackgroundColor3 = theme.Secondary
            Instance.new("UICorner", CPFrame).CornerRadius = UDim.new(0, 8)

            local CPText = Instance.new("TextLabel", CPFrame)
            CPText.Size = UDim2.new(0.6, 0, 1, 0)
            CPText.BackgroundTransparency = 1
            CPText.Text = text
            CPText.TextColor3 = theme.Text
            CPText.Font = Enum.Font.GothamSemibold
            CPText.TextSize = 13
            CPText.TextXAlignment = Enum.TextXAlignment.Left
            CPText.Position = UDim2.new(0, 12, 0, 0)

            local ColorDisplay = Instance.new("Frame", CPFrame)
            ColorDisplay.Size = UDim2.new(0, 80, 0, 22)
            ColorDisplay.Position = UDim2.new(1, -92, 0.5, -11)
            ColorDisplay.BackgroundColor3 = color
            Instance.new("UICorner", ColorDisplay).CornerRadius = UDim.new(0, 6)
        end

        return Elements
    end

    MinimizeBtn.Activated:Connect(function()
        Main.Visible = not Main.Visible
    end)

    table.insert(Library.Windows, window)
    return window
end

return Library
