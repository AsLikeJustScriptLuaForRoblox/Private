--[[
    DeltaLib UI Library
    A customizable UI library for Roblox with dark neon red theme
    Features:
    - Moveable on PC and Android
    - Tabs and Sections
    - Labels and other UI elements
    - Responsive design
    - User Avatar Icon
]]

local DeltaLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

-- Colors
local Colors = {
    Background = Color3.fromRGB(25, 25, 25),
    DarkBackground = Color3.fromRGB(15, 15, 15),
    LightBackground = Color3.fromRGB(35, 35, 35),
    NeonRed = Color3.fromRGB(255, 0, 60),
    DarkNeonRed = Color3.fromRGB(200, 0, 45),
    LightNeonRed = Color3.fromRGB(255, 50, 90),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(50, 50, 50)
}

-- Utility Functions
local function MakeDraggable(frame, dragArea)
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local function updateInput(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

-- Get Player Avatar
local function GetPlayerAvatar(userId, size)
    size = size or "420x420"
    return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=" .. size:split("x")[1] .. "&height=" .. size:split("x")[2] .. "&format=png"
end

-- Create UI Elements
function DeltaLib:CreateWindow(title, size)
    local Window = {}
    size = size or UDim2.new(0, 500, 0, 350)
    
    -- Main GUI
    local DeltaLibGUI = Instance.new("ScreenGui")
    DeltaLibGUI.Name = "DeltaLibGUI"
    DeltaLibGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    DeltaLibGUI.ResetOnSpawn = false
    
    -- Try to parent to CoreGui if possible (for exploits)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(DeltaLibGUI)
            DeltaLibGUI.Parent = CoreGui
        elseif gethui then
            DeltaLibGUI.Parent = gethui()
        else
            DeltaLibGUI.Parent = CoreGui
        end
    end)
    
    if not DeltaLibGUI.Parent then
        DeltaLibGUI.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = size
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = DeltaLibGUI
    
    -- Add rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    -- Add shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 35, 1, 35)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Colors.NeonRed
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Colors.DarkBackground
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 6)
    TitleBarCorner.Parent = TitleBar
    
    local TitleBarCover = Instance.new("Frame")
    TitleBarCover.Name = "TitleBarCover"
    TitleBarCover.Size = UDim2.new(1, 0, 0.5, 0)
    TitleBarCover.Position = UDim2.new(0, 0, 0.5, 0)
    TitleBarCover.BackgroundColor3 = Colors.DarkBackground
    TitleBarCover.BorderSizePixel = 0
    TitleBarCover.Parent = TitleBar
    
    -- User Avatar
    local AvatarContainer = Instance.new("Frame")
    AvatarContainer.Name = "AvatarContainer"
    AvatarContainer.Size = UDim2.new(0, 24, 0, 24)
    AvatarContainer.Position = UDim2.new(0, 5, 0, 3)
    AvatarContainer.BackgroundColor3 = Colors.NeonRed
    AvatarContainer.BorderSizePixel = 0
    AvatarContainer.Parent = TitleBar
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = AvatarContainer
    
    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Name = "AvatarImage"
    AvatarImage.Size = UDim2.new(1, -2, 1, -2)
    AvatarImage.Position = UDim2.new(0, 1, 0, 1)
    AvatarImage.BackgroundTransparency = 1
    AvatarImage.Image = GetPlayerAvatar(Player.UserId, "100x100")
    AvatarImage.Parent = AvatarContainer
    
    local AvatarImageCorner = Instance.new("UICorner")
    AvatarImageCorner.CornerRadius = UDim.new(1, 0)
    AvatarImageCorner.Parent = AvatarImage
    
    -- Username
    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Name = "UsernameLabel"
    UsernameLabel.Size = UDim2.new(0, 150, 1, 0)
    UsernameLabel.Position = UDim2.new(0, 34, 0, 0)
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Text = Player.Name
    UsernameLabel.TextColor3 = Colors.Text
    UsernameLabel.TextSize = 14
    UsernameLabel.Font = Enum.Font.GothamSemibold
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.Parent = TitleBar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 190, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Delta UI"
    TitleLabel.TextColor3 = Colors.NeonRed
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -27, 0, 3)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "âœ•"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseEnter:Connect(function()
        CloseButton.TextColor3 = Colors.NeonRed
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CloseButton.TextColor3 = Colors.Text
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        DeltaLibGUI:Destroy()
    end)
    
    -- Make window draggable
    MakeDraggable(MainFrame, TitleBar)
    
    -- Container for tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 35)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Colors.LightBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    -- Tab Buttons Container
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, -10, 1, 0)
    TabButtons.Position = UDim2.new(0, 5, 0, 0)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = TabContainer
    
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsLayout.Padding = UDim.new(0, 5)
    TabButtonsLayout.Parent = TabButtons
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, -65)
    ContentContainer.Position = UDim2.new(0, 0, 0, 65)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Tab Management
    local Tabs = {}
    local SelectedTab = nil
    
    -- Create Tab Function
    function Window:CreateTab(tabName)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName.."Button"
        TabButton.Size = UDim2.new(0, TextService:GetTextSize(tabName, 14, Enum.Font.GothamSemibold, Vector2.new(math.huge, 20)).X + 20, 1, -10)
        TabButton.Position = UDim2.new(0, 0, 0, 0)
        TabButton.BackgroundColor3 = Colors.DarkBackground
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Colors.SubText
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Parent = TabButtons
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 4)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName.."Content"
        TabContent.Size = UDim2.new(1, -20, 1, -10)
        TabContent.Position = UDim2.new(0, 10, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Colors.NeonRed
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 10)
        TabContentLayout.Parent = TabContent
        
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingTop = UDim.new(0, 5)
        TabContentPadding.PaddingBottom = UDim.new(0, 5)
        TabContentPadding.Parent = TabContent
        
        -- Auto-size the scrolling frame content
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Selection Logic
        TabButton.MouseButton1Click:Connect(function()
            if SelectedTab then
                -- Deselect current tab
                SelectedTab.Button.BackgroundColor3 = Colors.DarkBackground
                SelectedTab.Button.TextColor3 = Colors.SubText
                SelectedTab.Content.Visible = false
            end
            
            -- Select new tab
            TabButton.BackgroundColor3 = Colors.NeonRed
            TabButton.TextColor3 = Colors.Text
            TabContent.Visible = true
            SelectedTab = {Button = TabButton, Content = TabContent}
        end)
        
        -- Add to tabs table
        table.insert(Tabs, {Button = TabButton, Content = TabContent})
        
        -- If this is the first tab, select it
        if #Tabs == 1 then
            TabButton.BackgroundColor3 = Colors.NeonRed
            TabButton.TextColor3 = Colors.Text
            TabContent.Visible = true
            SelectedTab = {Button = TabButton, Content = TabContent}
        end
        
        -- Section Creation Function
        function Tab:CreateSection(sectionName)
            local Section = {}
            
            -- Section Container
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = sectionName.."Section"
            SectionContainer.Size = UDim2.new(1, 0, 0, 30) -- Will be resized based on content
            SectionContainer.BackgroundColor3 = Colors.LightBackground
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 4)
            SectionCorner.Parent = SectionContainer
            
            -- Section Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, -10, 0, 25)
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Colors.NeonRed
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionContainer
            
            -- Section Content
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.Size = UDim2.new(1, -20, 0, 0) -- Will be resized based on content
            SectionContent.Position = UDim2.new(0, 10, 0, 25)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = SectionContainer
            
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentLayout.Padding = UDim.new(0, 8)
            SectionContentLayout.Parent = SectionContent
            
            -- Auto-size the section based on content
            SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, -20, 0, SectionContentLayout.AbsoluteContentSize.Y)
                SectionContainer.Size = UDim2.new(1, 0, 0, SectionContent.Size.Y.Offset + 35)
            end)
            
            -- Label Creation Function
            function Section:AddLabel(labelText)
                local LabelContainer = Instance.new("Frame")
                LabelContainer.Name = "LabelContainer"
                LabelContainer.Size = UDim2.new(1, 0, 0, 20)
                LabelContainer.BackgroundTransparency = 1
                LabelContainer.Parent = SectionContent
                
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = labelText
                Label.TextColor3 = Colors.Text
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = LabelContainer
                
                local LabelFunctions = {}
                
                function LabelFunctions:SetText(newText)
                    Label.Text = newText
                end
                
                return LabelFunctions
            end
            
            -- Button Creation Function
            function Section:AddButton(buttonText, callback)
                callback = callback or function() end
                
                local ButtonContainer = Instance.new("Frame")
                ButtonContainer.Name = "ButtonContainer"
                ButtonContainer.Size = UDim2.new(1, 0, 0, 30)
                ButtonContainer.BackgroundTransparency = 1
                ButtonContainer.Parent = SectionContent
                
                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.BackgroundColor3 = Colors.DarkBackground
                Button.BorderSizePixel = 0
                Button.Text = buttonText
                Button.TextColor3 = Colors.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.Parent = ButtonContainer
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                -- Button Effects
                Button.MouseEnter:Connect(function()
                    Button.BackgroundColor3 = Colors.NeonRed
                end)
                
                Button.MouseLeave:Connect(function()
                    Button.BackgroundColor3 = Colors.DarkBackground
                end)
                
                Button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                local ButtonFunctions = {}
                
                function ButtonFunctions:SetText(newText)
                    Button.Text = newText
                end
                
                return ButtonFunctions
            end
            
            -- Toggle Creation Function
            function Section:AddToggle(toggleText, default, callback)
                default = default or false
                callback = callback or function() end
                
                local ToggleContainer = Instance.new("Frame")
                ToggleContainer.Name = "ToggleContainer"
                ToggleContainer.Size = UDim2.new(1, 0, 0, 25)
                ToggleContainer.BackgroundTransparency = 1
                ToggleContainer.Parent = SectionContent
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "ToggleLabel"
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleText
                ToggleLabel.TextColor3 = Colors.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleContainer
                
                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(1, -40, 0, 2)
                ToggleButton.BackgroundColor3 = Colors.DarkBackground
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Parent = ToggleContainer
                
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonCorner.Parent = ToggleButton
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "ToggleCircle"
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Position = UDim2.new(0, 2, 0, 2)
                ToggleCircle.BackgroundColor3 = Colors.Text
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleButton
                
                local ToggleCircleCorner = Instance.new("UICorner")
                ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
                ToggleCircleCorner.Parent = ToggleCircle
                
                -- Make the entire container clickable
                local ToggleClickArea = Instance.new("TextButton")
                ToggleClickArea.Name = "ToggleClickArea"
                ToggleClickArea.Size = UDim2.new(1, 0, 1, 0)
                ToggleClickArea.BackgroundTransparency = 1
                ToggleClickArea.Text = ""
                ToggleClickArea.Parent = ToggleContainer
                
                -- Toggle State
                local Enabled = default
                
                -- Update toggle appearance based on state
                local function UpdateToggle()
                    if Enabled then
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.NeonRed}):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0, 2)}):Play()
                    else
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.DarkBackground}):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                    end
                end
                
                -- Set initial state
                UpdateToggle()
                
                -- Toggle Logic
                ToggleClickArea.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    UpdateToggle()
                    callback(Enabled)
                end)
                
                local ToggleFunctions = {}
                
                function ToggleFunctions:SetState(state)
                    Enabled = state
                    UpdateToggle()
                    callback(Enabled)
                end
                
                function ToggleFunctions:GetState()
                    return Enabled
                end
                
                return ToggleFunctions
            end
            
            -- Slider Creation Function
            function Section:AddSlider(sliderText, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                callback = callback or function() end
                
                local SliderContainer = Instance.new("Frame")
                SliderContainer.Name = "SliderContainer"
                SliderContainer.Size = UDim2.new(1, 0, 0, 45)
                SliderContainer.BackgroundTransparency = 1
                SliderContainer.Parent = SectionContent
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderText
                SliderLabel.TextColor3 = Colors.Text
                SliderLabel.TextSize = 14
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderContainer
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "SliderValue"
                SliderValue.Size = UDim2.new(0, 30, 0, 20)
                SliderValue.Position = UDim2.new(1, -30, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = Colors.NeonRed
                SliderValue.TextSize = 14
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderContainer
                
                local SliderBackground = Instance.new("Frame")
                SliderBackground.Name = "SliderBackground"
                SliderBackground.Size = UDim2.new(1, 0, 0, 10)
                SliderBackground.Position = UDim2.new(0, 0, 0, 25)
                SliderBackground.BackgroundColor3 = Colors.DarkBackground
                SliderBackground.BorderSizePixel = 0
                SliderBackground.Parent = SliderContainer
                
                local SliderBackgroundCorner = Instance.new("UICorner")
                SliderBackgroundCorner.CornerRadius = UDim.new(1, 0)
                SliderBackgroundCorner.Parent = SliderBackground
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Colors.NeonRed
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBackground
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "SliderButton"
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.BackgroundTransparency = 1
                SliderButton.Text = ""
                SliderButton.Parent = SliderBackground
                
                -- Slider Logic
                local function UpdateSlider(value)
                    value = math.clamp(value, min, max)
                    value = math.floor(value + 0.5) -- Round to nearest integer
                    
                    SliderValue.Text = tostring(value)
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    callback(value)
                end
                
                -- Set initial value
                UpdateSlider(default)
                
                -- Slider Interaction
                local isDragging = false
                
                SliderButton.MouseButton1Down:Connect(function()
                    isDragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativePos = mousePos.X - SliderBackground.AbsolutePosition.X
                        local percent = math.clamp(relativePos / SliderBackground.AbsoluteSize.X, 0, 1)
                        local value = min + (max - min) * percent
                        
                        UpdateSlider(value)
                    end
                end)
                
                local SliderFunctions = {}
                
                function SliderFunctions:SetValue(value)
                    UpdateSlider(value)
                end
                
                function SliderFunctions:GetValue()
                    return tonumber(SliderValue.Text)
                end
                
                return SliderFunctions
            end
            
            -- Dropdown Creation Function
            function Section:AddDropdown(dropdownText, options, default, callback)
                options = options or {}
                default = default or options[1]
                callback = callback or function() end
                
                local DropdownContainer = Instance.new("Frame")
                DropdownContainer.Name = "DropdownContainer"
                DropdownContainer.Size = UDim2.new(1, 0, 0, 40)
                DropdownContainer.BackgroundTransparency = 1
                DropdownContainer.Parent = SectionContent
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "DropdownLabel"
                DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = dropdownText
                DropdownLabel.TextColor3 = Colors.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownContainer
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Size = UDim2.new(1, 0, 0, 25)
                DropdownButton.Position = UDim2.new(0, 0, 0, 20)
                DropdownButton.BackgroundColor3 = Colors.DarkBackground
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = default
                DropdownButton.TextColor3 = Colors.Text
                DropdownButton.TextSize = 14
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = DropdownContainer
                
                local DropdownButtonPadding = Instance.new("UIPadding")
                DropdownButtonPadding.PaddingLeft = UDim.new(0, 10)
                DropdownButtonPadding.Parent = DropdownButton
                
                local DropdownButtonCorner = Instance.new("UICorner")
                DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
                DropdownButtonCorner.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "DropdownArrow"
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Position = UDim2.new(1, -25, 0, 2)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Image = "rbxassetid://6031091004"
                DropdownArrow.ImageColor3 = Colors.NeonRed
                DropdownArrow.Parent = DropdownButton
                
                -- Dropdown Menu
                local DropdownMenu = Instance.new("Frame")
                DropdownMenu.Name = "DropdownMenu"
                DropdownMenu.Size = UDim2.new(1, 0, 0, 0)
                DropdownMenu.Position = UDim2.new(0, 0, 1, 0)
                DropdownMenu.BackgroundColor3 = Colors.DarkBackground
                DropdownMenu.BorderSizePixel = 0
                DropdownMenu.ClipsDescendants = true
                DropdownMenu.Visible = false
                DropdownMenu.ZIndex = 5
                DropdownMenu.Parent = DropdownButton
                
                local DropdownMenuCorner = Instance.new("UICorner")
                DropdownMenuCorner.CornerRadius = UDim.new(0, 4)
                DropdownMenuCorner.Parent = DropdownMenu
                
                local DropdownMenuLayout = Instance.new("UIListLayout")
                DropdownMenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownMenuLayout.Parent = DropdownMenu
                
                -- Create option buttons
                local OptionButtons = {}
                
                for i, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option.."Option"
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Colors.Text
                    OptionButton.TextSize = 14
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                    OptionButton.ZIndex = 6
                    OptionButton.Parent = DropdownMenu
                    
                    local OptionButtonPadding = Instance.new("UIPadding")
                    OptionButtonPadding.PaddingLeft = UDim.new(0, 10)
                    OptionButtonPadding.Parent = OptionButton
                    
                    -- Hover effect
                    OptionButton.MouseEnter:Connect(function()
                        OptionButton.BackgroundTransparency = 0.8
                        OptionButton.BackgroundColor3 = Colors.NeonRed
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        OptionButton.BackgroundTransparency = 1
                    end)
                    
                    -- Select option
                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = option
                        DropdownMenu.Visible = false
                        DropdownMenu.Size = UDim2.new(1, 0, 0, 0)
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        callback(option)
                    end)
                    
                    table.insert(OptionButtons, OptionButton)
                end
                
                -- Toggle dropdown menu
                local isOpen = false
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        DropdownMenu.Visible = true
                        DropdownMenu:TweenSize(UDim2.new(1, 0, 0, #options * 25), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    else
                        DropdownMenu:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true, function()
                            DropdownMenu.Visible = false
                        end)
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    end
                end)
                
                -- Close dropdown when clicking elsewhere
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local mousePos = UserInputService:GetMouseLocation()
                        if isOpen and not (mousePos.X >= DropdownButton.AbsolutePosition.X and mousePos.X <= DropdownButton.AbsolutePosition.X + DropdownButton.AbsoluteSize.X and
                                mousePos.Y >= DropdownButton.AbsolutePosition.Y and mousePos.Y <= DropdownButton.AbsolutePosition.Y + DropdownButton.AbsoluteSize.Y + DropdownMenu.AbsoluteSize.Y) then
                            isOpen = false
                            DropdownMenu:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true, function()
                                DropdownMenu.Visible = false
                            end)
                            TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        end
                    end
                end)
                
                local DropdownFunctions = {}
                
                function DropdownFunctions:SetValue(value)
                    if table.find(options, value) then
                        DropdownButton.Text = value
                        callback(value)
                    end
                end
                
                function DropdownFunctions:GetValue()
                    return DropdownButton.Text
                end
                
                function DropdownFunctions:Refresh(newOptions, newDefault)
                    options = newOptions or options
                    default = newDefault or options[1]
                    
                    -- Clear existing options
                    for _, button in ipairs(OptionButtons) do
                        button:Destroy()
                    end
                    
                    OptionButtons = {}
                    
                    -- Create new options
                    for i, option in ipairs(options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = option.."Option"
                        OptionButton.Size = UDim2.new(1, 0, 0, 25)
                        OptionButton.BackgroundTransparency = 1
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Colors.Text
                        OptionButton.TextSize = 14
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                        OptionButton.ZIndex = 6
                        OptionButton.Parent = DropdownMenu
                        
                        local OptionButtonPadding = Instance.new("UIPadding")
                        OptionButtonPadding.PaddingLeft = UDim.new(0, 10)
                        OptionButtonPadding.Parent = OptionButton
                        
                        -- Hover effect
                        OptionButton.MouseEnter:Connect(function()
                            OptionButton.BackgroundTransparency = 0.8
                            OptionButton.BackgroundColor3 = Colors.NeonRed
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            OptionButton.BackgroundTransparency = 1
                        end)
                        
                        -- Select option
                        OptionButton.MouseButton1Click:Connect(function()
                            DropdownButton.Text = option
                            DropdownMenu.Visible = false
                            DropdownMenu.Size = UDim2.new(1, 0, 0, 0)
                            TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                            callback(option)
                        end)
                        
                        table.insert(OptionButtons, OptionButton)
                    end
                    
                    DropdownButton.Text = default
                end
                
                return DropdownFunctions
            end
            
            -- TextBox Creation Function
            function Section:AddTextBox(boxText, placeholder, default, callback)
                placeholder = placeholder or ""
                default = default or ""
                callback = callback or function() end
                
                local TextBoxContainer = Instance.new("Frame")
                TextBoxContainer.Name = "TextBoxContainer"
                TextBoxContainer.Size = UDim2.new(1, 0, 0, 45)
                TextBoxContainer.BackgroundTransparency = 1
                TextBoxContainer.Parent = SectionContent
                
                local TextBoxLabel = Instance.new("TextLabel")
                TextBoxLabel.Name = "TextBoxLabel"
                TextBoxLabel.Size = UDim2.new(1, 0, 0, 20)
                TextBoxLabel.BackgroundTransparency = 1
                TextBoxLabel.Text = boxText
                TextBoxLabel.TextColor3 = Colors.Text
                TextBoxLabel.TextSize = 14
                TextBoxLabel.Font = Enum.Font.Gotham
                TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextBoxLabel.Parent = TextBoxContainer
                
                local TextBox = Instance.new("TextBox")
                TextBox.Name = "TextBox"
                TextBox.Size = UDim2.new(1, 0, 0, 25)
                TextBox.Position = UDim2.new(0, 0, 0, 20)
                TextBox.BackgroundColor3 = Colors.DarkBackground
                TextBox.BorderSizePixel = 0
                TextBox.PlaceholderText = placeholder
                TextBox.Text = default
                TextBox.TextColor3 = Colors.Text
                TextBox.PlaceholderColor3 = Colors.SubText
                TextBox.TextSize = 14
                TextBox.Font = Enum.Font.Gotham
                TextBox.TextXAlignment = Enum.TextXAlignment.Left
                TextBox.ClearTextOnFocus = false
                TextBox.Parent = TextBoxContainer
                
                local TextBoxPadding = Instance.new("UIPadding")
                TextBoxPadding.PaddingLeft = UDim.new(0, 10)
                TextBoxPadding.Parent = TextBox
                
                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 4)
                TextBoxCorner.Parent = TextBox
                
                -- TextBox Logic
                TextBox.Focused:Connect(function()
                    TweenService:Create(TextBox, TweenInfo.new(0.2), {BorderSizePixel = 1, BorderColor3 = Colors.NeonRed}):Play()
                end)
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    TweenService:Create(TextBox, TweenInfo.new(0.2), {BorderSizePixel = 0}):Play()
                    callback(TextBox.Text, enterPressed)
                end)
                
                local TextBoxFunctions = {}
                
                function TextBoxFunctions:SetText(text)
                    TextBox.Text = text
                    callback(text, false)
                end
                
                function TextBoxFunctions:GetText()
                    return TextBox.Text
                end
                
                return TextBoxFunctions
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Add User Profile Section
    function Window:AddUserProfile(displayName)
        displayName = displayName or Player.DisplayName
        
        -- Update username label
        UsernameLabel.Text = displayName
        
        -- Create a function to update the avatar
        local function UpdateAvatar(userId)
            AvatarImage.Image = GetPlayerAvatar(userId or Player.UserId, "100x100")
        end
        
        return {
            SetDisplayName = function(name)
                UsernameLabel.Text = name
            end,
            UpdateAvatar = UpdateAvatar
        }
    end
    
    return Window
end

-- Return the library
return DeltaLib
