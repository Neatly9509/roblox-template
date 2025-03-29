local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local ReactUI = {}

function ReactUI:Init()
	print("[ReactUI] Init")
end

function ReactUI:Start()
	print("[ReactUI] Start")

	local gui = Instance.new("ScreenGui")
	gui.Name = "RootUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	local App = React.createElement("TextButton", {
		Text = "Click Me!",
		Size = UDim2.fromScale(0.2, 0.1),
		Position = UDim2.fromScale(0.4, 0.45),
		[React.Event.MouseButton1Click] = function()
			print("You clicked the React button!")
		end
	})

	local root = ReactRoblox.createRoot(gui)
	root:render(App)
end

return ReactUI
