local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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
    CurrentTheme = nil
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

function Library:CreateTheme(name, colors)
    if not colors or not colors.Main or not colors.Accent or not colors.Outline or not colors.Text or not colors.Secondary then
        error("Theme must include Main, Accent, Outline, Text, Secondary")
    end
    Library.Themes[name] = colors
end

local notificationGui = nil

function Library:Notify(title, text, duration, iconName, position)
    if not notificationGui then
        notificationGui = Instance.new("ScreenGui")
        notificationGui.Name = "Voidseen_Notifications"
        notificationGui.ResetOnSpawn = false
        notificationGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    end
    local theme = Library.CurrentTheme
    position = position or "TopRight"
    duration = duration or 3
    local anchorPoint, startPos, endPos, outPos
    if position == "TopRight" then
        anchorPoint = Vector2.new(1, 0)
        startPos = UDim2.new(1, 0, 0, 10)
        endPos = UDim2.new(1, -10, 0, 10)
        outPos = UDim2.new(1, 0, 0, 10)
    elseif position == "TopLeft" then
        anchorPoint = Vector2.new(0, 0)
        startPos = UDim2.new(0, -210, 0, 10)
        endPos = UDim2.new(0, 10, 0, 10)
        outPos = UDim2.new(0, -210, 0, 10)
    elseif position == "BottomRight" then
        anchorPoint = Vector2.new(1, 1)
        startPos = UDim2.new(1, 0, 1, -10)
        endPos = UDim2.new(1, -10, 1, -10)
        outPos = UDim2.new(1, 0, 1, -10)
    elseif position == "BottomLeft" then
        anchorPoint = Vector2.new(0, 1)
        startPos = UDim2.new(0, -210, 1, -10)
        endPos = UDim2.new(0, 10, 1, -10)
        outPos = UDim2.new(0, -210, 1, -10)
    else
        anchorPoint = Vector2.new(1, 0)
        startPos = UDim2.new(1, 0, 0, 10)
        endPos = UDim2.new(1, -10, 0, 10)
        outPos = UDim2.new(1, 0, 0, 10)
    end

    local frame = Instance.new("Frame", notificationGui)
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.Position = startPos
    frame.AnchorPoint = anchorPoint
    frame.BackgroundColor3 = theme.Main
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = theme.Outline
    stroke.Thickness = 1

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -8, 0, 20)
    titleLabel.Position = UDim2.new(0, 4, 0, 2)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or ""
    titleLabel.TextColor3 = theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, -8, 0, 30)
    textLabel.Position = UDim2.new(0, 4, 0, 24)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or ""
    textLabel.TextColor3 = theme.Text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 11
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true

    if iconName and Library.Icons[iconName] then
        local icon = Instance.new("ImageLabel", frame)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(1, -24, 0, 4)
        icon.BackgroundTransparency = 1
        icon.Image = Library.Icons[iconName]
        icon.ImageColor3 = theme.Text
    end

    TweenService:Create(frame, TweenInfo.new(0.3), {Position = endPos}):Play()

    task.delay(duration, function()
        local tween = TweenService:Create(frame, TweenInfo.new(0.3), {Position = outPos})
        tween:Play()
        tween.Completed:Wait()
        frame:Destroy()
    end)
end

