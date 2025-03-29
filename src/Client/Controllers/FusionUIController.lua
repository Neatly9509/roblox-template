local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local WithJanitor = require(ReplicatedStorage.Common.WithJanitor)
local Fusion = require(ReplicatedStorage.Packages.Fusion)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed

local FusionUIController = WithJanitor({})

function FusionUIController:Init()
	print("[FusionUIController] Init")
end

function FusionUIController:Start()
	print("[FusionUIController] Start")

	local player = Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FusionHUD"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = player:WaitForChild("PlayerGui")

	self._janitor:Add(screenGui)

	local coins = Value(0)

	-- Fake data update every 2 seconds (replace with real data later)
	task.spawn(function()
		local amount = 0
		while true do
			amount += 5
			coins:set(amount)
			task.wait(2)
		end
	end)

	local label = New("TextLabel")({
		Size = UDim2.fromScale(0.25, 0.1),
		Position = UDim2.fromScale(0.375, 0.02),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		Text = Computed(function()
			return "Coins: " .. tostring(coins:get())
		end),
		Parent = screenGui
	})

	self._janitor:Add(label)
end

return FusionUIController
