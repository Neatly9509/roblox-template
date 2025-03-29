local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local WithJanitor = require(ReplicatedStorage.Common.WithJanitor)
local janitor = require(ReplicatedStorage.Packages.janitor)

local RemoteSignalService = WithJanitor({})
RemoteSignalService._remotes = {}

function RemoteSignalService:Init()
	print("[RemoteSignalService] Init")

	local folder = ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
	folder.Name = "Remotes"
	folder.Parent = ReplicatedStorage

	self._remotesFolder = folder

	-- Cleanup remotes on player leave
	self._janitor:Add(Players.PlayerRemoving:Connect(function(player)
		self:CleanupPlayerRemotes(player)
	end))
end

function RemoteSignalService:Start()
	print("[RemoteSignalService] Start")
end

function RemoteSignalService:GetOrCreateRemoteForPlayer(player, name)
	local remoteName = `{name}_{player.UserId}`

	if self._remotes[remoteName] then
		return self._remotes[remoteName]
	end

	local remote = Instance.new("RemoteEvent")
	remote.Name = remoteName
	remote.Parent = self._remotesFolder

	self._remotes[remoteName] = remote
	return remote
end

function RemoteSignalService:SendToPlayer(player, name, ...)
	local remote = self:GetOrCreateRemoteForPlayer(player, name)
	remote:FireClient(player, ...)
end

function RemoteSignalService:CleanupPlayerRemotes(player)
	for key, remote in pairs(self._remotes) do
		if key:match(`_%d+$`) == `_{player.UserId}` then
			remote:Destroy()
			self._remotes[key] = nil
		end
	end
end

function RemoteSignalService:Cleanup()
	print("[RemoteSignalService] Cleanup")
	self._janitor:Cleanup()
end

return RemoteSignalService
