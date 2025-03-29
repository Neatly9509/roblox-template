local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServiceRegistry = require(game.ReplicatedStorage.Common.ServiceRegistry)
local WithJanitor = require(ReplicatedStorage.Common.WithJanitor)
local MyService = WithJanitor({})

function MyService:Init()
	print("[MyService] Init")
end

function MyService:Start()
	print("[MyService] Start")

	local connection = Players.PlayerAdded:Connect(function(player)
		print(player.Name .. " joined")
	end)

	self._janitor:Add(connection)
end

function MyService:Start()
	print("[MyService] Start")

	local RemoteSignalService = ServiceRegistry:Get("RemoteSignalService")
	local Players = game:GetService("Players")

	Players.PlayerAdded:Connect(function(player)
		task.wait(1) -- allow remotes to register
		RemoteSignalService:SendToPlayer(player, "Notify", "Welcome to the game!")
	end)
end

return MyService
