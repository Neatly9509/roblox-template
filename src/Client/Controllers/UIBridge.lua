local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Common.Remotes)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local remoteName = "Notify_" .. player.UserId
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild(remoteName)
local UIBridge = {}

remote.OnClientEvent:Connect(function(message)
	print("[UIBridge] Got notify:", message)
end)

function UIBridge:Init()
	print("[UIBridge] Init")
end

function UIBridge:Start()
	print("[UIBridge] Start")

	local Ping = Remotes:GetRemoteEvent("Ping")

	task.wait(1)
	print("[UIBridge] Firing Ping")
	Ping:FireServer()
end

return UIBridge
