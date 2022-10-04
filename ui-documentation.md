# ui-library

### Documentation
```lua
local Library = loadstring(game:HttpGetAsync("link-to-library"))();

-- Library:Create(LibraryName)
local UI = Library:Create("UI Library")

-- [UIVar]:Keybind(Key)
-- Key = Must be a valid KeyCode (https://developer.roblox.com/en-us/api-reference/enum/KeyCode)
UI:Keybind("LeftAlt")

-- [UIVar]:Tab(TabName)
local Tab = UI:Tab("Tab")

-- [TabVar]:Section(SectionName)
local Section = Tab:Section("Section")

-- [TabVar]:Info(LabelText)
local Info = Tab:Info("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultricies mi eget mauris pharetra et.")

-- [SectionVar]:Label(LabelText)
local Info = Section:Label("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ultricies mi eget mauris pharetra et.")

-- [LabelVar]:UpdateLabel(LabelText)
Info:UpdateLabel("New text here")

-- [SectionVar]:Button(ButtonName, Callback)
local Button = Section:Button("Button", function()
    print("Hello world!")
end)

-- [SectionVar]:Box(BoxName, Callback)
local Box = Section:Box("Box", function(Value)
    print(Value)
end)

-- [SectionVar]:Toggle(ToggleName, Callback, Options)
-- Options = {Enabled = true/false}
local Toggle = Section:Toggle("Toggle", function(Value)
    print(Value)
end, {Enabled = true})

-- [SectionVar]:Slider(SliderName, Callback, Options)
-- Options = {Min = #, Max = #, Precise = true/false, Default = # (Must be Min or higher)}
local Slider = Section:Slider("Slider", function(Value)
    print(Value)
end, {Min = 40000000, Max = 50000000, Precise = false, Default = 40000000})

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

-- Destroys the GUI
UI:Destroy()
```
