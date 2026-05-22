local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SairyTheKing/SairyLibrary/main/main.lua"))()

local Window = Library:CreateWindow("SairyLibrary Showcase")

local Tab1 = Window:CreateTab("Home")
local Tab2 = Window:CreateTab("Controls")
local Tab3 = Window:CreateTab("Themes")

Tab1:Select()

Tab1:Label("Welcome to SairyLibrary!")
Tab1:Label("Modern UI with beautiful animations", {Color = Color3.fromRGB(255, 100, 150), Bold = true, Size = 14})

Tab1:Button("Notify Me", function()
	Library:Notify("Success!", "This is a notification", 3)
end)

Tab1:Button("Another Action", function()
	Library:Notify("Action Triggered", "Button was clicked!", 3)
end)

Tab1:Label("", {Height = 10})

Tab2:Button("Test Button 1", function()
	print("Button 1 clicked")
end)

Tab2:Button("Test Button 2", function()
	print("Button 2 clicked")
end)

local toggle1 = Tab2:Toggle("Feature Enabled", false, function(state)
	print("Toggle state:", state)
end)

local toggle2 = Tab2:Toggle("Advanced Mode", true, function(state)
	print("Advanced mode:", state)
end)

local slider1 = Tab2:Slider("Brightness", 0, 100, 50, function(value)
	print("Brightness:", value)
end)

local slider2 = Tab2:Slider("Volume", 0, 50, 25, function(value)
	print("Volume:", value)
end)

local dropdown1 = Tab2:Dropdown("Select Option", {"Option 1", "Option 2", "Option 3"}, function(item)
	print("Selected:", item)
end)

local textbox1 = Tab2:Textbox("Enter Text", "", function(text)
	print("Text entered:", text)
end)

Tab3:Button("Dark Theme", function()
	Library:SetTheme("Dark")
	Library:Notify("Theme Changed", "Dark theme applied", 2)
end)

Tab3:Button("Aurora Theme", function()
	Library:SetTheme("Aurora")
	Library:Notify("Theme Changed", "Aurora theme applied", 2)
end)

Tab3:Button("Nebula Theme", function()
	Library:SetTheme("Nebula")
	Library:Notify("Theme Changed", "Nebula theme applied", 2)
end)

Tab3:Button("Eclipse Theme", function()
	Library:SetTheme("Eclipse")
	Library:Notify("Theme Changed", "Eclipse theme applied", 2)
end)

Tab3:Label("", {Height = 10})
Tab3:Label("All themes include smooth animations and modern design!")
