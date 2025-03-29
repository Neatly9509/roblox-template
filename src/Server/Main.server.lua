local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ServiceRegistry = require(ReplicatedStorage.Common.ServiceRegistry)

-- Correct reference to PlayerDataService in ServerScriptService.Server.Services
local PlayerDataService = require(ServerScriptService.Server.Services.PlayerDataService)

-- Registering PlayerDataService in the ServiceRegistry
ServiceRegistry:Register('PlayerDataService', PlayerDataService)

for _, child in ipairs(ServerScriptService.Server.Services:GetChildren()) do
    print("Found service module:", child.Name)
end

print("[Server] Main started")

-- Load all services (if required)
local Loader = require(ReplicatedStorage.Common.Loader)
Loader.LoadServices(ServerScriptService.Server.Services)

local Logger = require(ReplicatedStorage.Common.Logger)

-- Test logging for server-side actions
Logger.log("Server-side log message.")
Logger.error("Server-side error message.")
Logger.debug("Server-side debug message.")

-- Test during some other event, such as player joining
game.Players.PlayerAdded:Connect(function(player)
    Logger.log(player.Name .. " has joined the game!")
end)
