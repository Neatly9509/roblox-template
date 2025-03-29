local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Common.Loader)

print("[Client] Main started")

local controllersPath = script.Parent.Controllers
Loader.LoadServices(controllersPath)
