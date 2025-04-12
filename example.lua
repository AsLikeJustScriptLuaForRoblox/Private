-- Load the DeltaLib library
local DeltaLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AsLikeJustScriptLuaForRoblox/Private/refs/heads/main/Gui%20Libary.lua"))()

-- Create a window
local Window = DeltaLib:CreateWindow("DeltaLib Complete Example", UDim2.new(0, 550, 0, 400))

-- Set up user profile (optional)
local UserProfile = Window:AddUserProfile()

-- Create tabs
local HomeTab = Window:CreateTab("Home")
local ControlsTab = Window:CreateTab("Controls")
local DropdownTab = Window:CreateTab("Dropdowns")
local SettingsTab = Window:CreateTab("Settings")
local CreditsTab = Window:CreateTab("Credits")

-- HOME TAB
local WelcomeSection = HomeTab:CreateSection("Welcome")
WelcomeSection:AddLabel("Welcome to DeltaLib UI Library Example")
WelcomeSection:AddLabel("Explore the tabs to see all available features")

local StatusSection = HomeTab:CreateSection("Status")
local StatusLabel = StatusSection:AddLabel("Status: Ready")

StatusSection:AddButton("Update Status", function()
    StatusLabel:SetText("Status: Active - " .. os.date("%H:%M:%S"))
end)

-- CONTROLS TAB
local ButtonsSection = ControlsTab:CreateSection("Buttons")

-- Button examples
ButtonsSection:AddButton("Simple Button", function()
    print("Simple button clicked")
    StatusLabel:SetText("Status: Simple button clicked")
end)

ButtonsSection:AddButton("Change Username", function()
    UserProfile.SetDisplayName("Modified User")
    StatusLabel:SetText("Status: Username changed")
end)

-- Toggle section
local TogglesSection = ControlsTab:CreateSection("Toggles")

-- Toggle examples
local NotificationsEnabled = TogglesSection:AddToggle("Enable Notifications", true, function(enabled)
    print("Notifications enabled:", enabled)
    StatusLabel:SetText("Status: Notifications " .. (enabled and "Enabled" or "Disabled"))
end)

TogglesSection:AddToggle("Debug Mode", false, function(enabled)
    print("Debug mode:", enabled)
    StatusLabel:SetText("Status: Debug mode " .. (enabled and "Enabled" or "Disabled"))
end)

-- Button to control toggle
TogglesSection:AddButton("Toggle Notifications", function()
    local currentState = NotificationsEnabled:GetState()
    NotificationsEnabled:SetState(not currentState)
end)

-- Slider section
local SlidersSection = ControlsTab:CreateSection("Sliders")

-- Slider examples
local VolumeSlider = SlidersSection:AddSlider("Volume", 0, 100, 50, function(value)
    print("Volume set to:", value)
    StatusLabel:SetText("Status: Volume set to " .. value .. "%")
end)

SlidersSection:AddSlider("Opacity", 0, 100, 100, function(value)
    print("Opacity set to:", value)
    StatusLabel:SetText("Status: Opacity set to " .. value .. "%")
end)

-- Button to control slider
SlidersSection:AddButton("Set Volume to 75", function()
    VolumeSlider:SetValue(75)
end)

-- TextBox section
local TextBoxSection = ControlsTab:CreateSection("TextBoxes")

-- TextBox examples
local UsernameBox = TextBoxSection:AddTextBox("Username", "Enter username...", "", function(text, enterPressed)
    if enterPressed and text ~= "" then
        print("Username set to:", text)
        UserProfile.SetDisplayName(text)
        StatusLabel:SetText("Status: Username updated to " .. text)
    end
end)

TextBoxSection:AddTextBox("Message", "Enter message...", "", function(text, enterPressed)
    if enterPressed then
        print("Message:", text)
        StatusLabel:SetText("Status: Message sent")
    end
end)

-- Button to control textbox
TextBoxSection:AddButton("Set Username to 'TestUser'", function()
    UsernameBox:SetText("TestUser")
end)

-- DROPDOWN TAB (Showcasing the updated dropdown component)
local BasicDropdownSection = DropdownTab:CreateSection("Basic Dropdowns")

-- Basic dropdown example
local fruits = {"Apple", "Banana", "Cherry", "Orange", "Grape"}
local fruitDropdown = BasicDropdownSection:AddDropdown("Select Fruit", fruits, "Apple", function(selected)
    print("Selected fruit:", selected)
    StatusLabel:SetText("Status: Selected fruit - " .. selected)
end)

-- Buttons to demonstrate dropdown functions
BasicDropdownSection:AddButton("Get Selected Fruit", function()
    local currentFruit = fruitDropdown:GetValue()
    print("Current fruit:", currentFruit)
    StatusLabel:SetText("Status: Current fruit - " .. currentFruit)
end)

BasicDropdownSection:AddButton("Select Orange", function()
    fruitDropdown:SetValue("Orange")
    print("Set value to Orange")
    StatusLabel:SetText("Status: Set fruit to Orange")
end)

-- Advanced dropdown section
local AdvancedDropdownSection = DropdownTab:CreateSection("Advanced Dropdowns")

-- Dynamic dropdown example
local dynamicOptions = {"Option 1"}
local dynamicDropdown = AdvancedDropdownSection:AddDropdown("Dynamic Options", dynamicOptions, "Option 1", function(selected)
    print("Selected dynamic option:", selected)
    StatusLabel:SetText("Status: Selected option - " .. selected)
end)

