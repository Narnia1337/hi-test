local ImageIds = {
    11144521670,
    5425614532,
}; local ImageStorage = {}; for _, Id in ipairs(ImageIds) do local Temp = Instance.new("Decal", workspace); Temp.Texture = "rbxassetid://" .. Id; ImageStorage[table.getn(ImageStorage) + 1] = Temp end; game:GetService("ContentProvider"):PreloadAsync(ImageStorage); for _, Decal in ipairs(ImageStorage) do Decal:Destroy() end

local Library = {
    Connections = {},
    Coroutines = {},
}

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")

local LP = Players.LocalPlayer

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

function RbxThumb(Id, ThumbnailType, ThumbnailSize)
    local SupportedTypes = {
        "Asset",
        "Avatar",
        "AvatarHeadShot",
        "BadgeIcon",
        "BundleThumbnail",
        "GameIcon",
        "GamePass",
        "GroupIcon",
        "Outfit"
    }
    
    local SupportedSizes = {
        ["Asset"] = {"150x150", "420x420"},
        ["Avatar"] = {"100x100", "352x352", "720x720"},
        ["AvatarHeadShot"] = {"48x48", "60x60", "150x150"},
        ["BadgeIcon"] = {"150x150"},
        ["BundleThumbnail"] = {"150x150", "420x420"},
        ["GameIcon"] = {"50x50", "150x150"},
        ["GamePass"] = {"150x150"},
        ["GroupIcon"] = {"150x150", "420x420"},
        ["Outfit"] = {"150x150", "420x420"}
    }
    
    assert(type(Id) == "number", "Id is not a number, please input the id as a number, not a string")
    assert(table.find(SupportedTypes, ThumbnailType), "Thumbnail type not supported, supported types are:\n" .. table.concat(SupportedTypes, "\n"))
    assert(table.find(SupportedSizes[ThumbnailType], ThumbnailSize), "Thumbnail size not supported, supported sizes are:\n" .. table.concat(SupportedSizes[ThumbnailType], "\n"))
    
    local URL = "rbxthumb://id=%d&type=%s&w=%d&h=%d"
    local ThumbnailSizeWidth = tonumber(ThumbnailSize:split("x")[1])
    local ThumbnailSizeHeight = tonumber(ThumbnailSize:split("x")[2])
    URL = URL:format(Id, ThumbnailType, ThumbnailSizeWidth, ThumbnailSizeHeight)
    
    return URL
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
    
    function Insert:UIGradient(Frame, ColorSequence, NumberSequence, Rotation)
        local UIGradient = Create("UIGradient", Frame, {
            Color = ColorSequence,
        })
        
        if NumberSequence then
            UIGradient.Transparency = NumberSequence
        end
        
        if Rotation then
            UIGradient.Rotation = Rotation
        end
        
        return UIGradient
    end
    
    local GUI = Create("ScreenGui", {
        Name = "simple",
        IgnoreGuiInset = true,
        ResetOnSpawn = true,
    })

    if syn then
        syn.protect_gui(GUI)
        GUI.Parent = game:GetService("CoreGui")
    end

    local _ = Create("Frame", GUI, {
        Name = "_",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 550, 0, 350),
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
        Position = UDim2.new(0.135, 0, 0.055, 0),
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
        Size = UDim2.new(0, 110, 0, 300),
        Position = UDim2.new(0.12, 0, 0.54, 0),
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

        local TabInit = {}

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
            Size = UDim2.new(0, 405, 0, 300),
            Position = UDim2.new(0.61, 0, 0.54, 0),
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
        
        function TabInit:Info(LabelInfo)
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
        end

        function TabInit:Section(SectionInfo)
            local SectionInit = {}

            local SectionContainer = Create("Frame", TabContainer, {
                Name = SectionInfo,
                Size = UDim2.new(0.98, 0, 0, 10),
                BackgroundTransparency = 1,
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

            function SectionInit:Label(LabelInfo)
                local LabelInit = {}

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

                function LabelInit:UpdateText(Text)
                    Label.Text = Text
                end

                return LabelInit
            end

            function SectionInit:Button(ButtonName, Callback)
                local Button = Create("TextButton", SectionContainer, {
                    Name = ButtonName,
                    Size = UDim2.new(0.93, 0, 0, 25),
                    AutoButtonColor = false,
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BackgroundTransparency = 1,
                    Font = Enum.Font["Gotham"],
                    Text = ButtonName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
                
                local ButtonFrame = Create("Frame", Button, {
                    Name = "ButtonFrame",
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(-0.01, 0, 0, 0),
                    BackgroundTransparency = 1,
                })
    
                Insert:UIListLayout(ButtonFrame, "Horizontal_Right", 0)

                local ButtonIcon = Create("ImageLabel", ButtonFrame, {
                    Name = "ButtonIcon",
                    Size = UDim2.new(0, 20, 0, 20),
                    BackgroundTransparency = 1,
                    Image = RbxThumb(11144521670, "Asset", "420x420"),
                    ImageTransparency = 1,
                })

                Button.MouseButton1Click:Connect(function()
                    pcall(Callback)

                    local Tween = TS:Create(ButtonIcon, TweenInfo.new(0.1), {ImageTransparency = 0})
                    Tween:Play()
                    Tween.Completed:Wait()
                    task.wait(0.2)
                    TS:Create(ButtonIcon, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
                end)
            end
    
            function SectionInit:Box(BoxName, Callback)
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
    
                Box.FocusLost:Connect(function(EP)
                    if EP then
                        if Box.Text ~= "" then
                            pcall(Callback, Box.Text)
                            Box.Text = ""
                        end
                    end
                end)
            end
    
            local ToggleColors = {
                [true] = Color3.fromRGB(125, 255, 125),
                [false] = Color3.fromRGB(25, 25, 25),
            }
    
            function SectionInit:Toggle(ToggleName, Callback, Options)
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
            end
    
            function SectionInit:Slider(SliderName, Callback, Options)
                local Min = 0
                local Max = 1
                local Precise = false
                local Enabled = false
    
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
                    Size = UDim2.new(0.55, 0, 0, 15),
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
                        Options.Default = math.max(Min, Options.Default)
                        if Precise then
                            local Scale = math.clamp((Options.Default - Min) / (Max - Min), 0, 1)
                            SliderFrameDetail.Size = UDim2.new(Scale, 0, 0.98, 0)
                            SliderValueText.Text = string.format("%.03f", Options.Default)
                            SliderFrameDetailValueText.Text = string.format("%.03f", Options.Default)
                        else
                            Options.Default = math.round(Options.Default)
                            local Scale = math.clamp((Options.Default - Min) / (Max - Min), 0, 1)
                            SliderFrameDetail.Size = UDim2.new(Scale, 0, 0.98, 0)
                            SliderValueText.Text = Options.Default
                            SliderFrameDetailValueText.Text = Options.Default
                        end
                    else
                        local Scale = math.clamp(-Min / (Max - Min), 0, 1)
                        SliderFrameDetail.Size = UDim2.new(Scale, 0, 0.98, 0)
                        if Precise then
                            SliderValueText.Text = string.format("%.03f", Min)
                            SliderFrameDetailValueText.Text = string.format("%.03f", Min)
                        else
                            local Scale = math.clamp(-Min / (Max - Min), 0, 1)
                            SliderFrameDetail.Size = UDim2.new(Scale, 0, 0.98, 0)
                            SliderValueText.Text = Min
                            SliderFrameDetailValueText.Text = Min
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
    
                coroutine.wrap(function()
                    RS.RenderStepped:Connect(function()
                        local Mouse = LP:GetMouse()
                        
                        if Enabled then
                            local Percentage = math.clamp((Mouse.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                            local Value = ((Max - Min) * Percentage) + Min
        
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
                end)()
            end
    
            function SectionInit:Dropdown(DropdownName, Data, Callback, Options)
                local DropdownInit = {}
    
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
                Insert:UIListLayout(Dropdown, "Vertical_Center", 0)
    
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
                
                local UIL = Insert:UIListLayout(DropdownContainer, "Vertical_Center", 0)
    
                if Options then
                    if Options.Default then
                        if type(Options.Default) == "userdata" then
                            Default = Options.Default.Name
                            DropdownButton.Text = Default
                            pcall(Callback, Options.Default)
                        else
                            Default = tostring(Options.Default)
                            DropdownButton.Text = Default
                            pcall(Callback, tostring(Options.Default))
                        end
                    end
                    if Options.InOrder then
                        UIL.SortOrder = "Name"
                    end
                end
    
                DropdownButton.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    if Enabled then
                        local DSizeX = Dropdown.Size.X
                        local DSizeY = Dropdown.Size.Y
                        local FSizeX = Frame.Size.X
                        local FSizeY = Frame.Size.Y
                        TS:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DSizeX.Scale, DSizeX.Offset, DSizeY.Scale, math.min(UIL.AbsoluteContentSize.Y + 20, 120))}):Play()
                        TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, math.min(UIL.AbsoluteContentSize.Y + 25, 125))}):Play()
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

                DropdownContainer.Size = UDim2.new(1, 0, 0, UIL.AbsoluteContentSize.Y)
    
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
    
                function DropdownInit:UpdateData(Data)
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
                    
                    DropdownContainer.Size = UDim2.new(1, 0, 0, UIL.AbsoluteContentSize.Y)
    
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

                function DropdownInit:AddData(Data)
                    for _, DataValue in ipairs(Data) do
                        if type(DataValue) == "userdata" then
                            DropdownData[DataValue.Name] = DataValue
                            CreateDropdownOption(DataValue.Name)
                        else
                            DropdownData[DataValue] = DataValue
                            CreateDropdownOption(DataValue)
                        end
                    end

                    DropdownContainer.Size = UDim2.new(1, 0, 0, UIL.AbsoluteContentSize.Y)

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
    
                return DropdownInit
            end

            function SectionInit:ColorPicker(ColorPickerName, Callback)
                local Enabled = false
                local CoreEnabled = false
                local ColorsEnabled = false
                
                local Frame = Create("Frame", SectionContainer, {
                    Name = ColorPickerName,
                    Size = UDim2.new(0.95, 0, 0, 25),
                    BackgroundTransparency = 1,
                })
    
                local ColorPickerText = Create("TextLabel", Frame, {
                    Name = "ColorPickerText",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.75, 0, 1, 0),
                    Position = UDim2.new(0.385, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text = ColorPickerName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font["Gotham"],
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment["Left"],
                })
                
                local ColorPickerFrame = Create("Frame", Frame, {
                    Name = "ToggleFrame",
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(-0.01, 0, 0, 0),
                    BackgroundTransparency = 1,
                })
    
                Insert:UIListLayout(ColorPickerFrame, "Horizontal_Right", 0)

                local ColorPicker = Create("TextButton", ColorPickerFrame, {
                    Name = "ColorPicker",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 40, 0, 20),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Text = "",
                })

                Insert:UICorner(ColorPicker)
                
                local PrimaryCore = Create("Frame", Frame, {
                    Name = "PrimaryCore",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.48, 0, 0.5, 0),
                    Size = UDim2.new(0, 100, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Visible = false,
                })
            
                local PrimaryColorSequence = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                })
                
                Insert:UICorner(PrimaryCore)
                local PrimaryUIGradient = Insert:UIGradient(PrimaryCore, PrimaryColorSequence)
                
                local SecondaryCore = Create("Frame", PrimaryCore, {
                    Name = "SecondaryCore",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Visible = false,
                })
            
                local SecondaryColorSequence = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
                })
            
                local SecondaryNumberSequence = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.00, 1.00), 
                    NumberSequenceKeypoint.new(1.00, 0.00)
                })
            
                local UIC = Insert:UICorner(SecondaryCore)
                local SecondaryUIGradient = Insert:UIGradient(SecondaryCore, SecondaryColorSequence, SecondaryNumberSequence, 90)
                
                UIC.CornerRadius = UDim.new(0, 4)
                
                local CoreInput = Create("TextButton", PrimaryCore, {
                    Name = "CoreInput",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = ""
                })
            
                local CoreIndicator = Create("ImageLabel", CoreInput, {
                    Name = "CoreIndicator",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 5, 0, 5),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    Image = RbxThumb(5425614532, "Asset", "420x420"),
                })
                
                local Colors = Create("Frame", Frame, {
                    Name = "Colors",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.68, 0, 0.5, 0),
                    Size = UDim2.new(0, 35, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Visible = false,
                })
            
                local ColorsColorSequence = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), 
                    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)), 
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)), 
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)), 
                    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)), 
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
                })
            
                Insert:UICorner(Colors)
                local ColorsUIGradient = Insert:UIGradient(Colors, ColorsColorSequence, nil, 90)
                
                local ColorsInput = Create("TextButton", Colors, {
                    Name = "ColorsInput",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = ""
                })
            
                local ColorsIndicator = Create("ImageLabel", ColorsInput, {
                    Name = "CoreIndicator",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 5, 0, 5),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    Image = RbxThumb(5425614532, "Asset", "420x420"),
                })
                
                function GetColor(UIGradient, Time)
                    local Keypoints = UIGradient.Color.Keypoints
                    
                    for I = 1, table.getn(Keypoints) - 1 do
                        local CurrentKeypoint = Keypoints[I]
                        local NextKeypoint = Keypoints[I + 1]
                        
                        if Time >= CurrentKeypoint.Time and Time <= NextKeypoint.Time then
                            local Change = (Time - CurrentKeypoint.Time) / (NextKeypoint.Time - CurrentKeypoint.Time)
                            
                            return Color3.new(
                                ((NextKeypoint.Value.R - CurrentKeypoint.Value.R) * Change) + CurrentKeypoint.Value.R,
                                ((NextKeypoint.Value.G - CurrentKeypoint.Value.G) * Change) + CurrentKeypoint.Value.G,
                                ((NextKeypoint.Value.B - CurrentKeypoint.Value.B) * Change) + CurrentKeypoint.Value.B
                            )
                        end
                    end
                end
                
                function Lerp(CV1, CV2)
                    local R1, G1, B1 = CV1.R, CV1.G, CV1.B
                    local R2, G2, B2 = CV2.R, CV2.G, CV2.B
                    
                    return Color3.new(
                        R1 * R2,
                        G1 * G2,
                        B1 * B2
                    )
                end
                
                CoreInput.MouseButton1Down:Connect(function()
                    CoreEnabled = true
                end)
                
                ColorsInput.MouseButton1Down:Connect(function()
                    ColorsEnabled = true
                end)
                
                UIS.InputEnded:Connect(function()
                    CoreEnabled = false
                    ColorsEnabled = false
                end)
                
                coroutine.wrap(function()
                    RS.RenderStepped:Connect(function()
                        local Mouse = LP:GetMouse()

                        if CoreEnabled then
                            local ScaleX, ScaleY = math.clamp((Mouse.X - PrimaryCore.AbsolutePosition.X) / PrimaryCore.AbsoluteSize.X, 0, 1), math.clamp((Mouse.Y - PrimaryCore.AbsolutePosition.Y) / PrimaryCore.AbsoluteSize.Y, 0, 1)
                            
                            CoreIndicator.Position = UDim2.new(ScaleX, 0, ScaleY, 0)
                            ColorPicker.BackgroundColor3 = Lerp(GetColor(PrimaryUIGradient, ScaleX), GetColor(SecondaryUIGradient, ScaleY))

                            pcall(Callback, ColorPicker.BackgroundColor3)
                        end
                        
                        if ColorsEnabled then
                            local Scale = math.clamp((Mouse.Y - Colors.AbsolutePosition.Y) / Colors.AbsoluteSize.Y, 0, 1)
                            local CPosX, CPosY = CoreIndicator.Position.X.Scale, CoreIndicator.Position.Y.Scale
                            
                            PrimaryUIGradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
                                ColorSequenceKeypoint.new(1.00, GetColor(ColorsUIGradient, Scale))
                            })
                        
                            ColorsIndicator.Position = UDim2.new(0.5, 0, Scale, 0)
                            ColorPicker.BackgroundColor3 = Lerp(GetColor(PrimaryUIGradient, CPosX), GetColor(SecondaryUIGradient, CPosY))

                            pcall(Callback, ColorPicker.BackgroundColor3)
                        end
                    end)
                end)()
                
                ColorPicker.MouseButton1Click:Connect(function()
                    local PSizeX, PSizeY = PrimaryCore.Size.X, PrimaryCore.Size.Y
                    local CSizeX, CSizeY = Colors.Size.X, Colors.Size.Y
                    local FSizeX, FSizeY = Frame.Size.X, Frame.Size.Y
                    
                    Enabled = not Enabled
                    if Enabled then
                        PrimaryCore.Visible = true
                        SecondaryCore.Visible = true
                        Colors.Visible = true
                        TS:Create(PrimaryCore, TweenInfo.new(0.5, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(PSizeX.Scale, PSizeX.Offset, PSizeY.Scale, 100)}):Play()
                        TS:Create(Colors, TweenInfo.new(0.5, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(CSizeX.Scale, CSizeX.Offset, CSizeY.Scale, 100)}):Play()
                        TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, 105)}):Play()
                    end
                    if not Enabled then
                        TS:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(FSizeX.Scale, FSizeX.Offset, FSizeY.Scale, 25)}):Play()
                        TS:Create(Colors, TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(CSizeX.Scale, CSizeX.Offset, CSizeY.Scale, 0)}):Play()
                        local Tween = TS:Create(PrimaryCore, TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(PSizeX.Scale, PSizeX.Offset, PSizeY.Scale, 0)})
                        Tween:Play()
                        Tween.Completed:Wait()
                        PrimaryCore.Visible = false
                        SecondaryCore.Visible = false
                        Colors.Visible = false
                    end
                end)
            end

            return SectionInit
        end

        return TabInit
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

function Library:AddConnection(Event, Name, Callback)
    if type(Name) == "function" then
        Name, Callback = Callback, Name
    end

    local Connection = Event:Connect(Callback)

    if Name ~= nil then
        Library.Connections[Name] = Connection
    else
        Library.Connections[table.getn(Library.Connections) + 1] = Connection
    end
end

function Library:AddCoroutine(Name, Callback, Arguments)
    if type(Name) == "function" then
        Name, Callback = Callback, Name
        Name, Arguments = Arguments, Name
    end

    local Coroutine = {}
    Coroutine.Status = true
    Coroutine.Function = coroutine.create(function()
        while Coroutine.Status and task.wait() do
            pcall(Callback, unpack(Arguments))
        end
    end)
    
    if Name ~= nil then
        Library.Coroutines[Name] = Coroutine
    else
        Library.Coroutines[table.getn(Library.Connections) + 1] = Coroutine
    end

    coroutine.resume(Coroutine.Function)
end

function Library:Unload()
    for _, Connection in next, Library.Connections do
        Connection:Disconnect()
    end
    for _, Coroutine in next, Library.Coroutines do
        Coroutine.Status = false
        game:GetService("RunService").Stepped:Wait()
        Coroutine.Function = nil
    end
end

return Library
