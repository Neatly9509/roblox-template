local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Logger = require(game.ReplicatedStorage.Common.Logger)
local WithJanitor = require(ReplicatedStorage.Common.WithJanitor)
local ServiceRegistry = require(ReplicatedStorage.Common.ServiceRegistry)

local DevController = WithJanitor({})
local player = Players.LocalPlayer

local debugRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DebugServiceRequest")

-- Initialize Commands table first
local Commands = {}

Commands.reload = function(args)
	local name = args[1]
	if not name then
		warn("[DevController] Usage: /reload <ServiceOrControllerName>")
		return
	end

	local module = ServiceRegistry:Get(name)
	if module and type(module.Start) == "function" then
		print(string.format("[DevController] Restarting %s...", name))
		if type(module.Cleanup) == "function" then
			module:Cleanup()
		end
		module:Start()
	else
		warn(string.format("[DevController] Could not reload %s. Make sure it's registered and has a Start method.", name))
	end
end

Commands.debug = function(args)
	local name = args[1]
	if not name then
		warn("[DevController] Usage: /debug <ClientControllerName>")
		return
	end

	local module = ServiceRegistry:Get(name)
	if not module then
		warn(string.format("[DevController] '%s' is not registered on the client.", name))
		return
	end

	print(string.format("[DevController] Debug dump for %s:", name))
	print(module)
end

Commands.sdebug = function(args)
	local name = args[1]
	if not name then
		warn("[DevController] Usage: /sdebug <ServerServiceName>")
		return
	end

	local result = debugRemote:InvokeServer(name)

	if result and result.success then
		print(string.format("[DevController] Server debug success: %s", result.message))
	else
		warn(string.format("[DevController] Server debug failed: %s", result.message))
	end
end

Commands.give = function(args)
	local targetPlayer = Players:FindFirstChild(args[1])
	local amount = tonumber(args[2])

	if not targetPlayer or not amount then
		warn("[DevController] Usage: /give <playerName> <amount>")
		return
	end

	-- Ensure PlayerData exists
	local playerData = targetPlayer:FindFirstChild("PlayerData")
	if not playerData then
		-- Create PlayerData if it doesn't exist
		playerData = Instance.new("Folder")
		playerData.Name = "PlayerData"
		playerData.Parent = targetPlayer
		local coins = Instance.new("IntValue")
		coins.Name = "Coins"
		coins.Value = 0
		coins.Parent = playerData
		local xp = Instance.new("IntValue")
		xp.Name = "XP"
		xp.Value = 0
		xp.Parent = playerData
		print("[DevController] Created new PlayerData for " .. targetPlayer.Name)
	end

	-- Correct usage of .Value for arithmetic
	playerData.Coins.Value = playerData.Coins.Value + amount
	print(string.format("[DevController] Gave %d coins to %s", amount, targetPlayer.Name))
end

Commands.tp = function(args)
	local player1 = Players:FindFirstChild(args[1])
	local player2 = Players:FindFirstChild(args[2])

	if not player1 or not player2 then
		warn("[DevController] Usage: /tp <player1> <player2>")
		return
	end

	-- Teleport player1 to player2
	player1.Character:MoveTo(player2.Character.HumanoidRootPart.Position)
	print(string.format("[DevController] Teleported %s to %s", player1.Name, player2.Name))
end

Commands.reset = function(args)
	local targetPlayer = Players:FindFirstChild(args[1])

	if not targetPlayer then
		warn("[DevController] Usage: /reset <playerName>")
		return
	end

	-- Ensure PlayerData exists
	local playerData = targetPlayer:FindFirstChild("PlayerData")
	if not playerData then
		-- Create PlayerData if it doesn't exist
		playerData = Instance.new("Folder")
		playerData.Name = "PlayerData"
		playerData.Parent = targetPlayer
		local coins = Instance.new("IntValue")
		coins.Name = "Coins"
		coins.Value = 0
		coins.Parent = playerData
		local xp = Instance.new("IntValue")
		xp.Name = "XP"
		xp.Value = 0
		xp.Parent = playerData
		print("[DevController] Created new PlayerData for " .. targetPlayer.Name)
	end

	-- Reset PlayerData values
	playerData.Coins.Value = 0
	playerData.XP.Value = 0
	print(string.format("[DevController] Reset %s's data", targetPlayer.Name))
end

function DevController:Init()
	print("[DevController] Init")

	TextChatService.OnIncomingMessage = function(message)
		if message.TextSource and message.Text then
			local text = message.Text
			if not text:match("^/") then return end

			-- Improved argument parsing
			local split = text:sub(2):split(" ")
			local cmd = split[1]:lower()
			table.remove(split, 1) -- Remove the command itself

			-- Ensure args are being passed properly
			if Commands[cmd] then
				Commands[cmd](split)
			else
				warn(string.format("[DevController] Unknown command: /%s", cmd))
			end
		end
	end
end

function DevController:Start()
	print("[DevController] Start")
end

function DevController:Cleanup()
	TextChatService.OnIncomingMessage = nil
	self._janitor:Cleanup()
end

-- Example test in DevController
Logger.log("This is a log message.")        -- Normal log message
Logger.error("This is an error message.")   -- Error log message
Logger.debug("This is a debug message.")    -- Debug log message (only in Studio)

-- You can also test logging during certain events, like when a command is run:
local function onSomeCommandExecuted()
    Logger.log("Some command was executed.")
end

-- Test by calling it
onSomeCommandExecuted()

return DevController
