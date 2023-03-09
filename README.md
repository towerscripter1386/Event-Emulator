# Event-Emulator
Small project which I designed for personal use in the first place.

This module will provide somewhat emulation of RBXScriptSignals. 
To use it in your metatable just use the part of the code here:
```lua
EventEmulator = require(PathToModuleScript)

metatable = setmetatable({
    SomeEvent = EventEmulator:EmulateEvent(ValueToTrack,ValueToGive) -- if ValueToGive is nil then it won't give any argument for the function
},{})

metatable.SomeEvent:Connect(function()
    -- your code is here
)
```
