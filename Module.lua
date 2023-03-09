--   Copyright 2023 Arsenij Ivashenko
--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at

--       http://www.apache.org/licenses/LICENSE-2.0

--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an Event-Emulator BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 --  See the License for the specific language governing permissions and
--   limitations under the License.

local module = {}
function module:EmulateEvent(ValueToTrack,ValueToGive) 
	local Event = setmetatable({},{})
	
	function Event:Connect(a) 
		local Signal = setmetatable({},{})
		local Trigger = true
		local Function = a
		local Corot
		if ValueToGive then
			Corot = coroutine.create(Function(ValueToGive))
		else
			Corot = coroutine.create(Function)
		end
		local OldValue = ValueToTrack
		local EventToCancel = game:GetService("RunService").Heartbeat:Connect(function()
			if OldValue ~= ValueToTrack and Trigger == true then
				Trigger = false
				coroutine.resume(Corot)
			else
				Trigger = true
				OldValue = ValueToTrack
			end
		end)
		function Signal:Disconnect()
			if EventToCancel then
				EventToCancel:Disconnect()
				coroutine.close(Corot)
			end
		end		
		return Signal
	end
	
	function Event:Once(a)
		local Signal = setmetatable({},{})
		local Trigger = true
		local Function = a
		local Corot
		if ValueToGive then
			Corot = coroutine.create(Function(ValueToGive))
		else
			Corot = coroutine.create(Function)
		end
		local OldValue = ValueToTrack
		local EventToCancel = game:GetService("RunService").Heartbeat:Connect(function()
			if OldValue ~= ValueToTrack and Trigger == true then
				Trigger = false
				coroutine.resume(Corot)
				repeat
					task.wait()
				until coroutine.status(Corot) == "suspended"
				coroutine.close(Corot)
			else
				OldValue = ValueToTrack
			end
		end)
		function Signal:Disconnect()
			if EventToCancel then
				EventToCancel:Disconnect()
				coroutine.close(Corot)
			end
		end		
		return Signal
	end
	
	function Event:Wait()
		local IsFired = false
		local OldValue = ValueToTrack
		local EventToCancel = game:GetService("RunService").Heartbeat:Connect(function()
			if OldValue ~= ValueToTrack and IsFired == false then
				IsFired = true
			else
				OldValue = ValueToTrack
			end
		end)
		repeat
			task.wait()
		until IsFired == true
		EventToCancel:Disconnect()
	end
	return Event
end
return module
