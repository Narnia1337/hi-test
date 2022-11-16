local Library = {}

function Library:Init()
    local IF = {TabCount = 0}

    local UI = game:GetObjects("rbxassetid://11344255402")[1]

    local Interface = UI["UI"]

    --[[
    if syn then
        syn.protect_gui(Interface)
        Interface.Parent = game:GetService("CoreGui")
    elseif gethui then
        Interface.Parent = gethui()
    else
        Interface.Parent = game:GetService("CoreGui")
    end
    ]]

    Interface.Parent = game:GetService("CoreGui")
    
    local Ids = {
        "rbxthumb://id=6031471479&type=Asset&w=420&h=420",
        "rbxthumb://id=6031471483&type=Asset&w=420&h=420",
    }
    local Temp = {}
    
    for _, Id in ipairs(Ids) do
        local Decal = Instance.new("Decal", workspace)
        Decal.Texture = Id
        Temp[#Temp + 1] = Decal
    end
    
    game:GetService("ContentProvider"):PreloadAsync(Temp)
    
    for _, Decal in ipairs(Temp) do
        Decal:Destroy()
    end

    local Container = Interface["_"]
    local Drag = function(Frame, Speed)
        local Dragging;
        local DragStart;
        local FrameStart;
        local DragInput;
        local DragSpeed = Speed
        
        local function Update(Input)
            local Delta = Input.Position - DragStart
            local NewPosition = UDim2.new(FrameStart.X.Scale, FrameStart.X.Offset + Delta.X, FrameStart.Y.Scale, FrameStart.Y.Offset + Delta.Y)
            
            game:GetService("TweenService"):Create(Frame, TweenInfo.new(DragSpeed, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Position = NewPosition}):Play()
        end
        
        Frame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType["MouseButton1"] then
                Dragging = true
                DragStart = Input.Position
                FrameStart = Frame.Position
                
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState["End"] then
                        Dragging = false
                    end
                end)
            end
        end)
        
        Frame.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType["MouseMovement"] then
                DragInput = Input
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(Input)
            if Input == DragInput and Dragging then
                Update(Input)
            end
        end)
    end

    Drag(Container, 0.3)

    local Main = Container["Main"]

    Main["Tabs"].CanvasSize = UDim2.new(0, Main["Tabs"]:FindFirstChild("UIListLayout").AbsoluteContentSize.X + 250, 0, 0)

    Main["Tabs"]:FindFirstChild("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Main["Tabs"].CanvasSize = UDim2.new(0, Main["Tabs"]:FindFirstChild("UIListLayout").AbsoluteContentSize.X + 250, 0, 0)
    end)
    
    local Mode = false
    
    Main["Mode"].MouseButton1Click:Connect(function()
        Mode = not Mode
    	
    	function MainInverse(CV)
        	return Color3.new(
        		(1 - CV.R) + 0.1,
        		(1 - CV.G) + 0.1,
        		(1 - CV.B) + 0.1
        	)
        end
        
        function SecondaryInverse(CV)
        	return Color3.new(
        		1 - CV.R,
        		1 - CV.G,
        		1 - CV.B
        	)
        end
    
    	Main.BackgroundColor3 = MainInverse(Main.BackgroundColor3)
    
    	for _, Object in ipairs(Main:GetDescendants()) do
    		if Object:IsA("Frame") then
    			Object.BackgroundColor3 = MainInverse(Object.BackgroundColor3)
    		end
    		if Object:IsA("ScrollingFrame") then
    			Object.ScrollBarImageColor3 = SecondaryInverse(Object.ScrollBarImageColor3)
    		end
    		if (Object:IsA("TextButton") or Object:IsA("TextLabel")) and Object.Name ~= "ToggleButton" then
    			Object.BackgroundColor3 = MainInverse(Object.BackgroundColor3)
    			Object.TextColor3 = SecondaryInverse(Object.TextColor3)
    		end
    		if Object:IsA("ImageButton") or Object:IsA("ImageLabel") then
    			Object.BackgroundColor3 = MainInverse(Object.BackgroundColor3)
    			Object.ImageColor3 = SecondaryInverse(Object.ImageColor3)
    		end
    		if Object:IsA("UIStroke") then
    			Object.Color = MainInverse(Object.Color)
    		end
    	end
    
    	if Mode then
    		Main["Mode"].Image = "rbxthumb://id=6031471479&type=Asset&w=420&h=420"
    	end
    	if not Mode then
    		Main["Mode"].Image = "rbxthumb://id=6031471483&type=Asset&w=420&h=420"
    	end
    end)

    local Position = Main["Close"].Position
    Main["Close"].Position = UDim2.new(Position.X.Scale, Position.X.Offset - 2, Position.Y.Scale, Position.Y.Offset)

    Main["Close"].MouseButton1Click:Connect(function()
        Interface:Destroy()
        UI:Destroy()
    end)

    function IF:Tab(Name)
        local TF = {}

        local Tab = UI["Tab"]:Clone()
        Tab.Parent = Main["Tabs"]
        Tab.Name = Name
        Tab.Text = Name
        
        IF["TabCount"] += 1

        local Container = UI["Container"]:Clone()
        Container.Parent = Main["Containers"]
        Container.Visible = (IF["TabCount"] <= 1)
        
        Tab.MouseButton1Click:Connect(function()
            for _, Frame in ipairs(Main["Containers"]:GetChildren()) do
                Frame.Visible = false
            end
            Container.Visible = true
        end)

        local LS = Container["LeftSide"]
        local RS = Container["RightSide"]

        function GetSide()
            if LS:FindFirstChild("UIListLayout").AbsoluteContentSize.Y <= RS:FindFirstChild("UIListLayout").AbsoluteContentSize.Y then
                return LS
            else
                return RS
            end
        end

        function TF:Section(Name)
            local SF = {}
            
            local Section = UI["Section"]:Clone()
            Section.Parent = GetSide()

            Section.Size = UDim2.new(0.99, 0, 0, Section:FindFirstChild("UIListLayout").AbsoluteContentSize.Y + Section:FindFirstChild("UIListLayout").Padding.Offset)

            Section:FindFirstChild("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(0.99, 0, 0, Section:FindFirstChild("UIListLayout").AbsoluteContentSize.Y + Section:FindFirstChild("UIListLayout").Padding.Offset)
            end)
            
            Section["SectionTitle"]["SectionTitleText"]:GetPropertyChangedSignal("Text"):Connect(function()
                Section["SectionTitle"]["SectionTitleText"].Size = UDim2.new(Section["SectionTitle"]["SectionTitleText"].Size.X.Scale, Section["SectionTitle"]["SectionTitleText"].TextBounds.X + 4, Section["SectionTitle"]["SectionTitleText"].Size.Y.Scale, Section["SectionTitle"]["SectionTitleText"].Size.Y.Offset)
            end)
            
            Section["SectionTitle"]["SectionTitleText"].Text = Name
            
            function SF:Label(Text)
                local LBF = {}

                local Label = UI["Paragraph"]:Clone()
                Label.Parent = Section

                Label["ParagraphText"].TextWrapped = true
                Label["ParagraphText"].TextYAlignment = Enum.TextYAlignment.Center

                Label["ParagraphText"]:GetPropertyChangedSignal("Text"):Connect(function()
                    local X = Label.Size.X
                    local Y = Label.Size.Y

                    Label.Size = UDim2.new(X.Scale, X.Offset, Y.Scale, math.max(25, Label["ParagraphText"].TextBounds.Y + 14))
                    Label["ParagraphText"].Size  = UDim2.new(X.Scale, X.Offset, Y.Scale, math.max(25, Label["ParagraphText"].TextBounds.Y + 20))
                end)

                Label["ParagraphText"].Text = Text

                function LBF:Set(Text)
                    Label["ParagraphText"].Text = Text
                end
            end
            
            function SF:Button(Name, Callback)
                local Button = UI["Button"]:Clone()
                Button.Parent = Section
                Button.Name = Name
                Button.Text = Name
                
                Button.MouseButton1Click:Connect(function()
                    Callback()
                end)
            end

            function SF:Toggle(Name, Callback, Options)
                local TGF = {}

                local Enabled = false

                if Options.Enabled then
                    Enabled = Options.Enabled
                end

                local Toggle = UI["Toggle"]:Clone()
                Toggle.Parent = Section
                Toggle.Name = Name
                Toggle["ToggleText"].Text = Name

                function ToggleColor(Value)
                    if Value then
                        game:GetService("TweenService"):Create(Toggle["ToggleButton"], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 255, 180)}):Play()
                    else
                        game:GetService("TweenService"):Create(Toggle["ToggleButton"], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 180, 180)}):Play()
                    end
                end

                ToggleColor(Enabled)

                Toggle["ToggleButton"].MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    ToggleColor(Enabled)
                    Callback(Enabled)
                end)

                function TGF:Get()
                    return Enabled
                end

                function TGF:Set(Value)
                    Enabled = Value
                    ToggleColor(Enabled)
                    Callback(Enabled)
                end

                return TGF
            end

            function SF:Slider(Name, Callback, Options)
                local SLF = {}

                local Default, Min, Max, Precise = 0, 0, 1, false

                if Options.Default then
                    Default = Options.Default
                end
                if Options.Min or Options.Minimum then
                    Min = ((Options.Min ~= nil and Options.Min) or (Options.Minimum ~= nil and Options.Minimum))
                end
                if Options.Max or Options.Maximum then
                    Max = ((Options.Max ~= nil and Options.Max) or (Options.Maximum ~= nil and Options.Maximum))
                end
                if Options.Precise then
                    Precise = Options.Precise
                end

                local Slider = UI["Slider"]:Clone()
                Slider.Parent = Section
                Slider.Name = Name
                Slider["SliderText"].Text = Name

                local Enabled = false

                Slider["SliderMain"]["SliderInput"].MouseButton1Down:Connect(function()
                    Enabled = true
                end)

                Slider["SliderMain"]["SliderFrame"].Size = UDim2.new(math.clamp((Default - Min) / (Max - Min), 0, 1), 0, 1, 0)
                
                if Precise then
                    Slider["ValueText"].Text = string.format("%.03f", Default)
                else
                    Slider["ValueText"].Text = Default
                end
                
                game:GetService("UserInputService").InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Enabled = false
                    end
                end)

                local ReturnValue = 0

                coroutine.wrap(function()
                    game:GetService("RunService").RenderStepped:Connect(function()
                        local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

                        if Enabled then
                            local Percentage = math.clamp((Mouse.X - Slider["SliderMain"].AbsolutePosition.X) / Slider["SliderMain"].AbsoluteSize.X, 0, 1)
                            local Value = ((Max - Min) * Percentage) + Min

                            ReturnValue = Value

                            game:GetService("TweenService"):Create(Slider["SliderMain"]["SliderFrame"], TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(Percentage, 0, 1, 0)}):Play()

                            if Precise then
                                Slider["ValueText"].Text = string.format("%.03f", Value)
                                pcall(Callback, Value)
                            else
                                Slider["ValueText"].Text = math.round(Value)
                                pcall(Callback, math.round(Value))
                            end
                        end
                    end)
                end)()

                function SLF:Get()
                    return ReturnValue
                end

                function SLF:Set(Value)
                    local Percentage = math.clamp((Slider["SliderMain"].AbsolutePosition.X / Slider["SliderMain"].AbsoluteSize.X) * Value, 0, 1)
                    local Value = ((Max - Min) * Percentage) + Min

                    game:GetService("TweenService"):Create(Slider["SliderMain"]["SliderFrame"], TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(Percentage, 0, 1, 0)}):Play()

                    if Precise then
                        Slider["ValueText"].Text = string.format("%.03f", Value)
                        pcall(Callback, Value)
                    else
                        Slider["ValueText"].Text = math.round(Value)
                        pcall(Callback, math.round(Value))
                    end
                end

                return SLF
            end

            function SF:Dropdown(Name, Data, Callback, Options)
                local DDF = {}

                local CurrentData = {}
                local CurrentValue = nil

                local Dropdown = UI["Dropdown"]:Clone()
                Dropdown.Parent = Section
                Dropdown.Name = Name
                Dropdown["DropdownText"].Text = Name

                Dropdown["DropdownInteractable"].MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    
                    local DDX = Dropdown.Size.X
                    local DDY = Dropdown.Size.Y

                    if Enabled then
                        game:GetService("TweenService"):Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DDX.Scale, DDX.Offset, 0, 92)}):Play()
                    end
                    if not Enabled then
                        game:GetService("TweenService"):Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Size = UDim2.new(DDX.Scale, DDX.Offset, 0, 24)}):Play()
                    end
                end)

                local function Setup(Data)
                    for _, Value in next, Data do
                        local Button = Instance.new("TextButton", Dropdown["DropdownContainer"])
                        Button.BackgroundTransparency = 1
                        Button.BorderSizePixel = 0
                        Button.Font = Enum.Font["Gotham"]
                        Button.Name = "DropdownOption"
                        Button.Size = UDim2.new(1, 0, 0, 20)
                        Button.TextColor3 = Color3.fromRGB(0, 0, 0)
                        Button.TextSize = 10

                        if type(Value) == "userdata" then
                            Button.Text = Value.Name
                        else
                            Button.Text = tostring(Value)
                        end

                        Button.MouseButton1Click:Connect(function()
                            pcall(Callback, Value)
                        end)
                    end
                end

                local function Clear()
                    for _, Button in ipairs(Dropdown["DropdownContainer"]:GetChildren()) do
                        if Button:IsA("TextButton") and Button.Name == "DropdownOption" then
                            Button:Destroy()
                        end
                    end
                end

                CurrentData = Data
                Setup(CurrentData)

                function DDF:Get()
                    return CurrentValue
                end

                function DDF:Set(Value)
                    if table.find(CurrentData, Value) then
                        CurrentValue = Value
                        pcall(Callback, Value)
                    end
                end

                function DDF:Update(Data)
                    if type(Data) ~= "table" then
                        Data = {Data}
                    end

                    table.clear(CurrentData)

                    Clear()

                    CurrentData = Data
                    Setup(CurrentData)
                end

                return DDF
            end
            
            return SF
        end
        
        return TF
    end
    
    return IF
end

return Library
