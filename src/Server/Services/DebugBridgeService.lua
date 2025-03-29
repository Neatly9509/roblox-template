local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WithJanitor = require(ReplicatedStorage.Common.WithJanitor)
local ServiceRegistry = require(ReplicatedStorage.Common.ServiceRegistry)

local DebugBridgeService = WithJanitor({})
local REMOTE_NAME = "DebugServiceRequest"

function DebugBridgeService:Init()
	print("[DebugBridgeService] Init")

	-- Create or reuse the RemoteFunction
	local remote = Instance.new("RemoteFunction")
	remote.Name = REMOTE_NAME
	remote.Parent = ReplicatedStorage:WaitForChild("Remotes")

	self._janitor:Add(remote)

	remote.OnServerInvoke = function(player, moduleName)
		print("[DebugBridgeService] OnServerInvoke fired")
		print(`[DebugBridgeService] RunService:IsStudio() = {tostring(RunService:IsStudio())}`)
		print(`[DebugBridgeService] player.Name = {player.Name}, player.UserId = {player.UserId}`)

		if RunService:IsStudio() then
			print("[DebugBridgeService] Bypassing auth (Studio mode)")
		else
			local ALLOWED_USER_IDS = {
				[4459184122] = true, -- Replace with your actual UserId
			}
			if not ALLOWED_USER_IDS[player.UserId] then
				warn(`[DebugBridgeService] Unauthorized debug request from {player.Name} (UserId: {player.UserId})`)
				return { success = false, message = "Unauthorized" }
			end
		end

		local module = ServiceRegistry:Get(moduleName)

		if not module then
			return { success = false, message = `No module registered under '{moduleName}'` }
		end

		print(`[DebugBridgeService] Debug dump for {moduleName}:`)
		print(module)

		return { success = true, message = `Dumped module: {moduleName}` }
	end
end

function DebugBridgeService:Start()
	print("[DebugBridgeService] Start")
end

function DebugBridgeService:Cleanup()
	self._janitor:Cleanup()
end

return DebugBridgeService