function Library:CreateWindow(title, iconName, config)
    config = config or {}
    local winTheme
    if config.Theme then
        if type(config.Theme) == "string" then
            winTheme = Library.Themes[config.Theme] or Library.CurrentTheme
        elseif type(config.Theme) == "table" then
            winTheme = config.Theme
        end
    end
    winTheme = winTheme or Library.CurrentTheme

    local size = config.Size or UDim2.new(0, 210, 0, 280)
    local position = config.Position or UDim2.new(0.5, -105, 0.5, -140)
    local draggable = config.Draggable ~= false
    local titleBarHeight = config.TitleBarHeight or 35
    local parent = config.Parent or (gethui and gethui() or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Voidseen_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = parent

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = size
    Main.Position = position
    Main.BackgroundColor3 = winTheme.Main
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = draggable
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = winTheme.Outline
    Stroke.Thickness = 1

    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
    TitleBar.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel", TitleBar)
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = (iconName and Library.Icons[iconName] and "        " or "  ") .. title
    TitleLabel.TextColor3 = winTheme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13

    if iconName and Library.Icons[iconName] then
        local TitleIcon = Instance.new("ImageLabel", TitleBar)
        TitleIcon.Size = UDim2.new(0, 16, 0, 16)
        TitleIcon.Position = UDim2.new(0, 8, 0.5, -8)
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.Image = Library.Icons[iconName]
        TitleIcon.ImageColor3 = winTheme.Text
    end

    local CloseBtn = Instance.new("TextButton", TitleBar)
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
    CloseBtn.BackgroundColor3 = winTheme.Secondary
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = winTheme.Text
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.Gotham
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
    local cStroke = Instance.new("UIStroke", CloseBtn)
    cStroke.Color = winTheme.Outline
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    TabBar.Position = UDim2.new(0, 0, 0, titleBarHeight)
    TabBar.BackgroundTransparency = 1
    local TabBarLayout = Instance.new("UIListLayout", TabBar)
    TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    TabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local TabContent = Instance.new("Frame", Main)
    TabContent.Size = UDim2.new(1, 0, 1, -titleBarHeight - 30)
    TabContent.Position = UDim2.new(0, 0, 0, titleBarHeight + 30)
    TabContent.BackgroundTransparency = 1
    TabContent.ClipsDescendants = true

    local Tabs = {}
    local ActiveTab = nil

    local Window = {}

    function Window:SetTheme(theme)
        if type(theme) == "string" then
            theme = Library.Themes[theme] or winTheme
        end
        if type(theme) == "table" then
            winTheme = theme
        end
    end

    function Window:CreateTab(tabName, iconName)
        local TabButton = Instance.new("TextButton", TabBar)
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.BackgroundColor3 = winTheme.Secondary
        TabButton.Text = ""
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 11
        TabButton.TextColor3 = winTheme.Text
        TabButton.AutoButtonColor = false
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)
        local btnStroke = Instance.new("UIStroke", TabButton)
        btnStroke.Color = winTheme.Outline

        if iconName and Library.Icons[iconName] then
            local icon = Instance.new("ImageLabel", TabButton)
            icon.Size = UDim2.new(0, 20, 0, 20)
            icon.Position = UDim2.new(0.5, -10, 0.15, 0)
            icon.BackgroundTransparency = 1
            icon.Image = Library.Icons[iconName]
            icon.ImageColor3 = winTheme.Text
            local label = Instance.new("TextLabel", TabButton)
            label.Size = UDim2.new(1, 0, 0, 12)
            label.Position = UDim2.new(0, 0, 0.65, 0)
            label.BackgroundTransparency = 1
            label.Text = tabName
            label.TextColor3 = winTheme.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 10
            label.TextWrapped = true
        else
            TabButton.Text = tabName
        end

        local TabPage = Instance.new("Frame", TabContent)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false

        local Container = Instance.new("ScrollingFrame", TabPage)
        Container.Size = UDim2.new(1, -14, 1, 0)
        Container.Position = UDim2.new(0, 7, 0, 0)
        Container.BackgroundTransparency = 1
        Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Container.ScrollBarThickness = 0
        local Layout = Instance.new("UIListLayout", Container)
        Layout.Padding = UDim.new(0, 6)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder

        local function updateTabSizes()
            local count = #Tabs + 1
            for _, tabData in ipairs(Tabs) do
                tabData.Button.Size = UDim2.new(1/count, -2, 1, 0)
            end
            TabButton.Size = UDim2.new(1/count, -2, 1, 0)
        end
        updateTabSizes()

        local tabData = {
            Button = TabButton,
            Page = TabPage,
            Container = Container,
            Theme = winTheme
        }
        table.insert(Tabs, tabData)

        TabButton.MouseButton1Click:Connect(function()
            if ActiveTab then
                ActiveTab.Page.Visible = false
                ActiveTab.Button.BackgroundColor3 = winTheme.Secondary
            end
            ActiveTab = tabData
            TabPage.Visible = true
            TabButton.BackgroundColor3 = winTheme.Accent
        end)

        if not ActiveTab then
            ActiveTab = tabData
            TabPage.Visible = true
            TabButton.BackgroundColor3 = winTheme.Accent
        end

        local function createElements(container, theme)
            local Elements = {}

            function Elements:Label(text, config)
                local Label = Instance.new("TextLabel", container)
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = (config and config.TextSize) or 11
                Label.TextTransparency = (config and config.TextTransparency) or 0.4
                Label.TextXAlignment = (config and config.TextXAlignment) or Enum.TextXAlignment.Left
                return Label
            end

            function Elements:CopyLabel(text, content, config)
                local Frame = Instance.new("Frame", container)
                Frame.Size = UDim2.new(1, 0, 0, 28)
                Frame.BackgroundTransparency = 1
                local Label = Instance.new("TextLabel", Frame)
                Label.Size = UDim2.new(0.7, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local Btn = Instance.new("TextButton", Frame)
                Btn.Size = UDim2.new(0.28, 0, 0.8, 0)
                Btn.Position = UDim2.new(0.72, 0, 0.1, 0)
                Btn.BackgroundColor3 = theme.Accent
                Btn.Text = "Copy"
                Btn.TextColor3 = theme.Main
                Btn.Font = Enum.Font.GothamBold
                Btn.TextSize = 10
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                Btn.MouseButton1Click:Connect(function()
                    if setclipboard then
                        setclipboard(content or text)
                        Btn.Text = "Done!"
                        task.wait(1)
                        Btn.Text = "Copy"
                    end
                end)
                return Frame
            end

            function Elements:Button(text, iconName, callback, config)
                local Button = Instance.new("TextButton", container)
                Button.Size = UDim2.new(1, 0, 0, 30)
                Button.BackgroundColor3 = theme.Secondary
                Button.Text = (iconName and Library.Icons[iconName] and "       " or "") .. text
                Button.TextColor3 = theme.Text
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 12
                Button.TextXAlignment = Enum.TextXAlignment.Left
                Button.AutoButtonColor = false
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
                if config and config.Stroke then
                    local stroke = Instance.new("UIStroke", Button)
                    stroke.Color = theme.Outline
                end

                if iconName and Library.Icons[iconName] then
                    local Icon = Instance.new("ImageLabel", Button)
                    Icon.Size = UDim2.new(0, 16, 0, 16)
                    Icon.Position = UDim2.new(0, 8, 0.5, -8)
                    Icon.BackgroundTransparency = 1
                    Icon.Image = Library.Icons[iconName]
                    Icon.ImageColor3 = theme.Text
                end

                Button.MouseButton1Click:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = theme.Accent}):Play()
                    TweenService:Create(Button, TweenInfo.new(0.1), {TextColor3 = theme.Main}):Play()
                    task.wait(0.1)
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = theme.Secondary}):Play()
                    TweenService:Create(Button, TweenInfo.new(0.1), {TextColor3 = theme.Text}):Play()
                    if callback then callback() end
                end)

                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}):Play()
                    TweenService:Create(Button, TweenInfo.new(0.2), {TextColor3 = theme.Main}):Play()
                end)
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = theme.Secondary}):Play()
                    TweenService:Create(Button, TweenInfo.new(0.2), {TextColor3 = theme.Text}):Play()
                end)
                return Button
            end

            function Elements:Toggle(text, default, callback, config)
                default = default or false
                local ToggleFrame = Instance.new("Frame", container)
                ToggleFrame.Size = UDim2.new(1, 0, 0, 28)
                ToggleFrame.BackgroundTransparency = 1
                local Label = Instance.new("TextLabel", ToggleFrame)
                Label.Text = text
                Label.Size = UDim2.new(0.7, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.TextColor3 = theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local ToggleButton = Instance.new("TextButton", ToggleFrame)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(1, -42, 0.5, -10)
                ToggleButton.BackgroundColor3 = default and theme.Accent or theme.Secondary
                ToggleButton.Text = ""
                ToggleButton.AutoButtonColor = false
                Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)
                local ToggleCircle = Instance.new("Frame", ToggleButton)
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleCircle.BackgroundColor3 = theme.Main
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
                local on = default
                ToggleButton.MouseButton1Click:Connect(function()
                    on = not on
                    local goalPos = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = goalPos}):Play()
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = on and theme.Accent or theme.Secondary}):Play()
                    if callback then callback(on) end
                end)
                if callback then callback(on) end
                return ToggleFrame
            end

            function Elements:Slider(text, min, max, default, callback, config)
                local default = math.clamp(default or min, min, max)
                local step = (config and config.Step) or 1
                local suffix = (config and config.Suffix) or ""
                local SliderFrame = Instance.new("Frame", container)
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.BackgroundTransparency = 1
                local Label = Instance.new("TextLabel", SliderFrame)
                Label.Text = text
                Label.Size = UDim2.new(1, 0, 0, 18)
                Label.BackgroundTransparency = 1
                Label.TextColor3 = theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local ValLabel = Instance.new("TextLabel", SliderFrame)
                ValLabel.Text = tostring(default) .. suffix
                ValLabel.Size = UDim2.new(1, -5, 0, 18)
                ValLabel.BackgroundTransparency = 1
                ValLabel.TextColor3 = theme.Text
                ValLabel.Font = Enum.Font.Gotham
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.TextSize = 11
                local Bar = Instance.new("Frame", SliderFrame)
                Bar.Size = UDim2.new(1, -6, 0, 4)
                Bar.Position = UDim2.new(0, 3, 0, 26)
                Bar.BackgroundColor3 = theme.Secondary
                Instance.new("UICorner", Bar)
                local Fill = Instance.new("Frame", Bar)
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = theme.Accent
                Instance.new("UICorner", Fill)
                local Circle = Instance.new("Frame", Fill)
                Circle.Size = UDim2.new(0, 10, 0, 10)
                Circle.AnchorPoint = Vector2.new(0.5, 0.5)
                Circle.Position = UDim2.new(1, 0, 0.5, 0)
                Circle.BackgroundColor3 = theme.Accent
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
                local dragging = false
                local function updateFromInput(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local rawVal = ((max - min) * pos) + min
                    local val = math.floor(rawVal / step + 0.5) * step
                    val = math.clamp(val, min, max)
                    Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    ValLabel.Text = tostring(val) .. suffix
                    if callback then callback(val) end
                end
                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true updateFromInput(input) end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateFromInput(input) end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                if callback then callback(default) end
                return SliderFrame
            end

            function Elements:Dropdown(text, list, callback, config)
                local DropdownFrame = Instance.new("Frame", container)
                DropdownFrame.Size = UDim2.new(1, 0, 0, 28)
                DropdownFrame.BackgroundColor3 = theme.Secondary
                DropdownFrame.ClipsDescendants = true
                Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)

                local DropBtn = Instance.new("TextButton", DropdownFrame)
                DropBtn.Size = UDim2.new(1, 0, 0, 28)
                DropBtn.BackgroundTransparency = 1
                DropBtn.Text = text .. " +"
                DropBtn.TextColor3 = theme.Text
                DropBtn.Font = Enum.Font.Gotham
                DropBtn.TextSize = 12
                DropBtn.AutoButtonColor = false

                local SearchBox
                if config and config.Search then
                    SearchBox = Instance.new("TextBox", DropdownFrame)
                    SearchBox.Size = UDim2.new(1, -4, 0, 20)
                    SearchBox.Position = UDim2.new(0, 2, 0, 28)
                    SearchBox.BackgroundColor3 = theme.Main
                    SearchBox.Text = ""
                    SearchBox.PlaceholderText = "Search..."
                    SearchBox.PlaceholderColor3 = theme.Text:lerp(Color3.new(0,0,0), 0.5)
                    SearchBox.TextColor3 = theme.Text
                    SearchBox.Font = Enum.Font.Gotham
                    SearchBox.TextSize = 11
                    SearchBox.ClearTextOnFocus = false
                end

                local OptionScroll = Instance.new("ScrollingFrame", DropdownFrame)
                local scrollY = (config and config.Search and 20 or 0) + 28
                OptionScroll.Size = UDim2.new(1, 0, 0, 125)
                OptionScroll.Position = UDim2.new(0, 0, 0, scrollY)
                OptionScroll.BackgroundTransparency = 1
                OptionScroll.BorderSizePixel = 0
                OptionScroll.ScrollBarThickness = 2
                OptionScroll.ScrollBarImageColor3 = theme.Accent
                OptionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
                OptionScroll.Visible = false

                local OptionLayout = Instance.new("UIListLayout", OptionScroll)
                OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local optionButtons = {}
                local function rebuildOptions(filter)
                    for _, btn in pairs(optionButtons) do btn:Destroy() end
                    table.clear(optionButtons)
                    for _, v in ipairs(list) do
                        if not filter or string.find(string.lower(v), string.lower(filter), 1, true) then
                            local Option = Instance.new("TextButton", OptionScroll)
                            Option.Size = UDim2.new(1, 0, 0, 25)
                            Option.BackgroundTransparency = 1
                            Option.Text = v
                            Option.TextColor3 = theme.Text
                            Option.Font = Enum.Font.Gotham
                            Option.TextSize = 11
                            Option.MouseButton1Click:Connect(function()
                                toggled = false
                                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 28)}):Play()
                                OptionScroll.Visible = false
                                if SearchBox then SearchBox.Visible = false end
                                DropBtn.Text = text .. " +"
                                if callback then callback(v) end
                            end)
                            table.insert(optionButtons, Option)
                        end
                    end
                end
                rebuildOptions()

                local toggled = false
                DropBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    local contentHeight = math.min(#optionButtons * 25, 125)
                    local totalHeight = 28 + (SearchBox and 20 or 0) + (toggled and contentHeight or 0)
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                    if toggled then
                        OptionScroll.Visible = true
                        if SearchBox then SearchBox.Visible = true end
                    else
                        OptionScroll.Visible = false
                        if SearchBox then SearchBox.Visible = false end
                    end
                    DropBtn.Text = toggled and text .. " -" or text .. " +"
                end)

                if SearchBox then
                    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                        rebuildOptions(SearchBox.Text)
                        if toggled then
                            local contentHeight = math.min(#optionButtons * 25, 125)
                            local totalHeight = 28 + 20 + contentHeight
                            TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                        end
                    end)
                end
                return DropdownFrame
            end

            function Elements:MultiDropdown(text, list, callback, config)
                local MultiFrame = Instance.new("Frame", container)
                MultiFrame.Size = UDim2.new(1, 0, 0, 28)
                MultiFrame.BackgroundColor3 = theme.Secondary
                MultiFrame.ClipsDescendants = true
                Instance.new("UICorner", MultiFrame).CornerRadius = UDim.new(0, 4)

                local ToggleBtn = Instance.new("TextButton", MultiFrame)
                ToggleBtn.Size = UDim2.new(1, 0, 0, 28)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = text .. " (0)"
                ToggleBtn.TextColor3 = theme.Text
                ToggleBtn.Font = Enum.Font.Gotham
                ToggleBtn.TextSize = 12
                ToggleBtn.AutoButtonColor = false

                local SelectionScroll = Instance.new("ScrollingFrame", MultiFrame)
                SelectionScroll.Size = UDim2.new(1, 0, 0, 125)
                SelectionScroll.Position = UDim2.new(0, 0, 0, 28)
                SelectionScroll.BackgroundTransparency = 1
                SelectionScroll.BorderSizePixel = 0
                SelectionScroll.ScrollBarThickness = 2
                SelectionScroll.ScrollBarImageColor3 = theme.Accent
                SelectionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
                SelectionScroll.Visible = false

                local SelLayout = Instance.new("UIListLayout", SelectionScroll)
                SelLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local selected = {}
                local toggled = false

                local function updateSelected()
                    local count = 0
                    for _, v in pairs(selected) do if v then count = count + 1 end end
                    ToggleBtn.Text = text .. " (" .. count .. ")"
                    if callback then callback(selected) end
                end

                for _, v in ipairs(list) do
                    local OptFrame = Instance.new("Frame", SelectionScroll)
                    OptFrame.Size = UDim2.new(1, 0, 0, 25)
                    OptFrame.BackgroundTransparency = 1
                    local Check = Instance.new("TextButton", OptFrame)
                    Check.Size = UDim2.new(0, 20, 0, 20)
                    Check.Position = UDim2.new(0, 4, 0.5, -10)
                    Check.Text = ""
                    Check.BackgroundColor3 = theme.Secondary
                    Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 3)
                    local CheckMark = Instance.new("TextLabel", Check)
                    CheckMark.Size = UDim2.new(1, 0, 1, 0)
                    CheckMark.BackgroundTransparency = 1
                    CheckMark.Text = "✓"
                    CheckMark.TextColor3 = theme.Text
                    CheckMark.TextSize = 16
                    CheckMark.Visible = false
                    local OptLabel = Instance.new("TextButton", OptFrame)
                    OptLabel.Size = UDim2.new(1, -30, 1, 0)
                    OptLabel.Position = UDim2.new(0, 28, 0, 0)
                    OptLabel.BackgroundTransparency = 1
                    OptLabel.Text = v
                    OptLabel.TextColor3 = theme.Text
                    OptLabel.Font = Enum.Font.Gotham
                    OptLabel.TextSize = 11
                    OptLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local isSel = false
                    selected[v] = false
                    local function toggleSel()
                        isSel = not isSel
                        selected[v] = isSel
                        CheckMark.Visible = isSel
                        TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = isSel and theme.Accent or theme.Secondary}):Play()
                        updateSelected()
                    end
                    Check.MouseButton1Click:Connect(toggleSel)
                    OptLabel.MouseButton1Click:Connect(toggleSel)
                end

                ToggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    local contentHeight = math.min(#list * 25, 125)
                    local totalHeight = 28 + (toggled and contentHeight or 0)
                    TweenService:Create(MultiFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                    SelectionScroll.Visible = toggled
                end)

                return MultiFrame
            end

            function Elements:Textbox(text, default, callback, config)
                local TextboxFrame = Instance.new("Frame", container)
                TextboxFrame.Size = UDim2.new(1, 0, 0, 28)
                TextboxFrame.BackgroundTransparency = 1
                local Label = Instance.new("TextLabel", TextboxFrame)
                Label.Text = text
                Label.Size = UDim2.new(0.4, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.TextColor3 = theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local Box = Instance.new("TextBox", TextboxFrame)
                Box.Size = UDim2.new(0.58, 0, 1, 0)
                Box.Position = UDim2.new(0.42, 0, 0, 0)
                Box.BackgroundColor3 = theme.Secondary
                Box.Text = default or ""
                Box.PlaceholderText = (config and config.Placeholder) or ""
                Box.PlaceholderColor3 = theme.Text:lerp(Color3.new(0,0,0), 0.5)
                Box.TextColor3 = theme.Text
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 11
                Box.ClearTextOnFocus = false
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
                Box.FocusLost:Connect(function(enterPressed)
                    if callback then callback(Box.Text, enterPressed) end
                end)
                if callback then callback(Box.Text) end
                return TextboxFrame
            end

            function Elements:Keybind(text, defaultKey, callback, config)
                local KeyFrame = Instance.new("Frame", container)
                KeyFrame.Size = UDim2.new(1, 0, 0, 28)
                KeyFrame.BackgroundTransparency = 1
                local Label = Instance.new("TextLabel", KeyFrame)
                Label.Text = text
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.TextColor3 = theme.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                local Btn = Instance.new("TextButton", KeyFrame)
                Btn.Size = UDim2.new(0.38, 0, 1, 0)
                Btn.Position = UDim2.new(0.62, 0, 0, 0)
                Btn.BackgroundColor3 = theme.Secondary
                Btn.Text = (defaultKey and defaultKey ~= Enum.KeyCode.Unknown and defaultKey.Name) or "None"
                Btn.TextColor3 = theme.Text
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 11
                Btn.AutoButtonColor = false
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                local currentKey = defaultKey or Enum.KeyCode.Unknown
                local listening = false
                Btn.MouseButton1Click:Connect(function()
                    listening = true
                    Btn.Text = "..."
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if not listening then return end
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            conn:Disconnect()
                            if input.KeyCode == Enum.KeyCode.Escape then
                                currentKey = Enum.KeyCode.Unknown
                                Btn.Text = "None"
                            else
                                currentKey = input.KeyCode
                                Btn.Text = input.KeyCode.Name
                            end
                            if callback then callback(currentKey) end
                        end
                    end)
                end)
                return KeyFrame
            end

            function Elements:Colorpicker(text, defaultColor, callback, config)
                local CPFrame = Instance.new("Frame", container)
                CPFrame.Size = UDim2.new(1, 0, 0, 28)
                CPFrame.BackgroundColor3 = theme.Secondary
                CPFrame.ClipsDescendants = true
                Instance.new("UICorner", CPFrame).CornerRadius = UDim.new(0, 4)

                local ToggleBtn = Instance.new("TextButton", CPFrame)
                ToggleBtn.Size = UDim2.new(1, 0, 0, 28)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = text .. "     "
                ToggleBtn.TextColor3 = theme.Text
                ToggleBtn.Font = Enum.Font.Gotham
                ToggleBtn.TextSize = 12
                ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
                ToggleBtn.AutoButtonColor = false

                local ColorPreview = Instance.new("Frame", ToggleBtn)
                ColorPreview.Size = UDim2.new(0, 18, 0, 18)
                ColorPreview.Position = UDim2.new(1, -24, 0.5, -9)
                ColorPreview.BackgroundColor3 = defaultColor or Color3.new(1, 1, 1)
                Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", ColorPreview).Color = theme.Outline

                local PickerPanel = Instance.new("Frame", CPFrame)
                PickerPanel.Size = UDim2.new(1, 0, 0, 0)
                PickerPanel.Position = UDim2.new(0, 0, 0, 28)
                PickerPanel.BackgroundTransparency = 1
                PickerPanel.ClipsDescendants = true

                local HueFrame = Instance.new("Frame", PickerPanel)
                HueFrame.Size = UDim2.new(1, -4, 0, 20)
                HueFrame.Position = UDim2.new(0, 2, 0, 5)
                HueFrame.BackgroundColor3 = Color3.new(1, 1, 1)
                Instance.new("UICorner", HueFrame).CornerRadius = UDim.new(0, 3)
                local HueGradient = Instance.new("UIGradient", HueFrame)
                HueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,0,255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
                }
                HueGradient.Rotation = 90

                local HueSelector = Instance.new("Frame", HueFrame)
                HueSelector.Size = UDim2.new(0, 4, 1, 0)
                HueSelector.BackgroundColor3 = Color3.new(1,1,1)
                HueSelector.BorderSizePixel = 0
                HueSelector.Position = UDim2.new(0, 0, 0, 0)
                Instance.new("UICorner", HueSelector).CornerRadius = UDim.new(0, 1)

                local SVFrame = Instance.new("Frame", PickerPanel)
                SVFrame.Size = UDim2.new(1, -4, 0, 80)
                SVFrame.Position = UDim2.new(0, 2, 0, 30)
                SVFrame.BackgroundColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", SVFrame).CornerRadius = UDim.new(0, 3)
                local WhiteGradient = Instance.new("UIGradient", SVFrame)
                WhiteGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                    ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
                }
                WhiteGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }
                WhiteGradient.Rotation = 90
                local BlackGradient = Instance.new("UIGradient", SVFrame)
                BlackGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
                    ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
                }
                BlackGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                BlackGradient.Rotation = 0

                local SVSelector = Instance.new("Frame", SVFrame)
                SVSelector.Size = UDim2.new(0, 6, 0, 6)
                SVSelector.AnchorPoint = Vector2.new(0.5, 0.5)
                SVSelector.BackgroundColor3 = Color3.new(1,1,1)
                SVSelector.BorderSizePixel = 0
                Instance.new("UICorner", SVSelector).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", SVSelector).Color = Color3.new(0,0,0)

                local InputHolder = Instance.new("Frame", PickerPanel)
                InputHolder.Size = UDim2.new(1, -4, 0, 20)
                InputHolder.Position = UDim2.new(0, 2, 0, 115)
                InputHolder.BackgroundTransparency = 1

                local function createRGBInput(letter, posX)
                    local box = Instance.new("TextBox", InputHolder)
                    box.Size = UDim2.new(0, 30, 1, 0)
                    box.Position = UDim2.new(0, posX, 0, 0)
                    box.BackgroundColor3 = theme.Main
                    box.Text = "255"
                    box.PlaceholderText = letter
                    box.TextColor3 = theme.Text
                    box.Font = Enum.Font.Gotham
                    box.TextSize = 10
                    box.ClearTextOnFocus = false
                    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)
                    return box
                end
                local RBox = createRGBInput("R", 0)
                local GBox = createRGBInput("G", 34)
                local BBox = createRGBInput("B", 68)
                local HexBox = Instance.new("TextBox", InputHolder)
                HexBox.Size = UDim2.new(0, 50, 1, 0)
                HexBox.Position = UDim2.new(1, -52, 0, 0)
                HexBox.BackgroundColor3 = theme.Main
                HexBox.Text = "#FFFFFF"
                HexBox.PlaceholderText = "Hex"
                HexBox.TextColor3 = theme.Text
                HexBox.Font = Enum.Font.Gotham
                HexBox.TextSize = 10
                HexBox.ClearTextOnFocus = false
                Instance.new("UICorner", HexBox).CornerRadius = UDim.new(0, 3)

                local currentColor = defaultColor or Color3.new(1,1,1)
                local hue = 0
                local sat = 0
                local val = 1

                local function updateUIFromColor(color)
                    ColorPreview.BackgroundColor3 = color
                    local r,g,b = math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)
                    RBox.Text = tostring(r)
                    GBox.Text = tostring(g)
                    BBox.Text = tostring(b)
                    HexBox.Text = string.format("#%02X%02X%02X", r, g, b)
                    if callback then callback(color) end
                end

                local function updatePicker()
                    local hueColor = Color3.fromHSV(hue, 1, 1)
                    SVFrame.BackgroundColor3 = hueColor
                    HueSelector.Position = UDim2.new(hue, 0, 0, 0)
                    SVSelector.Position = UDim2.new(sat, 0, 1-val, 0)
                    local color = Color3.fromHSV(hue, sat, val)
                    currentColor = color
                    updateUIFromColor(color)
                end

                local h, s, v = Color3.toHSV(currentColor)
                hue, sat, val = h, s, v
                updatePicker()

                local hueDrag = false
                local svDrag = false

                HueFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDrag = true
                        local pos = (input.Position.X - HueFrame.AbsolutePosition.X) / HueFrame.AbsoluteSize.X
                        hue = math.clamp(pos, 0, 1)
                        updatePicker()
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if hueDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = (input.Position.X - HueFrame.AbsolutePosition.X) / HueFrame.AbsoluteSize.X
                        hue = math.clamp(pos, 0, 1)
                        updatePicker()
                    elseif svDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local posX = (input.Position.X - SVFrame.AbsolutePosition.X) / SVFrame.AbsoluteSize.X
                        local posY = (input.Position.Y - SVFrame.AbsolutePosition.Y) / SVFrame.AbsoluteSize.Y
                        sat = math.clamp(posX, 0, 1)
                        val = 1 - math.clamp(posY, 0, 1)
                        updatePicker()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDrag = false
                        svDrag = false
                    end
                end)

                SVFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        svDrag = true
                        local posX = (input.Position.X - SVFrame.AbsolutePosition.X) / SVFrame.AbsoluteSize.X
                        local posY = (input.Position.Y - SVFrame.AbsolutePosition.Y) / SVFrame.AbsoluteSize.Y
                        sat = math.clamp(posX, 0, 1)
                        val = 1 - math.clamp(posY, 0, 1)
                        updatePicker()
                    end
                end)

                local function fromRGBInputs()
                    local r = math.clamp(tonumber(RBox.Text) or 255, 0, 255)
                    local g = math.clamp(tonumber(GBox.Text) or 255, 0, 255)
                    local b = math.clamp(tonumber(BBox.Text) or 255, 0, 255)
                    local color = Color3.fromRGB(r, g, b)
                    currentColor = color
                    local h2, s2, v2 = Color3.toHSV(color)
                    hue, sat, val = h2, s2, v2
                    updatePicker()
                end

                RBox.FocusLost:Connect(fromRGBInputs)
                GBox.FocusLost:Connect(fromRGBInputs)
                BBox.FocusLost:Connect(fromRGBInputs)

                HexBox.FocusLost:Connect(function()
                    local hex = HexBox.Text
                    if string.sub(hex,1,1) ~= "#" then hex = "#"..hex end
                    if #hex == 7 then
                        local r = tonumber(string.sub(hex,2,3),16) or 255
                        local g = tonumber(string.sub(hex,4,5),16) or 255
                        local b = tonumber(string.sub(hex,6,7),16) or 255
                        local color = Color3.fromRGB(r,g,b)
                        currentColor = color
                        local h2,s2,v2 = Color3.toHSV(color)
                        hue,sat,val = h2,s2,v2
                        updatePicker()
                    end
                end)

                local toggled = false
                ToggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    local panelHeight = toggled and 140 or 0
                    TweenService:Create(CPFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 28 + panelHeight)}):Play()
                    TweenService:Create(PickerPanel, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, panelHeight)}):Play()
                end)

                return CPFrame
            end

            function Elements:Section(title, config)
                local SectionFrame = Instance.new("Frame", container)
                SectionFrame.Size = UDim2.new(1, 0, 0, 30)
                SectionFrame.BackgroundTransparency = 1
                local Line = Instance.new("Frame", SectionFrame)
                Line.Size = UDim2.new(1, 0, 0, 1)
                Line.Position = UDim2.new(0, 0, 0, 14)
                Line.BackgroundColor3 = theme.Accent
                local TextLabel = Instance.new("TextLabel", SectionFrame)
                TextLabel.Size = UDim2.new(0, 100, 0, 20)
                TextLabel.Position = UDim2.new(0, 5, 0, 5)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = title
                TextLabel.TextColor3 = theme.Text
                TextLabel.Font = Enum.Font.GothamBold
                TextLabel.TextSize = 12
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                return SectionFrame
            end

            function Elements:Collapsible(title, callback, config)
                local CollapseFrame = Instance.new("Frame", container)
                CollapseFrame.Size = UDim2.new(1, 0, 0, 28)
                CollapseFrame.BackgroundColor3 = theme.Secondary
                CollapseFrame.ClipsDescendants = true
                Instance.new("UICorner", CollapseFrame).CornerRadius = UDim.new(0, 4)

                local ToggleBtn = Instance.new("TextButton", CollapseFrame)
                ToggleBtn.Size = UDim2.new(1, 0, 0, 28)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = "▼ " .. title
                ToggleBtn.TextColor3 = theme.Text
                ToggleBtn.Font = Enum.Font.GothamBold
                ToggleBtn.TextSize = 12
                ToggleBtn.AutoButtonColor = false

                local InnerContainer = Instance.new("ScrollingFrame", CollapseFrame)
                InnerContainer.Size = UDim2.new(1, -4, 0, 0)
                InnerContainer.Position = UDim2.new(0, 2, 0, 28)
                InnerContainer.BackgroundTransparency = 1
                InnerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
                InnerContainer.ScrollBarThickness = 2
                InnerContainer.ScrollBarImageColor3 = theme.Accent
                InnerContainer.Visible = false
                local InnerLayout = Instance.new("UIListLayout", InnerContainer)
                InnerLayout.Padding = UDim.new(0, 4)
                InnerLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local InnerElements = createElements(InnerContainer, theme)

                local toggled = false
                local function updateSize()
                    local innerHeight = InnerContainer.AbsoluteCanvasSize.Y
                    local newHeight = 28 + (toggled and innerHeight or 0)
                    TweenService:Create(CollapseFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, newHeight)}):Play()
                    TweenService:Create(InnerContainer, TweenInfo.new(0.3), {Size = UDim2.new(1, -4, 0, toggled and innerHeight or 0)}):Play()
                end

                ToggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    ToggleBtn.Text = (toggled and "▲ " or "▼ ") .. title
                    InnerContainer.Visible = toggled
                    updateSize()
                    if callback then callback(toggled) end
                end)

                local wrappedElements = {}
                for k, v in pairs(InnerElements) do
                    if type(v) == "function" then
                        wrappedElements[k] = function(...)
                            local result = v(...)
                            if toggled then
                                updateSize()
                            end
                            return result
                        end
                    else
                        wrappedElements[k] = v
                    end
                end
                return wrappedElements
            end

            return Elements
        end

        local elements = createElements(Container, winTheme)
        return elements
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    return Window
end

return Library
