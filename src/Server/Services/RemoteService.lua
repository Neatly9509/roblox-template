local RemoteService = {}

function RemoteService:Init()
	print("[RemoteService] Init") -- 👈 this must show in output
	local folder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or Instance.new("Folder")
	folder.Name = "Remotes"
	folder.Parent = game:GetService("ReplicatedStorage")
	self.RemotesFolder = folder
	self.RemoteEvents = {}
end

function RemoteService:Start()
	print("[RemoteService] Start") -- 👈 this too
	self:RegisterRemote("Ping")
end

function RemoteService:RegisterRemote(name)
	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = self.RemotesFolder
	self.RemoteEvents[name] = remote
	return remote
end

return RemoteService
