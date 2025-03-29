local ReplicatedStorage = game:GetService("ReplicatedStorage")

local REMOTES_FOLDER_NAME = "Remotes"
local TIMEOUT = 5

local Remotes = {}
local cache = {}

local function getRemotesFolder()
	local folder = ReplicatedStorage:FindFirstChild(REMOTES_FOLDER_NAME)
	if folder then return folder end

	folder = ReplicatedStorage:WaitForChild(REMOTES_FOLDER_NAME, TIMEOUT)
	if not folder then
		error(`[Remotes] Folder '{REMOTES_FOLDER_NAME}' not found in ReplicatedStorage`)
	end

	return folder
end

local function getRemote(name, className)
	if cache[name] then
		return cache[name]
	end

	local folder = getRemotesFolder()
	local remote = folder:FindFirstChild(name)

	if not remote then
		remote = folder:WaitForChild(name, TIMEOUT)
	end

	if not remote then
		error(`[Remotes] {className} '{name}' not found in Remotes folder`)
	end

	if remote.ClassName ~= className then
		error(`[Remotes] '{name}' is not a {className} (found {remote.ClassName})`)
	end

	cache[name] = remote
	return remote
end

function Remotes:GetRemoteEvent(name)
	return getRemote(name, "RemoteEvent")
end

function Remotes:GetRemoteFunction(name)
	return getRemote(name, "RemoteFunction")
end

return Remotes
