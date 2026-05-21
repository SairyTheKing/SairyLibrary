local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local Library = {
    Icons = {},
    Themes = {
        ["Dark"]     = {Main = Color3.fromRGB(18, 18, 18), Accent = Color3.fromRGB(255, 255, 255), Outline = Color3.fromRGB(40, 40, 40), Text = Color3.fromRGB(230, 230, 230), Secondary = Color3.fromRGB(30, 30, 30)},
        ["Light"]    = {Main = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(0, 0, 0), Outline = Color3.fromRGB(200, 200, 200), Text = Color3.fromRGB(40, 40, 40), Secondary = Color3.fromRGB(220, 220, 220)},
        ["Nebula"]   = {Main = Color3.fromRGB(15, 10, 25), Accent = Color3.fromRGB(150, 50, 255), Outline = Color3.fromRGB(45, 30, 70), Text = Color3.fromRGB(240, 240, 240), Secondary = Color3.fromRGB(25, 20, 45)},
        ["Obsidian"] = {Main = Color3.fromRGB(10, 10, 10), Accent = Color3.fromRGB(120, 120, 120), Outline = Color3.fromRGB(30, 30, 30), Text = Color3.fromRGB(200, 200, 200), Secondary = Color3.fromRGB(20, 20, 20)},
        ["Aurora"]   = {Main = Color3.fromRGB(10, 25, 20), Accent = Color3.fromRGB(0, 255, 150), Outline = Color3.fromRGB(30, 60, 50), Text = Color3.fromRGB(230, 255, 240), Secondary = Color3.fromRGB(15, 40, 35)},
        ["Eclipse"]  = {Main = Color3.fromRGB(15, 15, 20), Accent = Color3.fromRGB(255, 100, 0), Outline = Color3.fromRGB(40, 30, 30), Text = Color3.fromRGB(255, 230, 230), Secondary = Color3.fromRGB(25, 20, 20)},
        ["Carbon"]   = {Main = Color3.fromRGB(25, 25, 25), Accent = Color3.fromRGB(200, 0, 0), Outline = Color3.fromRGB(50, 50, 50), Text = Color3.fromRGB(220, 220, 220), Secondary = Color3.fromRGB(35, 35, 35)},
        ["Ember"]    = {Main = Color3.fromRGB(25, 15, 10), Accent = Color3.fromRGB(255, 120, 0), Outline = Color3.fromRGB(60, 30, 10), Text = Color3.fromRGB(255, 240, 230), Secondary = Color3.fromRGB(40, 25, 15)},
        ["Glacier"]  = {Main = Color3.fromRGB(15, 20, 30), Accent = Color3.fromRGB(0, 200, 255), Outline = Color3.fromRGB(40, 60, 80), Text = Color3.fromRGB(230, 245, 255), Secondary = Color3.fromRGB(25, 35, 50)},
        ["Volt"]     = {Main = Color3.fromRGB(15, 15, 10), Accent = Color3.fromRGB(220, 255, 0), Outline = Color3.fromRGB(50, 50, 20), Text = Color3.fromRGB(245, 255, 220), Secondary = Color3.fromRGB(25, 25, 15)},
        ["Nova"]     = {Main = Color3.fromRGB(20, 10, 30), Accent = Color3.fromRGB(255, 0, 200), Outline = Color3.fromRGB(60, 20, 80), Text = Color3.fromRGB(255, 230, 250), Secondary = Color3.fromRGB(35, 15, 50)},
        ["Aether"]   = {Main = Color3.fromRGB(10, 10, 25), Accent = Color3.fromRGB(0, 255, 255), Outline = Color3.fromRGB(30, 30, 70), Text = Color3.fromRGB(220, 255, 255), Secondary = Color3.fromRGB(20, 20, 45)}
    },
    CurrentTheme = nil,
    Windows = {},
    Notifications = {},
    NotificationGui = nil,
    TweenSpeed = 0.25,
    UseAcrylic = false,
    GlobalConfig = {
        Font = Enum.Font.Gotham,
        BoldFont = Enum.Font.GothamBold,
        MediumFont = Enum.Font.GothamMedium,
        ElementHeight = 32,
        SectionHeaderHeight = 28,
        CornerRadius = 6,
        AnimationSpeed = 0.25
    }
}

Library.CurrentTheme = Library.Themes["Dark"]

local iconSuccess, iconData = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deedlemcdoodledeedlemcdoodle-creator/SpectravaxHub/main/everylucideassetin.lua"))()
end)
if iconSuccess and type(iconData) == "table" then Library.Icons = iconData end

function Library:CreateTheme(name, colors)
    if type(colors) == "table" and colors.Main and colors.Accent and colors.Outline and colors.Text and colors.Secondary then
        Library.Themes[name] = colors
        return true
    end
    return false
end

function Library:SetTheme(name)
    if Library.Themes[name] then
        Library.CurrentTheme = Library.Themes[name]
        for _, window in pairs(Library.Windows) do
            if window and window.UpdateTheme then
                window:UpdateTheme()
            end
        end
    end
end

function Library:GetIcon(name)
    return Library.Icons[name] or ""
end

function Library:MakeNotificationGui()
    if Library.NotificationGui then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "Voidseen_Notifications"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.Parent = gethui and gethui() or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    Library.NotificationGui = gui
end

