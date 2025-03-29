local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local TestEZ = require(ReplicatedStorage.Packages.testez)
local Loader = require(ReplicatedStorage.Common.Loader)
local ServiceRegistry = require(ReplicatedStorage.Common.ServiceRegistry)

local servicesPath = ServerScriptService:WaitForChild("Server"):WaitForChild("Services")
Loader.LoadServices(servicesPath) -- ✅ Load services before test

local root = ReplicatedStorage:WaitForChild("Common"):FindFirstChild("__tests__")
if not root then
	warn("[TestRunner] No __tests__ folder found under Common.")
	return
end

print("[TestRunner] Running tests...")

local results = TestEZ.TestBootstrap:run({ root }, TestEZ.Reporters.TextReporter)

if results.failureCount > 0 then
	warn(`[TestRunner] {results.failureCount} test(s) failed.`)
else
	print("[TestRunner] All tests passed!")
end
