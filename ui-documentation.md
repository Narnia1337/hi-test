# ui-library

### Documentation
```lua
local Library = loadstring(game:HttpGetAsync("link-to-library"))();

-- Library:Create(LibraryName)
local UI = Library:Create("UI Library")

local Object;

-- [UIVar]:Keybind(Key)
-- Key = Must be a valid KeyCode (https://developer.roblox.com/en-us/api-reference/enum/KeyCode)
UI:Keybind("LeftAlt")

-- [UIVar]:Tab(TabName)
local Tab = UI:Tab("Tab")

-- [TabVar]:Section(SectionName)
local Section = Tab:Section("Section")

-- [TabVar]:Info(LabelText)
local Info = Tab:Info("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultricies mi eget mauris pharetra et.")

-- [InfoVar]:GetObject()
Object = Info:GetObject()
print(Object.Name)

-- [SectionVar]:Label(LabelText)
local Label = Section:Label("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultricies mi eget mauris pharetra et.")

-- [LabelVar]:UpdateLabel(LabelText)
Info:UpdateLabel("New text here")

-- [LabelVar]:GetObject()
Object = Label:GetObject()
print(Object.Name)

-- [SectionVar]:Button(ButtonName, Callback)
local Button = Section:Button("Button", function()
    print("Hello world!")
end)

-- [ButtonVar]:GetObject()
Object = Button:GetObject()
print(Object.Name)

-- [SectionVar]:Box(BoxName, Callback)
local Box = Section:Box("Box", function(Value)
    print(Value)
end)

-- [BoxVar]:GetObject()
Object = Box:GetObject()
print(Object.Name)

-- [SectionVar]:Toggle(ToggleName, Callback, Options)
-- Options = {Enabled = true/false}
local Toggle = Section:Toggle("Toggle", function(Value)
    print(Value)
end, {Enabled = true})

-- [ToggleVar]:GetValue()
print(Toggle:GetValue())

-- [ToggleVar]:SetValue(Value)
Toggle:SetValue(false)

-- [ToggleVar]:SetColorValues(ColorValues)
-- ColorValues = Must be a table containing values for "true" and "false"
Toggle:SetColorValues({
    [true] = Color3.new(0.4, 0.7, 0.1),
    [false] = Color3.new(1, 0.2, 0.5),
})

-- [ToggleVar]:GetObject()
Object = Toggle:GetObject()
print(Object.Name)

-- [SectionVar]:Slider(SliderName, Callback, Options)
-- Options = {Min = #, Max = #, Precise = true/false, Default = # (Must be Min or higher)}
local Slider = Section:Slider("Slider", function(Value)
    print(Value)
end, {Min = 40000000, Max = 50000000, Precise = false, Default = 40000000})

-- [SliderVar]:GetValue()
print(Slider:GetValue())

-- [SliderVar]:SetValue(Value)
Slider:SetValue(42000000)

-- [SectionVar]:Dropdown(DropdownName, Data, Callback, Options)
-- Data = Must be a table
-- Options = {Default = any-piece-of-data}
local Dropdown = Section:Dropdown("Dropdown", {"Option 1", "Option 2", "Option 3"}, function(Value)
    print(Value)
end, {Default = "Option 2"})

-- [DropdownVar]:UpdateData(Data)
-- Data = Must be a table
Dropdown:UpdateData({"Option 4", "Option 5", "Option 6"})

-- [DropdownVar]:AddData(Data)
-- Data = Must be a table
Dropdown:AddData({"Option 7", "Option 8", "Option 9"})

-- [DropdownVar]:GetObject()
Object = Dropdown:GetObject()
print(Object.Name)

-- Destroys the GUI
UI:Destroy()
```
