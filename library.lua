local Library = {}

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local PL = game:GetService("Players")

local Dragging; local DragStart; local DragInput; local StartPosition; local DragSpeed = 0.4

function Drag(Frame)
    local function Update(Input)
        local Delta = Input.Position - DragStart
        local NewPosition = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TS:Create(Frame,TweenInfo.new(DragSpeed, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Position = NewPosition}):Play()
    end

    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Frame.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)

    UIS.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            Update(Input)
        end
    end)
end

function Library:Create(ScriptName)
    local UI = {Tabs = 0, KeybindValue = "E"}
    local Insert = {}
    local ColorIncrement = 7

    function Create(ClassName, Parent, Properties)
        if type(Parent) == "table" then
            Properties, Parent = Parent, Properties
        end

        local NewInstance;
        if Parent ~= nil then
            NewInstance = Instance.new(ClassName, Parent)
        else
            NewInstance = Instance.new(ClassName)
        end

        for Property, Value in next, Properties do
            NewInstance[Property] = Value
        end

        return NewInstance
    end
    
    function Insert:UICorner(Frame)
        local UICorner = Create("UICorner", Frame, {
            CornerRadius = UDim.new(0, 6)
        })
        return UICorner
    end

    function Insert:UIStroke(Frame, Increment)
        local FBGC = Frame.BackgroundColor3
        local UIStroke = Create("UIStroke", Frame, {
            ApplyStrokeMode = Enum.ApplyStrokeMode["Border"],
            Color = Color3.new(FBGC.R + (Increment / 255), FBGC.G + (Increment / 255), FBGC.B + (Increment / 255)),
            Enabled = true,
            LineJoinMode = Enum.LineJoinMode["Round"],
            Thickness = 1,
            Transparency = 0,
        })
        return UIStroke
    end

    function Insert:UIListLayout(Frame, FillDirection, Spacing, SortOrder)
        FillDirection = FillDirection:split("_")
    
        local HorizontalAlignmentType;
        if FillDirection[2] then
            HorizontalAlignmentType = FillDirection[2]:lower():gsub("^l", "L"):gsub("^r", "R"):gsub("^c", "C")
        end
        
        if FillDirection[1]:lower() == "vertical" then
            local UIListLayout = Create("UIListLayout", Frame, {
                Padding = UDim.new(0, Spacing),
                FillDirection = Enum.FillDirection["Vertical"],
                SortOrder = ((SortOrder ~= nil and type(SortOrder) == "string") and Enum.SortOrder[SortOrder]) or Enum.SortOrder["LayoutOrder"],
                VerticalAlignment = Enum.VerticalAlignment["Top"],
                HorizontalAlignment = (type(HorizontalAlignmentType) == "string" and Enum.HorizontalAlignment[HorizontalAlignmentType]) or Enum.HorizontalAlignment["Center"],
            })
            return UIListLayout
        elseif FillDirection[1]:lower() == "horizontal" then
            local UIListLayout = Create("UIListLayout", Frame, {
                Padding = UDim.new(0, Spacing),
                FillDirection = Enum.FillDirection["Horizontal"],
                SortOrder = ((SortOrder ~= nil and type(SortOrder) == "string") and Enum.SortOrder[SortOrder]) or Enum.SortOrder["LayoutOrder"],
                VerticalAlignment = Enum.VerticalAlignment["Center"],
                HorizontalAlignment = (type(HorizontalAlignmentType) == "string" and Enum.HorizontalAlignment[HorizontalAlignmentType]) or Enum.HorizontalAlignment["Center"],
            })
            return UIListLayout
        end
    end

    function Insert:UIPadding(Frame, Spacing)
        local UIPadding = Create("UIPadding", Frame, {
            PaddingTop = UDim.new(0, Spacing),
            PaddingBottom = UDim.new(0, Spacing),
        })
        return UIPadding
    end
    
    local GUI = Create("ScreenGui", game:GetService("CoreGui"), {
        Name = "simple",
        IgnoreGuiInset = true,
        ResetOnSpawn = true,
    })

    local _ = Create("Frame", GUI, {
        Name = "_",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
    })

    Drag(_)

    local Shadow = Create("ImageLabel", _, {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10049363189",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(20, 20, 50, 50)
    })

    local Main = Create("Frame", _, {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
    })

    Insert:UICorner(Main)

    local Title = Create("TextLabel", Main, {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 125, 0, 25),
        Position = UDim2.new(0.123, 0, 0.047, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font["GothamMedium"],
        Text = ScriptName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment["Left"]
    })

    local List = Create("Frame", Main, {
        Name = "List",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 110, 0, 350),
        Position = UDim2.new(0.11, 0, 0.535, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    })

    Insert:UICorner(List)
    Insert:UIStroke(List, ColorIncrement)

    local ListContainer = Create("ScrollingFrame", List, {
        Name = "Container",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize["X"],
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
    })

    Insert:UIListLayout(ListContainer, "Vertical", 3)
    Insert:UIPadding(ListContainer, 3)

    function UI:Tab(TabName)
        UI["Tabs"] += 1

        local TFeatures = {}

        function Divider()
            local Divider = Create("Frame", ListContainer, {
                Name = "Divider",
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Color3.fromRGB(30 + ColorIncrement, 30 + ColorIncrement, 30 + ColorIncrement),
                BorderSizePixel = 0,
            })
        end

        local Tab = Create("TextButton", ListContainer, {
            Name = TabName,
            Size = UDim2.new(1, 0, 0, 25),
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Font = Enum.Font["Gotham"],
            Text = TabName,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
        })

        local TabFrame = Create("Frame", Main, {
            Name = TabName,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 455, 0, 350),
            Position = UDim2.new(0.6, 0, 0.535, 0),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        })

        Insert:UICorner(TabFrame)
        Insert:UIStroke(TabFrame, ColorIncrement)

        local TabContainer = Create("ScrollingFrame", TabFrame, {
            Name = "Container",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize["X"],
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
        })

        local UIL = Insert:UIListLayout(TabContainer, "Vertical", 11)
        local UIP = Insert:UIPadding(TabContainer, 11)

        Divider()

        if UI["Tabs"] == 1 then
            TabFrame.Visible = true
        else
            TabFrame.Visible = false
        end

        Tab.MouseButton1Click:Connect(function()
            for _, Frame in ipairs(Main:GetChildren()) do
                if Frame:IsA("Frame") and Frame.Name == Tab.Name then
                    Frame.Visible = true
                elseif Frame:IsA("Frame") and Frame.Name ~= Tab.Name and Frame.Name ~= "List" then
                    Frame.Visible = false
                end
            end
        end)

        local function UpdateSize()
            TabContainer.CanvasSize = UDim2.new(
                0, 0,
                0, UIL.AbsoluteContentSize.Y + (UIP.PaddingTop.Offset * 2)
            )
        end
         
        UIL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
        
        function TFeatures:Info(LabelInfo)
            local LabelFeatures = {}

            local Label = Create("TextLabel", TabContainer, {
                Name = "Label",
                Size = UDim2.new(0.95, 0, 0, 999),
                BackgroundTransparency = 1,
                Font = Enum.Font["GothamMedium"],
                RichText = true,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment["Left"],
            })

            Label:GetPropertyChangedSignal("Text"):Connect(function()
                Label.Size = UDim2.new(0.93, 0, 0, math.max(25, Label.TextBounds.Y + 5))
            end)

            Label.Text = LabelInfo

            function LabelFeatures:GetObject()
                return Label
            end

            return LabelFeatures
        end

        function TFeatures:Section(SectionInfo)
            local SFeatures = {}

            local SectionContainer = Create("ScrollingFrame", TabContainer, {
                Name = SectionInfo,
                Size = UDim2.new(0.98, 0, 0, 10),
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(0, 0, 0, 0),
            })

            local UIL = Insert:UIListLayout(SectionContainer, "Vertical_Center", 3)

            UIL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                local SFSX = SectionContainer.Size.X
                SectionContainer.Size = UDim2.new(SFSX.Scale, SFSX.Offset, 0, UIL.AbsoluteContentSize.Y)
            end)

            local SectionName = Create("TextLabel", SectionContainer, {
                Name = "SectionName",
                Size = UDim2.new(0.96, 0, 0, 15),
                BackgroundTransparency = 1,
                Font = Enum.Font["GothamBold"],
                Text = SectionInfo,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment["Left"],
                TextYAlignment = Enum.TextYAlignment["Top"],
            })
            
            function SFeatures:Label(LabelInfo)
                local LabelFeatures = {}
                
                local Label = Create("TextLabel", SectionContainer, {
                    Name = "Label",
                    Size = UDim2.new(0.95, 0, 0, 999),
                    BackgroundTransparency = 1,
                    Font = Enum.Font["GothamMedium"],
                    RichText = true,
                    Text = "",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
    
                Label:GetPropertyChangedSignal("Text"):Connect(function()
                    Label.Size = UDim2.new(0.93, 0, 0, math.max(25, Label.TextBounds.Y + 5))
                end)
    
                Label.Text = LabelInfo
            
                function LabelFeatures:UpdateLabel(LabelInfo)
                    Label.Text = LabelInfo
                end

                function LabelFeatures:GetObject()
                    return Label
                end

                return LabelFeatures
            end

            function SFeatures:Button(ButtonName, Callback)
                local ButtonFeatures = {}

                local Button = Create("TextButton", SectionContainer, {
                    Name = ButtonName,
                    Size = UDim2.new(1, 0, 0, 25),
                    AutoButtonColor = false,
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BackgroundTransparency = 1,
                    Text = "",
                })

                Insert:UICorner(Button)

                local ButtonText = Create("TextLabel", Button, {
                    Name = "ButtonText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.935, 0, 0, 10),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font["Gotham"],
                    Text = ButtonName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
    
                Button.MouseButton1Click:Connect(function()
                    local Tween = TS:Create(Button, TweenInfo.new(0.05), {BackgroundTransparency = 0})
                    Tween:Play()
                    Tween.Completed:Wait()
                    TS:Create(Button, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
                    pcall(Callback)
                end)

                function ButtonFeatures:GetObject()
                    return Button
                end
                
                return ButtonFeatures
            end
    
            function SFeatures:Box(BoxName, Callback)
                local BoxFeatures = {}

                local Frame = Create("Frame", SectionContainer, {
                    Name = BoxName,
                    Size = UDim2.new(0.95, 0, 0, 25),
                    BackgroundTransparency = 1,
                })
    
                local BoxText = Create("TextLabel", Frame, {
                    Name = "BoxText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.75, 0, 1, 0),
                    Position = UDim2.new(0.385, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text = BoxName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font["Gotham"],
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
                
                local BoxFrame = Create("Frame", Frame, {
                    Name = "BoxFrame",
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(-0.01, 0, 0, 0),
                    BackgroundTransparency = 1,
                })
    
                Insert:UIListLayout(BoxFrame, "Horizontal_Right", 0)
    
                local BoxContainer = Create("Frame", BoxFrame, {
                    Name = "BoxContainer",
                    Size = UDim2.new(0.25, 0, 0, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                })
    
                Insert:UICorner(BoxContainer)
                Insert:UIStroke(BoxContainer, ColorIncrement * 2)
                Insert:UIListLayout(BoxContainer, "Horizontal_Center", 0)
    
                local Box = Create("TextBox", BoxContainer, {
                    Name = "Box",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.86, 0, 1, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    PlaceholderColor3 = Color3.fromRGB(255, 255, 255),
                    PlaceholderText = "...",
                    AutomaticSize = Enum.AutomaticSize["X"],
                    Font = Enum.Font["Gotham"],
                    Text = "",
                    TextSize = 10,
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = false,
                })
    
                local MinWidth = BoxContainer.AbsoluteSize.X
    
                local function UpdateSize()
                    BoxContainer.Size = UDim2.new(
                        0, math.max(MinWidth, Box.TextBounds.X + 14),
                        0, 20
                    )
                end
                 
                Box:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSize)
    
                Box.FocusLost:Connect(function()
                    if Box.Text ~= "" then
                        pcall(Callback, Box.Text)
                        Box.Text = ""
                    end
                end)

                function BoxFeatures:GetObject()
                    return Box
                end

                return BoxFeatures
            end
    
            local ToggleColors = {
                [true] = Color3.fromRGB(125, 255, 125),
                [false] = Color3.fromRGB(25, 25, 25),
            }
    
            function SFeatures:Toggle(ToggleName, Callback, Options)
                local ToggleFeatures = {}
                local Enabled = false
    
                local Frame = Create("Frame", SectionContainer, {
                    Name = ToggleName,
                    Size = UDim2.new(0.95, 0, 0, 25),
                    BackgroundTransparency = 1,
                })
    
                local ToggleText = Create("TextLabel", Frame, {
                    Name = "ToggleText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.75, 0, 1, 0),
                    Position = UDim2.new(0.385, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text = ToggleName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font["Gotham"],
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
                
                local ToggleFrame = Create("Frame", Frame, {
                    Name = "ToggleFrame",
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(-0.01, 0, 0, 0),
                    BackgroundTransparency = 1,
                })
    
                Insert:UIListLayout(ToggleFrame, "Horizontal_Right", 0)
    
                local Toggle = Create("TextButton", ToggleFrame, {
                    Name = "Toggle",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0.92, 0, 0.5, 0),
                    AutoButtonColor = false,
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font["Gotham"],
                    Text = "",
                    TextSize = 10,
                })
    
                Insert:UICorner(Toggle)
                Insert:UIStroke(Toggle, ColorIncrement * 2)
    
                if Options ~= nil then
                    if Options.Enabled then
                        Enabled = Options.Enabled
                    end
                end
    
                game:GetService("TweenService"):Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = ToggleColors[Enabled]}):Play()
    
                Toggle.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    game:GetService("TweenService"):Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = ToggleColors[Enabled]}):Play()
                    pcall(Callback, Enabled)
                end)

                function ToggleFeatures:GetObject()
                    return Toggle
                end
                
                function ToggleFeatures:GetValue()
                    return Enabled
                end
                
                function ToggleFeatures:SetValue(Value)
                    Enabled = Value
                    game:GetService("TweenService"):Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = ToggleColors[Enabled]}):Play()
                    pcall(Callback, Enabled)
                end
                
                function ToggleFeatures:SetColorValues(ColorValues)
                    if ColorValues[true] then
                        ToggleColors[true] = ColorValues[true]
                    end
                    if ColorValues[false] then
                        ToggleColors[false] = ColorValues[false]
                    end
                end
                
                return ToggleFeatures
            end
    
            function SFeatures:Slider(SliderName, Callback, Options)
                local SliderFeatures = {}
                local Min = 0
                local Max = 1
                local Precise = false
                local Enabled = false
                local Value;
    
                local Frame = Create("Frame", SectionContainer, {
                    Name = SliderName,
                    Size = UDim2.new(0.95, 0, 0, 25),
                    BackgroundTransparency = 1,
                })
                
                local SliderText = Create("TextLabel", Frame, {
                    Name = "SliderText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.75, 0, 1, 0),
                    Position = UDim2.new(0.385, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text = SliderName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font["Gotham"],
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
                
                local SliderFrame = Create("Frame", Frame, {
                    Name = "SliderFrame",
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(-0.01, 0, 0, 0),
                    BackgroundTransparency = 1,
                })
    
                Insert:UIListLayout(SliderFrame, "Horizontal_Right", 0)
    
                local Slider = Create("Frame", SliderFrame, {
                    Name = "Slider",
                    Size = UDim2.new(0.4, 0, 0, 15),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    ClipsDescendants = true,
                })
    
                local SliderValueText = Create("TextLabel", Slider, {
                    Name = "SliderValueText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 10, 0, 10),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 10,
                    Text = Min,
                    Font = Enum.Font["Gotham"],
                    TextXAlignment = Enum.TextXAlignment["Left"]
                })
                
                Insert:UICorner(Slider)
                Insert:UIStroke(Slider, ColorIncrement * 2)
    
                local SliderFrameDetail = Create("Frame", Slider, {
                    Name = "SliderFrameDetail",
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                })
                
                local SliderFrameDetailValueText = Create("TextLabel", SliderFrameDetail, {
                    Name = "SliderFrameDetailValueText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 10, 0, 10),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(25, 25, 25),
                    TextSize = 10,
                    Text = Min,
                    Font = Enum.Font["Gotham"],
                    TextXAlignment = Enum.TextXAlignment["Left"]
                })
                
                Insert:UICorner(SliderFrameDetail)
    
                local SliderButton = Create("TextButton", Slider, {
                    Name = "SliderButton",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                })
    
                if Options then
                    if Options.Min then
                        Min = Options.Min
                    end
                    if Options.Max then
                        Max = Options.Max
                    end
                    if Options.Precise then
                        Precise = Options.Precise
                    end
                    if Options.Default then
                        if Precise then
                            Options.Default = tonumber(string.format("%.03f", Options.Default))
                            Value = Options.Default
                            local Scale = math.clamp((Options.Default - Min) / (Max - Min), 0, 1)
                            SliderFrameDetail.Size = UDim2.new(Scale, 0, 0.98, 0)
                            SliderValueText.Text = Options.Default
                            SliderFrameDetailValueText.Text = Options.Default
                        else
                            Options.Default = math.round(Options.Default)
                            Value = Options.Default
                            local Scale = math.clamp((Options.Default - Min) / (Max - Min), 0, 1)
                            SliderFrameDetail.Size = UDim2.new(Scale, 0, 0.98, 0)
                            SliderValueText.Text = Options.Default
                            SliderFrameDetailValueText.Text = Options.Default
                        end
                    end
                end
    
                SliderButton.MouseButton1Down:Connect(function()
                    Enabled = true
                end)
    
                UIS.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Enabled = false
                    end
                end)
    
                RS.RenderStepped:Connect(function()
                    local Mouse = PL.LocalPlayer:GetMouse()
                    
                    if Enabled then
                        local Percentage = math.clamp((Mouse.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                        Value = ((Max - Min) * Percentage) + Min
    
                        if not Precise then
                            Value = math.round(Value)
                            SliderValueText.Text = Value
                            SliderFrameDetailValueText.Text = Value
                        else
                            SliderValueText.Text = string.format("%.03f", Value)
                            SliderFrameDetailValueText.Text = string.format("%.03f", Value)
                        end
    
    
                        local SFDY = SliderFrameDetail.Size.Y
                        TS:Create(SliderFrameDetail, TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(Percentage, 0, SFDY.Scale, SFDY.Offset)}):Play()
    
                        pcall(Callback, Value)
                    end
                end)

                function SliderFeatures:GetObject()
                    return Slider
                end
                
                function SliderFeatures:GetValue()
                    return Value
                end
                
                function SliderFeatures:SetValue(Input)
                    local Scale = math.clamp((Input - Min) / (Max - Min), 0, 1)
                    Value = ((Max - Min) * Scale) + Min
                    
                    if not Precise then
                        Value = math.round(Value)
                        SliderValueText.Text = Value
                        SliderFrameDetailValueText.Text = Value
                    else
                        SliderValueText.Text = string.format("%.03f", Value)
                        SliderFrameDetailValueText.Text = string.format("%.03f", Value)
                    end
                    
                    local SFDY = SliderFrameDetail.Size.Y
                    TS:Create(SliderFrameDetail, TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(Percentage, 0, SFDY.Scale, SFDY.Offset)}):Play()
                end
            
                return SliderFeatures
            end
    
            function SFeatures:Dropdown(DropdownName, Data, Callback, Options)
                local DropdownFeatures = {}
    
                local DropdownData = {}
                local Enabled = false
                local Default = ""
    
                local Frame = Create("Frame", SectionContainer, {
                    Name = DropdownName,
                    Size = UDim2.new(0.95, 0, 0, 25),
                    BackgroundTransparency = 1,
                })
                
                local DropdownText = Create("TextLabel", Frame, {
                    Name = "DropdownText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.75, 0, 1, 0),
                    Position = UDim2.new(0.385, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text = DropdownName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font["Gotham"],
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
    
                local DropdownFrame = Create("Frame", Frame, {
                    Name = "DropdownFrame",
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(-0.01, 0, 0, 0),
                    BackgroundTransparency = 1,
                })
    
                Insert:UIListLayout(DropdownFrame, "Vertical_Right", 0)
                Insert:UIPadding(DropdownFrame, 2)
    
                local Dropdown = Create("Frame", DropdownFrame, {
                    Name = "Dropdown",
                    Size = UDim2.new(0.4, 0, 0, 20),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    ClipsDescendants = true,
                })
    
                Insert:UICorner(Dropdown)
                Insert:UIStroke(Dropdown, ColorIncrement * 2)
                Insert:UIListLayout(Dropdown, "Vertical_Center", 0, "LayoutOrder")
    
                local DropdownButton = Create("TextButton", Dropdown, {
                    Name = "DropdownButton",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Font = Enum.Font["Gotham"],
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 10,
                    Text = "...",
                })
    
                local DropdownContainer = Create("ScrollingFrame", Dropdown, {
                    Name = "DropdownContainer",
                    Size = UDim2.new(1, 0, 0, 100),
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageTransparency = 1,
                    AutomaticCanvasSize = Enum.AutomaticSize["Y"],
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ScrollingEnabled = false,
                })
                
                Insert:UIListLayout(DropdownContainer, "Vertical_Center", 0, "Name")
    
                if Options then
                    if Options.Default then
                        if type(Options.Default) == "userdata" then
                            Default = Options.Default.Name
                            pcall(Callback, Options.Default)
                        else
                            Default = tostring(Options.Default)
                            pcall(Callback, tostring(Options.Default))
                        end
                    end
                end
    
                DropdownButton.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    if Enabled then
                        local DSizeX = Dropdown.Size.X
                        local DSizeY = Dropdown.Size.Y
                        local FSizeX = Frame.Size.X
                        local FSizeY = Frame.Size.Y
                        TS:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DSizeX.Scale, DSizeX.Offset, DSizeY.Scale, 120)}):Play()
                        TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, 125)}):Play()
                        TS:Create(DropdownContainer, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0}):Play()
                        DropdownContainer.ScrollingEnabled = true
                    end
                    if not Enabled then
                        local DSizeX = Dropdown.Size.X
                        local DSizeY = Dropdown.Size.Y
                        local FSizeX = Frame.Size.X
                        local FSizeY = Frame.Size.Y
                        TS:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DSizeX.Scale, DSizeX.Offset, DSizeY.Scale, 20)}):Play()
                        TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, 25)}):Play()
                        TS:Create(DropdownContainer, TweenInfo.new(0.3), {ScrollBarImageTransparency = 1}):Play()
                        DropdownContainer.ScrollingEnabled = false
                    end
                end)
    
                local function CreateDropdownOption(String)
                    local DropdownOption = Create("TextButton", DropdownContainer, {
                        Name = String,
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundTransparency = 1,
                        Font = Enum.Font["Gotham"],
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 10,
                        Text = String,
                    })
                end
    
                for _, DataValue in ipairs(Data) do
                    if type(DataValue) == "userdata" then
                        DropdownData[DataValue.Name] = DataValue
                        CreateDropdownOption(DataValue.Name)
                    else
                        DropdownData[DataValue] = DataValue
                        CreateDropdownOption(DataValue)
                    end
                end
    
                for _, Option in ipairs(DropdownContainer:GetChildren()) do
                    if Option:IsA("TextButton") then
                        Option.MouseButton1Click:Connect(function()
                            Enabled = false
    
                            local DSizeX = Dropdown.Size.X
                            local DSizeY = Dropdown.Size.Y
                            local FSizeX = Frame.Size.X
                            local FSizeY = Frame.Size.Y
                            TS:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DSizeX.Scale, DSizeX.Offset, DSizeY.Scale, 20)}):Play()
                            TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, 25)}):Play()
                            TS:Create(DropdownContainer, TweenInfo.new(0.3), {ScrollBarImageTransparency = 1}):Play()
                            DropdownContainer.ScrollingEnabled = false
    
                            Default = Option.Text
                            DropdownButton.Text = Default
                            pcall(Callback, DropdownData[Default])
                        end)
                    end
                end
    
                function DropdownFeatures:UpdateData(Data)
                    table.clear(DropdownData)
    
                    for _, Object in ipairs(DropdownContainer:GetChildren()) do
                        if Object:IsA("TextButton") then
                            Object:Destroy()
                        end
                    end
    
                    for _, DataValue in ipairs(Data) do
                        if type(DataValue) == "userdata" then
                            DropdownData[DataValue.Name] = DataValue
                            CreateDropdownOption(DataValue.Name)
                        else
                            DropdownData[DataValue] = DataValue
                            CreateDropdownOption(DataValue)
                        end
                    end
    
                    for _, Option in ipairs(DropdownContainer:GetChildren()) do
                        if Option:IsA("TextButton") then
                            Option.MouseButton1Click:Connect(function()
                                Enabled = false
                                
                                local DSizeX = Dropdown.Size.X
                                local DSizeY = Dropdown.Size.Y
                                local FSizeX = Frame.Size.X
                                local FSizeY = Frame.Size.Y
                                TS:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DSizeX.Scale, DSizeX.Offset, DSizeY.Scale, 20)}):Play()
                                TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, 25)}):Play()
                                TS:Create(DropdownContainer, TweenInfo.new(0.3), {ScrollBarImageTransparency = 1}):Play()
                                DropdownContainer.ScrollingEnabled = false
    
                                Default = Option.Text
                                DropdownButton.Text = Default
                                pcall(Callback, DropdownData[Default])
                            end)
                        end
                    end
                end
                
                function DropdownFeatures:AddData(Data)
                    for _, DataValue in ipairs(Data) do
                        if type(DataValue) == "userdata" then
                            DropdownData[DataValue.Name] = DataValue
                            CreateDropdownOption(DataValue.Name)
                        else
                            DropdownData[DataValue] = DataValue
                            CreateDropdownOption(DataValue)
                        end
                    end
    
                    for _, Option in ipairs(DropdownContainer:GetChildren()) do
                        if Option:IsA("TextButton") then
                            Option.MouseButton1Click:Connect(function()
                                Enabled = false
                                
                                local DSizeX = Dropdown.Size.X
                                local DSizeY = Dropdown.Size.Y
                                local FSizeX = Frame.Size.X
                                local FSizeY = Frame.Size.Y
                                TS:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DSizeX.Scale, DSizeX.Offset, DSizeY.Scale, 20)}):Play()
                                TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, 25)}):Play()
                                TS:Create(DropdownContainer, TweenInfo.new(0.3), {ScrollBarImageTransparency = 1}):Play()
                                DropdownContainer.ScrollingEnabled = false
    
                                Default = Option.Text
                                DropdownButton.Text = Default
                                pcall(Callback, DropdownData[Default])
                            end)
                        end
                    end
                end

                function DropdownFeatures:GetObject()
                    return Dropdown
                end
                
                return DropdownFeatures
            end

            return SFeatures
        end

        return TFeatures
    end

    function UI:Keybind(Key)
        UI["KeybindValue"] = Key
    end

    function UI:Destroy()
        GUI:Destroy()
    end

    UIS.InputBegan:Connect(function(Input, GPE)
        if Input.KeyCode == Enum.KeyCode[UI["KeybindValue"]] and not GPE then
            GUI.Enabled = not GUI.Enabled
        end
    end)
    
    return UI
end

return Library