function Library:Notify(title, text, duration, iconName, position)
    Library:MakeNotificationGui()
    duration = duration or 3
    position = position or "TopRight"
    local theme = Library.CurrentTheme
    local gui = Library.NotificationGui

    local Notif = Instance.new("Frame")
    Notif.Name = "Notification"
    Notif.Size = UDim2.new(0, 260, 0, 0)
    Notif.BackgroundColor3 = theme.Main
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.ZIndex = 100
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Notif)
    Stroke.Color = theme.Outline
    Stroke.Thickness = 1

    local IconLabel
    if iconName and Library.Icons[iconName] then
        IconLabel = Instance.new("ImageLabel", Notif)
        IconLabel.Size = UDim2.new(0, 20, 0, 20)
        IconLabel.Position = UDim2.new(0, 10, 0, 10)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Image = Library.Icons[iconName]
        IconLabel.ImageColor3 = theme.Accent
        IconLabel.ZIndex = 101
    end

    local TitleLabel = Instance.new("TextLabel", Notif)
    TitleLabel.Size = UDim2.new(1, iconName and -40 or -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, iconName and 38 or 10, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Notification"
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.Font = Library.GlobalConfig.BoldFont
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 101

    local TextLabel = Instance.new("TextLabel", Notif)
    TextLabel.Size = UDim2.new(1, -20, 0, 0)
    TextLabel.Position = UDim2.new(0, 10, 0, 30)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text or ""
    TextLabel.TextColor3 = theme.Text
    TextLabel.Font = Library.GlobalConfig.Font
    TextLabel.TextSize = 11
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    TextLabel.TextWrapped = true
    TextLabel.ZIndex = 101

    local textBounds = TextService:GetTextSize(text or "", 11, Library.GlobalConfig.Font, Vector2.new(240, 1000))
    local notifHeight = math.max(60, 40 + textBounds.Y)

    local ProgressBar = Instance.new("Frame", Notif)
    ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    ProgressBar.BackgroundColor3 = theme.Accent
    ProgressBar.BorderSizePixel = 0
    ProgressBar.ZIndex = 101

    local CloseBtn = Instance.new("TextButton", Notif)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -25, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = theme.Text
    CloseBtn.TextSize = 18
    CloseBtn.Font = Library.GlobalConfig.Font
    CloseBtn.ZIndex = 102

    local notifData = {Frame = Notif, Position = position}
    table.insert(Library.Notifications, 1, notifData)
    Notif.Parent = gui

    local function updatePositions()
        local count = 0
        for _, n in pairs(Library.Notifications) do
            if n.Frame and n.Frame.Parent and n.Position == position then
                local yOffset = 10 + (count * (notifHeight + 8))
                local targetPos
                if position == "TopRight" then
                    targetPos = UDim2.new(1, -270, 0, yOffset)
                elseif position == "TopLeft" then
                    targetPos = UDim2.new(0, 10, 0, yOffset)
                elseif position == "BottomRight" then
                    targetPos = UDim2.new(1, -270, 1, -(yOffset + notifHeight))
                elseif position == "BottomLeft" then
                    targetPos = UDim2.new(0, 10, 1, -(yOffset + notifHeight))
                else
                    targetPos = UDim2.new(1, -270, 0, yOffset)
                end
                TweenService:Create(n.Frame, TweenInfo.new(Library.TweenSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                count = count + 1
            end
        end
    end

    CloseBtn.Activated:Connect(function()
        for i, n in pairs(Library.Notifications) do
            if n.Frame == Notif then
                table.remove(Library.Notifications, i)
                break
            end
        end
        TweenService:Create(Notif, TweenInfo.new(0.2), {Size = UDim2.new(0, 260, 0, 0)}):Play()
        task.wait(0.2)
        Notif:Destroy()
        updatePositions()
    end)

    TweenService:Create(Notif, TweenInfo.new(Library.TweenSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, notifHeight)}):Play()
    updatePositions()

    task.delay(duration, function()
        if Notif and Notif.Parent then
            for i, n in pairs(Library.Notifications) do
                if n.Frame == Notif then
                    table.remove(Library.Notifications, i)
                    break
                end
            end
            TweenService:Create(Notif, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            for _, child in pairs(Notif:GetDescendants()) do
                if child:IsA("GuiObject") then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1}):Play()
                end
            end
            task.wait(0.2)
            if Notif then Notif:Destroy() end
            updatePositions()
        end
    end)
end

function Library:CreateWindow(title, iconName, config)
    config = config or {}
    local theme = Library.CurrentTheme
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Config = {
        Size = config.Size or UDim2.new(0, 500, 0, 350),
        Position = config.Position or UDim2.new(0.5, -250, 0.5, -175),
        Draggable = config.Draggable ~= false,
        TitleBarHeight = config.TitleBarHeight or 38,
        TabBarWidth = config.TabBarWidth or 120,
        ShowTabBar = config.ShowTabBar ~= false,
        CornerRadius = config.CornerRadius or 6,
        MinSize = config.MinSize or Vector2.new(350, 250)
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Voidseen"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = Window.Config.Position
    Main.BackgroundColor3 = theme.Main
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, Window.Config.CornerRadius)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = theme.Outline
    Stroke.Thickness = 1

    local Shadow = Instance.new("ImageLabel", Main)
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 60, 1, 60)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ZIndex = -1

    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, Window.Config.TitleBarHeight)
    TitleBar.BackgroundColor3 = theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 5

    local TitleBarCorner = Instance.new("UICorner", TitleBar)
    TitleBarCorner.CornerRadius = UDim.new(0, Window.Config.CornerRadius)

    local TitleBarFix = Instance.new("Frame", TitleBar)
    TitleBarFix.Size = UDim2.new(1, 0, 0, 10)
    TitleBarFix.Position = UDim2.new(0, 0, 1, -10)
    TitleBarFix.BackgroundColor3 = theme.Secondary
    TitleBarFix.BorderSizePixel = 0
    TitleBarFix.ZIndex = 5

    local TitleText = Instance.new("TextLabel", TitleBar)
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -80, 1, 0)
    TitleText.Position = UDim2.new(0, iconName and 36 or 12, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title or "Voidseen"
    TitleText.TextColor3 = theme.Text
    TitleText.Font = Library.GlobalConfig.BoldFont
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.ZIndex = 6

    if iconName and Library.Icons[iconName] then
        local TitleIcon = Instance.new("ImageLabel", TitleBar)
        TitleIcon.Size = UDim2.new(0, 18, 0, 18)
        TitleIcon.Position = UDim2.new(0, 10, 0.5, -9)
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.Image = Library.Icons[iconName]
        TitleIcon.ImageColor3 = theme.Accent
        TitleIcon.ZIndex = 6
    end

    local CloseBtn = Instance.new("TextButton", TitleBar)
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -31, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = ""
    CloseBtn.AutoButtonColor = false
    CloseBtn.ZIndex = 6
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

    local CloseIcon = Instance.new("ImageLabel", CloseBtn)
    CloseIcon.Size = UDim2.new(0, 14, 0, 14)
    CloseIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = Library.Icons["x"] or ""
    CloseIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CloseIcon.ZIndex = 7

    local MinimizeBtn = Instance.new("TextButton", TitleBar)
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -13)
    MinimizeBtn.BackgroundColor3 = theme.Secondary
    MinimizeBtn.Text = ""
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.ZIndex = 6
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)
    local MinStroke = Instance.new("UIStroke", MinimizeBtn)
    MinStroke.Color = theme.Outline
    MinStroke.Thickness = 1

    local MinIcon = Instance.new("ImageLabel", MinimizeBtn)
    MinIcon.Size = UDim2.new(0, 14, 0, 14)
    MinIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Image = Library.Icons["minus"] or ""
    MinIcon.ImageColor3 = theme.Text
    MinIcon.ZIndex = 7

    local TabBar
    local ContentFrame
    local TabBarLayout

    if Window.Config.ShowTabBar then
        TabBar = Instance.new("Frame", Main)
        TabBar.Name = "TabBar"
        TabBar.Size = UDim2.new(0, Window.Config.TabBarWidth, 1, -Window.Config.TitleBarHeight)
        TabBar.Position = UDim2.new(0, 0, 0, Window.Config.TitleBarHeight)
        TabBar.BackgroundColor3 = theme.Secondary
        TabBar.BorderSizePixel = 0
        TabBar.ZIndex = 4

        TabBarLayout = Instance.new("UIListLayout", TabBar)
        TabBarLayout.Padding = UDim.new(0, 2)
        TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local TabBarPadding = Instance.new("UIPadding", TabBar)
        TabBarPadding.PaddingTop = UDim.new(0, 6)
        TabBarPadding.PaddingLeft = UDim.new(0, 6)
        TabBarPadding.PaddingRight = UDim.new(0, 6)

        ContentFrame = Instance.new("Frame", Main)
        ContentFrame.Name = "Content"
        ContentFrame.Size = UDim2.new(1, -Window.Config.TabBarWidth, 1, -Window.Config.TitleBarHeight)
        ContentFrame.Position = UDim2.new(0, Window.Config.TabBarWidth, 0, Window.Config.TitleBarHeight)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.ZIndex = 3
    else
        ContentFrame = Instance.new("Frame", Main)
        ContentFrame.Name = "Content"
        ContentFrame.Size = UDim2.new(1, 0, 1, -Window.Config.TitleBarHeight)
        ContentFrame.Position = UDim2.new(0, 0, 0, Window.Config.TitleBarHeight)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.ZIndex = 3
    end

    local ContentContainer = Instance.new("ScrollingFrame", ContentFrame)
    ContentContainer.Name = "Container"
    ContentContainer.Size = UDim2.new(1, -14, 1, -14)
    ContentContainer.Position = UDim2.new(0, 7, 0, 7)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ScrollBarThickness = 2
    ContentContainer.ScrollBarImageColor3 = theme.Accent
    ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentContainer.ZIndex = 4

    local ContentLayout = Instance.new("UIListLayout", ContentContainer)
    ContentLayout.Padding = UDim.new(0, 6)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local minimized = false
    local originalSize = Window.Config.Size

    MinimizeBtn.Activated:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(Main, TweenInfo.new(Library.TweenSpeed, Enum.EasingStyle.Quint), {Size = UDim2.new(0, originalSize.X.Offset, 0, Window.Config.TitleBarHeight)}):Play()
            if ContentFrame then TweenService:Create(ContentFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
            if TabBar then TweenService:Create(TabBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
        else
            TweenService:Create(Main, TweenInfo.new(Library.TweenSpeed, Enum.EasingStyle.Quint), {Size = originalSize}):Play()
            if ContentFrame then TweenService:Create(ContentFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end
            if TabBar then TweenService:Create(TabBar, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end
        end
    end)

    CloseBtn.Activated:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        ScreenGui:Destroy()
        for i, w in pairs(Library.Windows) do
            if w == Window then table.remove(Library.Windows, i) break end
        end
    end)

    if Window.Config.Draggable then
        local dragging = false
        local dragInput
        local dragStart
        local startPos

        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)

        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                TweenService:Create(Main, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
            end
        end)
    end

    function Window:UpdateTheme()
        local newTheme = Library.CurrentTheme
        Main.BackgroundColor3 = newTheme.Main
        Stroke.Color = newTheme.Outline
        TitleBar.BackgroundColor3 = newTheme.Secondary
        TitleBarFix.BackgroundColor3 = newTheme.Secondary
        TitleText.TextColor3 = newTheme.Text
        if TabBar then TabBar.BackgroundColor3 = newTheme.Secondary end
        ContentContainer.ScrollBarImageColor3 = newTheme.Accent
        MinStroke.Color = newTheme.Outline
        MinIcon.ImageColor3 = newTheme.Text
    end

    function Window:CreateTab(tabName, tabIcon)
        local Tab = {}
        Tab.Elements = {}
        Tab.Name = tabName

        local TabButton
        if Window.Config.ShowTabBar and TabBar then
            TabButton = Instance.new("TextButton", TabBar)
            TabButton.Name = tabName
            TabButton.Size = UDim2.new(1, 0, 0, tabIcon and 50 or 34)
            TabButton.BackgroundColor3 = theme.Secondary
            TabButton.Text = ""
            TabButton.AutoButtonColor = false
            TabButton.ZIndex = 5
            Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)

            local TabStroke = Instance.new("UIStroke", TabButton)
            TabStroke.Color = theme.Outline
            TabStroke.Thickness = 1
            Tab.Stroke = TabStroke

            if tabIcon and Library.Icons[tabIcon] then
                local Icon = Instance.new("ImageLabel", TabButton)
                Icon.Name = "Icon"
                Icon.Size = UDim2.new(0, 18, 0, 18)
                Icon.Position = UDim2.new(0.5, -9, 0, 6)
                Icon.BackgroundTransparency = 1
                Icon.Image = Library.Icons[tabIcon]
                Icon.ImageColor3 = theme.Text
                Icon.ZIndex = 6

                local Name = Instance.new("TextLabel", TabButton)
                Name.Name = "Name"
                Name.Size = UDim2.new(1, -4, 0, 16)
                Name.Position = UDim2.new(0, 2, 1, -20)
                Name.BackgroundTransparency = 1
                Name.Text = tabName
                Name.TextColor3 = theme.Text
                Name.Font = Library.GlobalConfig.Font
                Name.TextSize = 11
                Name.ZIndex = 6
            else
                local Name = Instance.new("TextLabel", TabButton)
                Name.Name = "Name"
                Name.Size = UDim2.new(1, -10, 1, 0)
                Name.Position = UDim2.new(0, 10, 0, 0)
                Name.BackgroundTransparency = 1
                Name.Text = tabName
                Name.TextColor3 = theme.Text
                Name.Font = Library.GlobalConfig.Font
                Name.TextSize = 12
                Name.TextXAlignment = Enum.TextXAlignment.Left
                Name.ZIndex = 6
            end

            TabButton.MouseEnter:Connect(function()
                if Window.ActiveTab ~= Tab then
                    TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main}):Play()
                end
            end)

            TabButton.MouseLeave:Connect(function()
                if Window.ActiveTab ~= Tab then
                    TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = theme.Secondary}):Play()
                end
            end)
        end

        local TabContent = Instance.new("ScrollingFrame", ContentFrame)
        TabContent.Name = tabName .. "_Content"
        TabContent.Size = UDim2.new(1, -14, 1, -14)
        TabContent.Position = UDim2.new(0, 7, 0, 7)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = theme.Accent
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.ZIndex = 4

        local TabContentLayout = Instance.new("UIListLayout", TabContent)
        TabContentLayout.Padding = UDim.new(0, 6)
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local TabContentPadding = Instance.new("UIPadding", TabContent)
        TabContentPadding.PaddingBottom = UDim.new(0, 6)

        Tab.Content = TabContent

        function Tab:Select()
            if Window.ActiveTab then
                local prev = Window.ActiveTab
                prev.Content.Visible = false
                if prev.Button then
                    TweenService:Create(prev.Button, TweenInfo.new(0.2), {BackgroundColor3 = theme.Secondary}):Play()
                    if prev.Stroke then prev.Stroke.Color = theme.Outline end
                end
            end
            Window.ActiveTab = Tab
            TabContent.Visible = true
            if TabButton then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main}):Play()
                if Tab.Stroke then Tab.Stroke.Color = theme.Accent end
            end
        end

        if TabButton then
            TabButton.Activated:Connect(function() Tab:Select() end)
            Tab.Button = TabButton
        end

        function Tab:Label(text, labelConfig)
            labelConfig = labelConfig or {}
            local Label = Instance.new("TextLabel", TabContent)
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 0, labelConfig.Height or 20)
            Label.BackgroundTransparency = 1
            Label.Text = text or ""
            Label.TextColor3 = labelConfig.Color or theme.Text
            Label.Font = labelConfig.Bold and Library.GlobalConfig.BoldFont or Library.GlobalConfig.Font
            Label.TextSize = labelConfig.Size or 12
            Label.TextXAlignment = labelConfig.Alignment or Enum.TextXAlignment.Left
            Label.TextTransparency = labelConfig.Transparency or 0.3
            Label.RichText = labelConfig.RichText or false
            Label.TextWrapped = labelConfig.Wrapped or false
            if labelConfig.Order then Label.LayoutOrder = labelConfig.Order end
            return Label
        end

        function Tab:Section(title, sectionConfig)
            sectionConfig = sectionConfig or {}
            local Section = {}
            Section.Collapsed = false

            local SectionFrame = Instance.new("Frame", TabContent)
            SectionFrame.Name = title .. "_Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.SectionHeaderHeight)
            SectionFrame.BackgroundColor3 = theme.Secondary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.ClipsDescendants = true
            SectionFrame.ZIndex = 3
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 4)

            local SectionStroke = Instance.new("UIStroke", SectionFrame)
            SectionStroke.Color = theme.Outline
            SectionStroke.Thickness = 1

            local Header = Instance.new("TextButton", SectionFrame)
            Header.Name = "Header"
            Header.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.SectionHeaderHeight)
            Header.BackgroundTransparency = 1
            Header.Text = ""
            Header.AutoButtonColor = false
            Header.ZIndex = 4

            local HeaderText = Instance.new("TextLabel", Header)
            HeaderText.Size = UDim2.new(1, -40, 1, 0)
            HeaderText.Position = UDim2.new(0, 10, 0, 0)
            HeaderText.BackgroundTransparency = 1
            HeaderText.Text = title or "Section"
            HeaderText.TextColor3 = theme.Text
            HeaderText.Font = Library.GlobalConfig.BoldFont
            HeaderText.TextSize = 12
            HeaderText.TextXAlignment = Enum.TextXAlignment.Left
            HeaderText.ZIndex = 5

            local ToggleIcon = Instance.new("ImageLabel", Header)
            ToggleIcon.Name = "Toggle"
            ToggleIcon.Size = UDim2.new(0, 14, 0, 14)
            ToggleIcon.Position = UDim2.new(1, -24, 0.5, -7)
            ToggleIcon.BackgroundTransparency = 1
            ToggleIcon.Image = Library.Icons["chevron-down"] or ""
            ToggleIcon.ImageColor3 = theme.Text
            ToggleIcon.ZIndex = 5

            local SectionContent = Instance.new("Frame", SectionFrame)
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, -12, 0, 0)
            SectionContent.Position = UDim2.new(0, 6, 0, Library.GlobalConfig.SectionHeaderHeight)
            SectionContent.BackgroundTransparency = 1
            SectionContent.BorderSizePixel = 0
            SectionContent.ZIndex = 3

            local SectionLayout = Instance.new("UIListLayout", SectionContent)
            SectionLayout.Padding = UDim.new(0, 6)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder

            Section.Content = SectionContent

            function Section:UpdateSize()
                local contentHeight = SectionLayout.AbsoluteContentSize.Y
                local targetHeight = Section.Collapsed and Library.GlobalConfig.SectionHeaderHeight or (Library.GlobalConfig.SectionHeaderHeight + contentHeight + 12)
                TweenService:Create(SectionFrame, TweenInfo.new(Library.TweenSpeed, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(ToggleIcon, TweenInfo.new(Library.TweenSpeed), {Rotation = Section.Collapsed and 0 or 180}):Play()
            end

            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if not Section.Collapsed then
                    Section:UpdateSize()
                end
            end)

            Header.Activated:Connect(function()
                Section.Collapsed = not Section.Collapsed
                Section:UpdateSize()
            end)

            Section.Elements = {}

            function Section:Label(text, labelConfig)
                local lbl = Tab:Label(text, labelConfig)
                lbl.Parent = SectionContent
                table.insert(Section.Elements, lbl)
                return lbl
            end

            function Section:Button(text, iconName, callback)
                local btn = Tab:Button(text, iconName, callback)
                btn.Parent = SectionContent
                table.insert(Section.Elements, btn)
                return btn
            end

            function Section:Toggle(text, default, callback, toggleConfig)
                local tgl = Tab:Toggle(text, default, callback, toggleConfig)
                tgl.Parent = SectionContent
                table.insert(Section.Elements, tgl)
                return tgl
            end

            function Section:Slider(text, min, max, default, callback, sliderConfig)
                local sld = Tab:Slider(text, min, max, default, callback, sliderConfig)
                sld.Parent = SectionContent
                table.insert(Section.Elements, sld)
                return sld
            end

            function Section:Dropdown(text, list, callback)
                local drp = Tab:Dropdown(text, list, callback)
                drp.Parent = SectionContent
                table.insert(Section.Elements, drp)
                return drp
            end

            function Section:MultiDropdown(text, list, callback)
                local drp = Tab:MultiDropdown(text, list, callback)
                drp.Parent = SectionContent
                table.insert(Section.Elements, drp)
                return drp
            end

            function Section:Textbox(text, default, callback, textboxConfig)
                local txt = Tab:Textbox(text, default, callback, textboxConfig)
                txt.Parent = SectionContent
                table.insert(Section.Elements, txt)
                return txt
            end

            function Section:Keybind(text, defaultKey, callback)
                local kb = Tab:Keybind(text, defaultKey, callback)
                kb.Parent = SectionContent
                table.insert(Section.Elements, kb)
                return kb
            end

            function Section:Colorpicker(text, defaultColor, callback)
                local cp = Tab:Colorpicker(text, defaultColor, callback)
                cp.Parent = SectionContent
                table.insert(Section.Elements, cp)
                return cp
            end

            function Section:CopyLabel(text, content)
                local cl = Tab:CopyLabel(text, content)
                cl.Parent = SectionContent
                table.insert(Section.Elements, cl)
                return cl
            end

            return Section
        end

        function Tab:Button(text, iconName, callback)
            local Button = Instance.new("TextButton", TabContent)
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            Button.BackgroundColor3 = theme.Secondary
            Button.Text = (iconName and "       " or "  ") .. (text or "Button")
            Button.TextColor3 = theme.Text
            Button.Font = Library.GlobalConfig.Font
            Button.TextSize = 12
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.AutoButtonColor = false
            Button.ZIndex = 4
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)

            local ButtonStroke = Instance.new("UIStroke", Button)
            ButtonStroke.Color = theme.Outline
            ButtonStroke.Thickness = 1

            if iconName and Library.Icons[iconName] then
                local Icon = Instance.new("ImageLabel", Button)
                Icon.Size = UDim2.new(0, 16, 0, 16)
                Icon.Position = UDim2.new(0, 10, 0.5, -8)
                Icon.BackgroundTransparency = 1
                Icon.Image = Library.Icons[iconName]
                Icon.ImageColor3 = theme.Text
                Icon.ZIndex = 5
            end

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main}):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = theme.Accent}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = theme.Secondary}):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = theme.Outline}):Play()
            end)

            Button.Activated:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = theme.Accent}):Play()
                TweenService:Create(Button, TweenInfo.new(0.1), {TextColor3 = theme.Main}):Play()
                task.wait(0.12)
                TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = theme.Main}):Play()
                TweenService:Create(Button, TweenInfo.new(0.15), {TextColor3 = theme.Text}):Play()
                if callback then callback() end
            end)

            return Button
        end

        function Tab:Toggle(text, default, callback, toggleConfig)
            toggleConfig = toggleConfig or {}
            local ToggleFrame = Instance.new("Frame", TabContent)
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            ToggleFrame.BackgroundColor3 = theme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.ZIndex = 4
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)

            local ToggleStroke = Instance.new("UIStroke", ToggleFrame)
            ToggleStroke.Color = theme.Outline
            ToggleStroke.Thickness = 1

            local Label = Instance.new("TextLabel", ToggleFrame)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text or "Toggle"
            Label.TextColor3 = theme.Text
            Label.Font = Library.GlobalConfig.Font
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 5

            local ToggleBtn = Instance.new("TextButton", ToggleFrame)
            ToggleBtn.Name = "ToggleBtn"
            ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -52, 0.5, -10)
            ToggleBtn.BackgroundColor3 = theme.Main
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            ToggleBtn.ZIndex = 5
            Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame", ToggleBtn)
            Circle.Name = "Circle"
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = UDim2.new(0, 3, 0.5, -7)
            Circle.BackgroundColor3 = theme.Text
            Circle.BorderSizePixel = 0
            Circle.ZIndex = 6
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local state = default or false

            local function updateVisual()
                if state then
                    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 23, 0.5, -7)}):Play()
                    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = theme.Accent}):Play()
                else
                    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
                    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = theme.Outline}):Play()
                end
            end

            updateVisual()

            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    state = not state
                    updateVisual()
                    if callback then callback(state) end
                end
            end)

            ToggleFrame.MouseEnter:Connect(function()
                if not state then
                    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = theme.Outline}):Play()
                end
            end)

            return ToggleFrame
        end

        function Tab:Slider(text, min, max, default, callback, sliderConfig)
            sliderConfig = sliderConfig or {}
            local suffix = sliderConfig.Suffix or ""
            local step = sliderConfig.Step or 1
            local defaultVal = math.clamp(default or min, min, max)

            local SliderFrame = Instance.new("Frame", TabContent)
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 48)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.ZIndex = 4

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Size = UDim2.new(1, -60, 0, 18)
            Label.BackgroundTransparency = 1
            Label.Text = text or "Slider"
            Label.TextColor3 = theme.Text
            Label.Font = Library.GlobalConfig.Font
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 5

            local ValLabel = Instance.new("TextLabel", SliderFrame)
            ValLabel.Size = UDim2.new(0, 60, 0, 18)
            ValLabel.Position = UDim2.new(1, -60, 0, 0)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(defaultVal) .. suffix
            ValLabel.TextColor3 = theme.Accent
            ValLabel.Font = Library.GlobalConfig.BoldFont
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.ZIndex = 5

            local BarFrame = Instance.new("Frame", SliderFrame)
            BarFrame.Size = UDim2.new(1, -6, 0, 6)
            BarFrame.Position = UDim2.new(0, 3, 0, 30)
            BarFrame.BackgroundColor3 = theme.Secondary
            BarFrame.BorderSizePixel = 0
            BarFrame.ZIndex = 5
            Instance.new("UICorner", BarFrame).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", BarFrame)
            Fill.Name = "Fill"
            Fill.Size = UDim2.new((defaultVal - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = theme.Accent
            Fill.BorderSizePixel = 0
            Fill.ZIndex = 6
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", Fill)
            Knob.Name = "Knob"
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = UDim2.new(1, -7, 0.5, -7)
            Knob.BackgroundColor3 = theme.Text
            Knob.BorderSizePixel = 0
            Knob.ZIndex = 7
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local dragging = false

            local function update(input)
                local pos = math.clamp((input.Position.X - BarFrame.AbsolutePosition.X) / BarFrame.AbsoluteSize.X, 0, 1)
                local rawVal = ((max - min) * pos) + min
                local val = math.floor((rawVal / step) + 0.5) * step
                val = math.clamp(val, min, max)
                Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                ValLabel.Text = tostring(val) .. suffix
                if callback then callback(val) end
            end

            BarFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            return SliderFrame
        end

        function Tab:Dropdown(text, list, callback)
            local DropdownFrame = Instance.new("Frame", TabContent)
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            DropdownFrame.BackgroundColor3 = theme.Secondary
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.ZIndex = 10
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)

            local DropdownStroke = Instance.new("UIStroke", DropdownFrame)
            DropdownStroke.Color = theme.Outline
            DropdownStroke.Thickness = 1

            local DropBtn = Instance.new("TextButton", DropdownFrame)
            DropBtn.Name = "DropBtn"
            DropBtn.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = "  " .. (text or "Dropdown") .. " ▼"
            DropBtn.TextColor3 = theme.Text
            DropBtn.Font = Library.GlobalConfig.Font
            DropBtn.TextSize = 12
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            DropBtn.ZIndex = 11
            DropBtn.AutoButtonColor = false

            local SelectedLabel = Instance.new("TextLabel", DropBtn)
            SelectedLabel.Name = "Selected"
            SelectedLabel.Size = UDim2.new(0.5, 0, 1, 0)
            SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Text = ""
            SelectedLabel.TextColor3 = theme.Accent
            SelectedLabel.Font = Library.GlobalConfig.Font
            SelectedLabel.TextSize = 11
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.ZIndex = 12

            local SearchBox = Instance.new("TextBox", DropdownFrame)
            SearchBox.Name = "Search"
            SearchBox.Size = UDim2.new(1, -12, 0, 26)
            SearchBox.Position = UDim2.new(0, 6, 0, Library.GlobalConfig.ElementHeight + 4)
            SearchBox.BackgroundColor3 = theme.Main
            SearchBox.Text = ""
            SearchBox.PlaceholderText = "Search..."
            SearchBox.TextColor3 = theme.Text
            SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            SearchBox.Font = Library.GlobalConfig.Font
            SearchBox.TextSize = 11
            SearchBox.ClearTextOnFocus = false
            SearchBox.ZIndex = 11
            Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

            local OptionScroll = Instance.new("ScrollingFrame", DropdownFrame)
            OptionScroll.Name = "Options"
            OptionScroll.Size = UDim2.new(1, -12, 0, 120)
            OptionScroll.Position = UDim2.new(0, 6, 0, Library.GlobalConfig.ElementHeight + 34)
            OptionScroll.BackgroundTransparency = 1
            OptionScroll.BorderSizePixel = 0
            OptionScroll.ScrollBarThickness = 2
            OptionScroll.ScrollBarImageColor3 = theme.Accent
            OptionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            OptionScroll.ZIndex = 11

            local OptionLayout = Instance.new("UIListLayout", OptionScroll)
            OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionLayout.Padding = UDim.new(0, 2)

            local toggled = false
            local options = {}
            local originalList = list or {}

            local function buildOptions(filter)
                for _, child in pairs(OptionScroll:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                options = {}
                for _, v in pairs(originalList) do
                    if not filter or string.find(string.lower(tostring(v)), string.lower(filter)) then
                        local Option = Instance.new("TextButton", OptionScroll)
                        Option.Size = UDim2.new(1, 0, 0, 24)
                        Option.BackgroundTransparency = 1
                        Option.Text = "  " .. tostring(v)
                        Option.TextColor3 = theme.Text
                        Option.Font = Library.GlobalConfig.Font
                        Option.TextSize = 11
                        Option.TextXAlignment = Enum.TextXAlignment.Left
                        Option.ZIndex = 12
                        Option.AutoButtonColor = false

                        Option.MouseEnter:Connect(function()
                            TweenService:Create(Option, TweenInfo.new(0.15), {BackgroundTransparency = 0.9}):Play()
                            Option.BackgroundColor3 = theme.Accent
                        end)

                        Option.MouseLeave:Connect(function()
                            TweenService:Create(Option, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                        end)

                        Option.Activated:Connect(function()
                            toggled = false
                            SelectedLabel.Text = tostring(v)
                            TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)}):Play()
                            DropBtn.Text = "  " .. (text or "Dropdown") .. " ▼"
                            SearchBox.Text = ""
                            if callback then callback(v) end
                        end)

                        table.insert(options, Option)
                    end
                end
            end

            buildOptions()

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                buildOptions(SearchBox.Text)
            end)

            DropBtn.Activated:Connect(function()
                toggled = not toggled
                local contentHeight = math.min(#options * 26 + 40, 160)
                local goalSize = toggled and UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight + contentHeight) or UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = goalSize}):Play()
                DropBtn.Text = toggled and "  " .. (text or "Dropdown") .. " ▲" or "  " .. (text or "Dropdown") .. " ▼"
                if toggled then
                    task.wait(0.1)
                    SearchBox:CaptureFocus()
                end
            end)

            DropdownFrame.MouseEnter:Connect(function()
                if not toggled then
                    TweenService:Create(DropdownStroke, TweenInfo.new(0.2), {Color = theme.Accent}):Play()
                end
            end)

            DropdownFrame.MouseLeave:Connect(function()
                if not toggled then
                    TweenService:Create(DropdownStroke, TweenInfo.new(0.2), {Color = theme.Outline}):Play()
                end
            end)

            return DropdownFrame
        end

        function Tab:MultiDropdown(text, list, callback)
            local DropdownFrame = Instance.new("Frame", TabContent)
            DropdownFrame.Name = "MultiDropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            DropdownFrame.BackgroundColor3 = theme.Secondary
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.ZIndex = 10
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)

            local DropdownStroke = Instance.new("UIStroke", DropdownFrame)
            DropdownStroke.Color = theme.Outline
            DropdownStroke.Thickness = 1

            local DropBtn = Instance.new("TextButton", DropdownFrame)
            DropBtn.Name = "DropBtn"
            DropBtn.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = "  " .. (text or "MultiDropdown") .. " ▼"
            DropBtn.TextColor3 = theme.Text
            DropBtn.Font = Library.GlobalConfig.Font
            DropBtn.TextSize = 12
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            DropBtn.ZIndex = 11
            DropBtn.AutoButtonColor = false

            local CountLabel = Instance.new("TextLabel", DropBtn)
            CountLabel.Name = "Count"
            CountLabel.Size = UDim2.new(0.5, 0, 1, 0)
            CountLabel.Position = UDim2.new(0.5, 0, 0, 0)
            CountLabel.BackgroundTransparency = 1
            CountLabel.Text = "0 selected"
            CountLabel.TextColor3 = theme.Accent
            CountLabel.Font = Library.GlobalConfig.Font
            CountLabel.TextSize = 11
            CountLabel.TextXAlignment = Enum.TextXAlignment.Right
            CountLabel.ZIndex = 12

            local OptionScroll = Instance.new("ScrollingFrame", DropdownFrame)
            OptionScroll.Name = "Options"
            OptionScroll.Size = UDim2.new(1, -12, 0, 120)
            OptionScroll.Position = UDim2.new(0, 6, 0, Library.GlobalConfig.ElementHeight + 4)
            OptionScroll.BackgroundTransparency = 1
            OptionScroll.BorderSizePixel = 0
            OptionScroll.ScrollBarThickness = 2
            OptionScroll.ScrollBarImageColor3 = theme.Accent
            OptionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            OptionScroll.ZIndex = 11

            local OptionLayout = Instance.new("UIListLayout", OptionScroll)
            OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionLayout.Padding = UDim.new(0, 2)

            local selected = {}
            local toggled = false

            local function updateCount()
                CountLabel.Text = tostring(#selected) .. " selected"
                if callback then callback(selected) end
            end

            for _, v in pairs(list or {}) do
                local OptionFrame = Instance.new("Frame", OptionScroll)
                OptionFrame.Size = UDim2.new(1, 0, 0, 26)
                OptionFrame.BackgroundTransparency = 1
                OptionFrame.ZIndex = 12

                local CheckBox = Instance.new("Frame", OptionFrame)
                CheckBox.Size = UDim2.new(0, 16, 0, 16)
                CheckBox.Position = UDim2.new(0, 6, 0.5, -8)
                CheckBox.BackgroundColor3 = theme.Main
                CheckBox.BorderSizePixel = 0
                CheckBox.ZIndex = 13
                Instance.new("UICorner", CheckBox).CornerRadius = UDim.new(0, 3)

                local CheckMark = Instance.new("ImageLabel", CheckBox)
                CheckMark.Size = UDim2.new(0, 12, 0, 12)
                CheckMark.Position = UDim2.new(0.5, -6, 0.5, -6)
                CheckMark.BackgroundTransparency = 1
                CheckMark.Image = Library.Icons["check"] or ""
                CheckMark.ImageColor3 = theme.Accent
                CheckMark.ZIndex = 14
                CheckMark.Visible = false

                local OptionText = Instance.new("TextButton", OptionFrame)
                OptionText.Size = UDim2.new(1, -30, 1, 0)
                OptionText.Position = UDim2.new(0, 28, 0, 0)
                OptionText.BackgroundTransparency = 1
                OptionText.Text = tostring(v)
                OptionText.TextColor3 = theme.Text
                OptionText.Font = Library.GlobalConfig.Font
                OptionText.TextSize = 11
                OptionText.TextXAlignment = Enum.TextXAlignment.Left
                OptionText.ZIndex = 13
                OptionText.AutoButtonColor = false

                local isSelected = false

                local function toggleOption()
                    isSelected = not isSelected
                    CheckMark.Visible = isSelected
                    if isSelected then
                        TweenService:Create(CheckBox, TweenInfo.new(0.15), {BackgroundColor3 = theme.Secondary}):Play()
                        if not table.find(selected, v) then table.insert(selected, v) end
                    else
                        TweenService:Create(CheckBox, TweenInfo.new(0.15), {BackgroundColor3 = theme.Main}):Play()
                        local idx = table.find(selected, v)
                        if idx then table.remove(selected, idx) end
                    end
                    updateCount()
                end

                OptionText.Activated:Connect(toggleOption)
                CheckBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then toggleOption() end
                end)

                OptionFrame.MouseEnter:Connect(function()
                    TweenService:Create(OptionFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.9}):Play()
                    OptionFrame.BackgroundColor3 = theme.Accent
                end)

                OptionFrame.MouseLeave:Connect(function()
                    TweenService:Create(OptionFrame, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                end)
            end

            DropBtn.Activated:Connect(function()
                toggled = not toggled
                local contentHeight = math.min((#list or 0) * 28 + 10, 140)
                local goalSize = toggled and UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight + contentHeight) or UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = goalSize}):Play()
                DropBtn.Text = toggled and "  " .. (text or "MultiDropdown") .. " ▲" or "  " .. (text or "MultiDropdown") .. " ▼"
            end)

            return DropdownFrame
        end

        function Tab:Textbox(text, default, callback, textboxConfig)
            textboxConfig = textboxConfig or {}
            local TextboxFrame = Instance.new("Frame", TabContent)
            TextboxFrame.Name = "Textbox"
            TextboxFrame.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight + (text and 20 or 0))
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.ZIndex = 4

            local Label
            if text then
                Label = Instance.new("TextLabel", TextboxFrame)
                Label.Size = UDim2.new(1, 0, 0, 18)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = theme.Text
                Label.Font = Library.GlobalConfig.Font
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 5
            end

            local Box = Instance.new("TextBox", TextboxFrame)
            Box.Name = "Input"
            Box.Size = UDim2.new(1, 0, 0, 28)
            Box.Position = UDim2.new(0, 0, 0, text and 20 or 0)
            Box.BackgroundColor3 = theme.Secondary
            Box.Text = default or ""
            Box.PlaceholderText = textboxConfig.Placeholder or "Enter text..."
            Box.TextColor3 = theme.Text
            Box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            Box.Font = Library.GlobalConfig.Font
            Box.TextSize = 12
            Box.ClearTextOnFocus = false
            Box.ZIndex = 5
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

            local BoxStroke = Instance.new("UIStroke", Box)
            BoxStroke.Color = theme.Outline
            BoxStroke.Thickness = 1

            Box.Focused:Connect(function()
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = theme.Accent}):Play()
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main}):Play()
            end)

            Box.FocusLost:Connect(function(enterPressed)
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = theme.Outline}):Play()
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = theme.Secondary}):Play()
                if callback then callback(Box.Text, enterPressed) end
            end)

            return TextboxFrame
        end

        function Tab:Keybind(text, defaultKey, callback)
            local KeybindFrame = Instance.new("Frame", TabContent)
            KeybindFrame.Name = "Keybind"
            KeybindFrame.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            KeybindFrame.BackgroundColor3 = theme.Secondary
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.ZIndex = 4
            Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 4)

            local KeybindStroke = Instance.new("UIStroke", KeybindFrame)
            KeybindStroke.Color = theme.Outline
            KeybindStroke.Thickness = 1

            local Label = Instance.new("TextLabel", KeybindFrame)
            Label.Size = UDim2.new(1, -80, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text or "Keybind"
            Label.TextColor3 = theme.Text
            Label.Font = Library.GlobalConfig.Font
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 5

            local KeyBtn = Instance.new("TextButton", KeybindFrame)
            KeyBtn.Name = "KeyBtn"
            KeyBtn.Size = UDim2.new(0, 70, 0, 22)
            KeyBtn.Position = UDim2.new(1, -78, 0.5, -11)
            KeyBtn.BackgroundColor3 = theme.Main
            KeyBtn.Text = defaultKey and tostring(defaultKey):gsub("Enum.KeyCode.", "") or "None"
            KeyBtn.TextColor3 = theme.Accent
            KeyBtn.Font = Library.GlobalConfig.BoldFont
            KeyBtn.TextSize = 11
            KeyBtn.AutoButtonColor = false
            KeyBtn.ZIndex = 5
            Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)

            local listening = false
            local currentKey = defaultKey

            KeyBtn.Activated:Connect(function()
                listening = not listening
                if listening then
                    KeyBtn.Text = "..."
                    TweenService:Create(KeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, TextColor3 = theme.Main}):Play()
                else
                    KeyBtn.Text = currentKey and tostring(currentKey):gsub("Enum.KeyCode.", "") or "None"
                    TweenService:Create(KeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main, TextColor3 = theme.Accent}):Play()
                end
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            currentKey = nil
                            KeyBtn.Text = "None"
                        else
                            currentKey = input.KeyCode
                            KeyBtn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                            if callback then callback(input.KeyCode) end
                        end
                        listening = false
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main, TextColor3 = theme.Accent}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        currentKey = input.UserInputType
                        KeyBtn.Text = input.UserInputType == Enum.UserInputType.MouseButton1 and "MB1" or "MB2"
                        listening = false
                        if callback then callback(input.UserInputType) end
                        TweenService:Create(KeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Main, TextColor3 = theme.Accent}):Play()
                    end
                elseif currentKey and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                        if callback then callback(currentKey) end
                    elseif input.UserInputType == currentKey then
                        if callback then callback(currentKey) end
                    end
                end
            end)

            return KeybindFrame
        end

        function Tab:Colorpicker(text, defaultColor, callback)
            local ColorFrame = Instance.new("Frame", TabContent)
            ColorFrame.Name = "Colorpicker"
            ColorFrame.Size = UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
            ColorFrame.BackgroundColor3 = theme.Secondary
            ColorFrame.BorderSizePixel = 0
            ColorFrame.ZIndex = 10
            Instance.new("UICorner", ColorFrame).CornerRadius = UDim.new(0, 4)

            local ColorStroke = Instance.new("UIStroke", ColorFrame)
            ColorStroke.Color = theme.Outline
            ColorStroke.Thickness = 1

            local Label = Instance.new("TextLabel", ColorFrame)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text or "Color"
            Label.TextColor3 = theme.Text
            Label.Font = Library.GlobalConfig.Font
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 11

            local Preview = Instance.new("TextButton", ColorFrame)
            Preview.Name = "Preview"
            Preview.Size = UDim2.new(0, 40, 0, 22)
            Preview.Position = UDim2.new(1, -48, 0.5, -11)
            Preview.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255)
            Preview.Text = ""
            Preview.AutoButtonColor = false
            Preview.ZIndex = 11
            Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 4)

            local PickerFrame = Instance.new("Frame", ColorFrame)
            PickerFrame.Name = "Picker"
            PickerFrame.Size = UDim2.new(1, 0, 0, 0)
            PickerFrame.Position = UDim2.new(0, 0, 0, Library.GlobalConfig.ElementHeight)
            PickerFrame.BackgroundColor3 = theme.Secondary
            PickerFrame.BorderSizePixel = 0
            PickerFrame.ClipsDescendants = true
            PickerFrame.ZIndex = 12
            Instance.new("UICorner", PickerFrame).CornerRadius = UDim.new(0, 4)

            local HueFrame = Instance.new("Frame", PickerFrame)
            HueFrame.Size = UDim2.new(1, -16, 0, 100)
            HueFrame.Position = UDim2.new(0, 8, 0, 8)
            HueFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            HueFrame.BorderSizePixel = 0
            HueFrame.ZIndex = 13
            Instance.new("UICorner", HueFrame).CornerRadius = UDim.new(0, 4)

            local SatVal = Instance.new("Frame", HueFrame)
            SatVal.Size = UDim2.new(1, 0, 1, 0)
            SatVal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SatVal.BackgroundTransparency = 1
            SatVal.ZIndex = 14

            local SatGradient = Instance.new("UIGradient", SatVal)
            SatGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
            SatGradient.Transparency = NumberSequence.new(0, 1)

            local ValGradient = Instance.new("UIGradient", SatVal)
            ValGradient.Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0))
            ValGradient.Transparency = NumberSequence.new(1, 0)
            ValGradient.Rotation = 180

            local HueSlider = Instance.new("Frame", PickerFrame)
            HueSlider.Size = UDim2.new(1, -16, 0, 12)
            HueSlider.Position = UDim2.new(0, 8, 0, 116)
            HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSlider.BorderSizePixel = 0
            HueSlider.ZIndex = 13
            Instance.new("UICorner", HueSlider).CornerRadius = UDim.new(0, 3)

            local HueGradient = Instance.new("UIGradient", HueSlider)
            HueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })

            local HueCursor = Instance.new("Frame", HueSlider)
            HueCursor.Size = UDim2.new(0, 4, 1, 4)
            HueCursor.Position = UDim2.new(0, 0, 0, -2)
            HueCursor.BackgroundColor3 = theme.Text
            HueCursor.BorderSizePixel = 0
            HueCursor.ZIndex = 15

            local SVCursor = Instance.new("Frame", SatVal)
            SVCursor.Size = UDim2.new(0, 8, 0, 8)
            SVCursor.BackgroundColor3 = theme.Text
            SVCursor.BorderSizePixel = 0
            SVCursor.ZIndex = 15
            Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)

            local InputFrame = Instance.new("Frame", PickerFrame)
            InputFrame.Size = UDim2.new(1, -16, 0, 24)
            InputFrame.Position = UDim2.new(0, 8, 0, 134)
            InputFrame.BackgroundTransparency = 1
            InputFrame.ZIndex = 13

            local RBox = Instance.new("TextBox", InputFrame)
            RBox.Size = UDim2.new(0.3, -4, 1, 0)
            RBox.BackgroundColor3 = theme.Main
            RBox.Text = "255"
            RBox.TextColor3 = theme.Text
            RBox.Font = Library.GlobalConfig.Font
            RBox.TextSize = 11
            RBox.ZIndex = 14
            Instance.new("UICorner", RBox).CornerRadius = UDim.new(0, 3)

            local GBox = Instance.new("TextBox", InputFrame)
            GBox.Size = UDim2.new(0.3, -4, 1, 0)
            GBox.Position = UDim2.new(0.35, 0, 0, 0)
            GBox.BackgroundColor3 = theme.Main
            GBox.Text = "255"
            GBox.TextColor3 = theme.Text
            GBox.Font = Library.GlobalConfig.Font
            GBox.TextSize = 11
            GBox.ZIndex = 14
            Instance.new("UICorner", GBox).CornerRadius = UDim.new(0, 3)

            local BBox = Instance.new("TextBox", InputFrame)
            BBox.Size = UDim2.new(0.3, -4, 1, 0)
            BBox.Position = UDim2.new(0.7, 0, 0, 0)
            BBox.BackgroundColor3 = theme.Main
            BBox.Text = "255"
            BBox.TextColor3 = theme.Text
            BBox.Font = Library.GlobalConfig.Font
            BBox.TextSize = 11
            BBox.ZIndex = 14
            Instance.new("UICorner", BBox).CornerRadius = UDim.new(0, 3)

            local HexBox = Instance.new("TextBox", PickerFrame)
            HexBox.Size = UDim2.new(1, -16, 0, 22)
            HexBox.Position = UDim2.new(0, 8, 0, 162)
            HexBox.BackgroundColor3 = theme.Main
            HexBox.Text = "#FFFFFF"
            HexBox.TextColor3 = theme.Text
            HexBox.Font = Library.GlobalConfig.Font
            HexBox.TextSize = 11
            HexBox.ZIndex = 14
            Instance.new("UICorner", HexBox).CornerRadius = UDim.new(0, 3)

            local currentH, currentS, currentV = 0, 0, 1
            local color = defaultColor or Color3.fromRGB(255, 255, 255)

            local function hsvToRgb(h, s, v)
                local r, g, b
                local i = math.floor(h * 6)
                local f = h * 6 - i
                local p = v * (1 - s)
                local q = v * (1 - f * s)
                local t = v * (1 - (1 - f) * s)
                i = i % 6
                if i == 0 then r, g, b = v, t, p
                elseif i == 1 then r, g, b = q, v, p
                elseif i == 2 then r, g, b = p, v, t
                elseif i == 3 then r, g, b = p, q, v
                elseif i == 4 then r, g, b = t, p, v
                elseif i == 5 then r, g, b = v, p, q
                end
                return Color3.new(r, g, b)
            end

            local function rgbToHsv(c)
                local r, g, b = c.R, c.G, c.B
                local max, min = math.max(r, g, b), math.min(r, g, b)
                local h, s, v
                v = max
                local d = max - min
                if max == 0 then s = 0 else s = d / max end
                if max == min then h = 0
                else
                    if max == r then h = (g - b) / d if g < b then h = h + 6 end
                    elseif max == g then h = (b - r) / d + 2
                    else h = (r - g) / d + 4
                    end
                    h = h / 6
                end
                return h, s, v
            end

            local function updateColor(newColor, skipInputs)
                color = newColor
                Preview.BackgroundColor3 = color
                if callback then callback(color) end
                if not skipInputs then
                    local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
                    RBox.Text = tostring(r)
                    GBox.Text = tostring(g)
                    BBox.Text = tostring(b)
                    HexBox.Text = string.format("#%02X%02X%02X", r, g, b)
                end
            end

            local function updateFromHSV()
                local newColor = hsvToRgb(currentH, currentS, currentV)
                HueFrame.BackgroundColor3 = hsvToRgb(currentH, 1, 1)
                updateColor(newColor)
            end

            local function setFromColor(c)
                currentH, currentS, currentV = rgbToHsv(c)
                HueCursor.Position = UDim2.new(currentH, -2, 0, -2)
                SVCursor.Position = UDim2.new(currentS, -4, 1 - currentV, -4)
                updateFromHSV()
            end

            setFromColor(color)

            local hueDragging = false
            local svDragging = false

            HueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                    local pos = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                    currentH = pos
                    HueCursor.Position = UDim2.new(pos, -2, 0, -2)
                    updateFromHSV()
                end
            end)

            SatVal.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = true
                    currentS = math.clamp((input.Position.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                    currentV = 1 - math.clamp((input.Position.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                    SVCursor.Position = UDim2.new(currentS, -4, 1 - currentV, -4)
                    updateFromHSV()
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                    currentH = pos
                    HueCursor.Position = UDim2.new(pos, -2, 0, -2)
                    updateFromHSV()
                end
                if svDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    currentS = math.clamp((input.Position.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                    currentV = 1 - math.clamp((input.Position.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                    SVCursor.Position = UDim2.new(currentS, -4, 1 - currentV, -4)
                    updateFromHSV()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                    svDragging = false
                end
            end)

            local function parseInputs()
                local r = math.clamp(tonumber(RBox.Text) or 255, 0, 255)
                local g = math.clamp(tonumber(GBox.Text) or 255, 0, 255)
                local b = math.clamp(tonumber(BBox.Text) or 255, 0, 255)
                setFromColor(Color3.fromRGB(r, g, b))
            end

            RBox.FocusLost:Connect(parseInputs)
            GBox.FocusLost:Connect(parseInputs)
            BBox.FocusLost:Connect(parseInputs)

            HexBox.FocusLost:Connect(function()
                local hex = HexBox.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1, 2), 16) or 255
                    local g = tonumber(hex:sub(3, 4), 16) or 255
                    local b = tonumber(hex:sub(5, 6), 16) or 255
                    setFromColor(Color3.fromRGB(r, g, b))
                end
            end)

            local toggled = false
            Preview.Activated:Connect(function()
                toggled = not toggled
                local targetSize = toggled and UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight + 190) or UDim2.new(1, 0, 0, Library.GlobalConfig.ElementHeight)
                TweenService:Create(ColorFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                TweenService:Create(PickerFrame, TweenInfo.new(0.2), {Size = toggled and UDim2.new(1, 0, 0, 190) or UDim2.new(1, 0, 0, 0)}):Play()
            end)

            ColorFrame.MouseEnter:Connect(function()
                if not toggled then
                    TweenService:Create(ColorStroke, TweenInfo.new(0.2), {Color = theme.Accent}):Play()
                end
            end)

            ColorFrame.MouseLeave:Connect(function()
                if not toggled then
                    TweenService:Create(ColorStroke, TweenInfo.new(0.2), {Color = theme.Outline}):Play()
                end
            end)

            return ColorFrame
        end

        function Tab:CopyLabel(text, content)
            local Frame = Instance.new("Frame", TabContent)
            Frame.Name = "CopyLabel"
            Frame.Size = UDim2.new(1, 0, 0, 30)
            Frame.BackgroundTransparency = 1
            Frame.ZIndex = 4

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.65, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text or ""
            Label.TextColor3 = theme.Text
            Label.Font = Library.GlobalConfig.Font
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 5

            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(0.32, 0, 0.8, 0)
            Btn.Position = UDim2.new(0.68, 0, 0.1, 0)
            Btn.BackgroundColor3 = theme.Accent
            Btn.Text = "Copy"
            Btn.TextColor3 = theme.Main
            Btn.Font = Library.GlobalConfig.BoldFont
            Btn.TextSize = 11
            Btn.AutoButtonColor = false
            Btn.ZIndex = 5
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Text}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}):Play()
            end)

            Btn.Activated:Connect(function()
                if setclipboard then
                    setclipboard(content or text or "")
                    Btn.Text = "Copied!"
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
                    task.wait(1.5)
                    Btn.Text = "Copy"
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}):Play()
                end
            end)

            return Frame
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then Tab:Select() end

        return Tab
    end

    TweenService:Create(Main, TweenInfo.new(Library.TweenSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = Window.Config.Size}):Play()

    table.insert(Library.Windows, Window)
    return Window
end

return Library
