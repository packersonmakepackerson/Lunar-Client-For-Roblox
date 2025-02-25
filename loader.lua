-- Check for Executor Compatibility
local parentGui = gethui and gethui() or game.CoreGui

-- Create ScreenGui
local LunarUI = Instance.new("ScreenGui")
LunarUI.Name = "LunarUI"
LunarUI.Parent = parentGui
LunarUI.ResetOnSpawn = false

-- UI Blur Effect for Glassmorphism
local blur = Instance.new("BlurEffect")
blur.Size = 20
blur.Parent = game.Lighting

-- Main UI Frame (Smaller Size)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = LunarUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Make UI Draggable
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Top Navigation Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local UICornerTopBar = Instance.new("UICorner")
UICornerTopBar.CornerRadius = UDim.new(0, 15)
UICornerTopBar.Parent = TopBar

-- Lunar Client Logo
local LunarLogo = Instance.new("TextLabel")
LunarLogo.Size = UDim2.new(0, 120, 1, 0)
LunarLogo.Position = UDim2.new(0, 10, 0, 0)
LunarLogo.BackgroundTransparency = 1
LunarLogo.Text = "LUNAR CLIENT"
LunarLogo.TextColor3 = Color3.fromRGB(255, 200, 50)
LunarLogo.TextSize = 20
LunarLogo.Font = Enum.Font.GothamBold
LunarLogo.TextXAlignment = Enum.TextXAlignment.Left
LunarLogo.Parent = TopBar

-- Mods Section
local ModsFrame = Instance.new("Frame")
ModsFrame.Size = UDim2.new(1, -20, 0, 200)
ModsFrame.Position = UDim2.new(0, 10, 0, 50)
ModsFrame.BackgroundTransparency = 1
ModsFrame.Parent = MainFrame

local mods = {
    {name = "FPS", enabled = false},
    {name = "Ping", enabled = false},
    {name = "Keystrokes", enabled = false}
}

local function createToggle(mod, index)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 150, 0, 40)
    Toggle.Position = UDim2.new(0, 10, 0, index * 50)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Toggle.Text = mod.name .. ": OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextSize = 14
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Parent = ModsFrame

    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(0, 10)
    UICornerToggle.Parent = Toggle

    Toggle.MouseButton1Click:Connect(function()
        mod.enabled = not mod.enabled
        Toggle.Text = mod.name .. (mod.enabled and ": ON" or ": OFF")
        Toggle.BackgroundColor3 = mod.enabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(35, 35, 35)

        -- Apply effects for mods
        if mod.name == "FPS" then
            print("FPS Mod toggled:", mod.enabled)
        elseif mod.name == "Ping" then
            print("Ping Mod toggled:", mod.enabled)
        elseif mod.name == "Keystrokes" then
            print("Keystrokes Mod toggled:", mod.enabled)
        end
    end)
end

for i, mod in pairs(mods) do
    createToggle(mod, i)
end

-- Profile Saving Button
local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(0, 150, 0, 40)
SaveButton.Position = UDim2.new(0, 10, 0, 250)
SaveButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SaveButton.Text = "Save Profile"
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.TextSize = 14
SaveButton.Font = Enum.Font.GothamBold
SaveButton.Parent = MainFrame

local UICornerSave = Instance.new("UICorner")
UICornerSave.CornerRadius = UDim.new(0, 10)
UICornerSave.Parent = SaveButton

-- Save Profile
SaveButton.MouseButton1Click:Connect(function()
    local data = {}
    for _, mod in pairs(mods) do
        table.insert(data, {name = mod.name, enabled = mod.enabled})
    end
    writefile("LunarProfile.json", game:GetService("HttpService"):JSONEncode(data))
    print("Profile Saved!")
end)

-- Load Profile
if isfile("LunarProfile.json") then
    local data = game:GetService("HttpService"):JSONDecode(readfile("LunarProfile.json"))
    for _, mod in pairs(mods) do
        for _, savedMod in pairs(data) do
            if mod.name == savedMod.name then
                mod.enabled = savedMod.enabled
            end
        end
    end
    print("Profile Loaded!")
end

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -45, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 10)
UICornerClose.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    LunarUI.Enabled = false
    blur:Destroy()
end)

-- CPS Mod Implementation
local CPSLabel = Instance.new("TextLabel")
CPSLabel.Size = UDim2.new(0, 100, 0, 30)
CPSLabel.Position = UDim2.new(1, -110, 0, 10)
CPSLabel.BackgroundTransparency = 1
CPSLabel.Text = "CPS: 0"
CPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CPSLabel.TextSize = 14
CPSLabel.Font = Enum.Font.GothamBold
CPSLabel.TextXAlignment = Enum.TextXAlignment.Left
CPSLabel.Parent = LunarUI

local lastClickTime = tick()
local clickCount = 0

local function updateCPS()
    local currentTime = tick()
    if currentTime - lastClickTime < 1 then
        clickCount = clickCount + 1
    else
        clickCount = 0
    end
    lastClickTime = currentTime
    CPSLabel.Text = "CPS: " .. tostring(clickCount)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
        updateCPS()
    end
end)
