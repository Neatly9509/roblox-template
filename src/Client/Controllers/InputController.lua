local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WithJanitor = require(ReplicatedStorage.Common.WithJanitor)

local InputController = WithJanitor({})

function InputController:Init()
	print("[InputController] Init")
end

function InputController:Start()
	print("[InputController] Start")

	local inputConnection = UserInputService.InputBegan:Connect(function(input)
		print("User pressed:", input.KeyCode)
	end)

	self._janitor:Add(inputConnection)
end

return InputController