-- Buttons to modify the dropdown
AdvancedDropdownSection:AddButton("Add Option", function()
    local newOption = "Option " .. (#dynamicOptions + 1)
    table.insert(dynamicOptions, newOption)
    dynamicDropdown:Refresh(dynamicOptions, dynamicDropdown:GetValue())
    print("Added new option:", newOption)
    StatusLabel:SetText("Status: Added option - " .. newOption)
end)

AdvancedDropdownSection:AddButton("Remove Last Option", function()
    if #dynamicOptions > 1 then
        local removed = table.remove(dynamicOptions)
        local currentValue = dynamicDropdown:GetValue()
        
        -- If the current value was removed, select the first option
        if currentValue == removed then
            currentValue = dynamicOptions[1]
        end
        
        dynamicDropdown:Refresh(dynamicOptions, currentValue)
        print("Removed option:", removed)
        StatusLabel:SetText("Status: Removed option - " .. removed)
    else
        print("Cannot remove the last option")
        StatusLabel:SetText("Status: Cannot remove the last option")
    end
end)

AdvancedDropdownSection:AddButton("Change All Options", function()
    local newOptions = {"New A", "New B", "New C"}
    dynamicOptions = newOptions
    dynamicDropdown:Refresh(newOptions, "New A")
    print("Changed all options")
    StatusLabel:SetText("Status: Changed all options")
end)

-- Error handling dropdown section
local ErrorHandlingSection = DropdownTab:CreateSection("Error Handling")

-- Example with empty options
ErrorHandlingSection:AddButton("Create Empty Dropdown", function()
    local emptyDropdown = ErrorHandlingSection:AddDropdown("Empty Dropdown", {}, nil, function(selected)
        print("Selected from empty dropdown:", selected)
        StatusLabel:SetText("Status: Selected from empty dropdown - " .. selected)
    end)
end)

-- Example with non-table options
ErrorHandlingSection:AddButton("Create Invalid Dropdown", function()
    local invalidDropdown = ErrorHandlingSection:AddDropdown("Invalid Options", "Not a table", nil, function(selected)
        print("Selected from invalid dropdown:", selected)
        StatusLabel:SetText("Status: Selected from invalid dropdown - " .. selected)
    end)
end)

-- Example with error in callback
ErrorHandlingSection:AddDropdown("Error Callback", {"Option1", "Option2"}, "Option1", function(selected)
    -- This error will be caught and won't break the UI
    error("Intentional error in callback")
    print("This line won't execute")
end)

-- Example with invalid value setting
local testDropdown = ErrorHandlingSection:AddDropdown("Test Dropdown", {"Test1", "Test2", "Test3"}, "Test1", function(selected)
    print("Selected test option:", selected)
    StatusLabel:SetText("Status: Selected test option - " .. selected)
end)

ErrorHandlingSection:AddButton("Set Invalid Value", function()
    -- This will show a warning but won't break the script
    testDropdown:SetValue("NonExistentOption")
    StatusLabel:SetText("Status: Attempted to set invalid value")
end)

-- SETTINGS TAB
local TextScalingSection = SettingsTab:CreateSection("Text Scaling")

-- Toggle for text scaling
TextScalingSection:AddToggle("Enable Text Scaling", true, function(enabled)
    if enabled then
        Window.TextScaling.Enable()
    else
        Window.TextScaling.Disable()
    end
    print("Text scaling enabled:", enabled)
    StatusLabel:SetText("Status: Text scaling " .. (enabled and "enabled" or "disabled"))
end)

-- Slider for minimum text size
TextScalingSection:AddSlider("Min Text Size", 8, 16, 8, function(value)
    Window.TextScaling.SetMinTextSize(value)
    print("Min text size set to:", value)
    StatusLabel:SetText("Status: Min text size set to " .. value)
end)

-- Slider for maximum text size
TextScalingSection:AddSlider("Max Text Size", 16, 36, 36, function(value)
    Window.TextScaling.SetMaxTextSize(value)
    print("Max text size set to:", value)
    StatusLabel:SetText("Status: Max text size set to " .. value)
end)

-- Button to update all text
TextScalingSection:AddButton("Update All Text", function()
    Window.TextScaling.UpdateAllText()
    print("Updated all text scaling")
    StatusLabel:SetText("Status: Updated all text scaling")
end)

-- Appearance section
local AppearanceSection = SettingsTab:CreateSection("Appearance")

-- Dropdown for theme selection (just for demonstration)
local themeOptions = {"Default", "Dark", "Light", "Neon", "Custom"}
AppearanceSection:AddDropdown("Theme", themeOptions, "Default", function(selected)
    print("Theme selected:", selected)
    StatusLabel:SetText("Status: Theme changed to " .. selected)
    -- In a real implementation, you would change the theme colors here
end)

-- CREDITS TAB
local CreditsSection = CreditsTab:CreateSection("Credits")
CreditsSection:AddLabel("DeltaLib UI Library")
CreditsSection:AddLabel("Created by: Your Name")
CreditsSection:AddLabel("Version: 1.0.0")

local LinksSection = CreditsTab:CreateSection("Links")
LinksSection:AddButton("GitHub Repository", function()
    -- In a real script, you might open a URL or copy to clipboard
    print("Opening GitHub repository...")
    StatusLabel:SetText("Status: Opening GitHub repository...")
end)

LinksSection:AddButton("Discord Server", function()
    print("Opening Discord server...")
    StatusLabel:SetText("Status: Opening Discord server...")
end)

-- Final status update
StatusLabel:SetText("Status: All examples loaded successfully!")

print("DeltaLib complete example loaded successfully!")

