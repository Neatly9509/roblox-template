local ServiceRegistry = require(script.Parent.ServiceRegistry)

local Loader = {}

function Loader.LoadServices(path)
	local services = {}

	for _, moduleScript in ipairs(path:GetChildren()) do
		if moduleScript:IsA("ModuleScript") then
			local ok, service = pcall(require, moduleScript)

			if ok and type(service) == "table" then
				-- Register the service globally for other services to access
				ServiceRegistry:Register(moduleScript.Name, service)
				table.insert(services, service)
			else
				warn(`[Loader] Failed to load service {moduleScript.Name}: {service}`)
			end
		end
	end

	-- First pass: call Init()
	for _, service in ipairs(services) do
		if type(service.Init) == "function" then
			local ok, err = pcall(function()
				service:Init()
			end)
			if not ok then
				warn(`[Loader] Error during Init of {service}: {err}`)
			end
		end
	end

	-- Second pass: call Start()
	for _, service in ipairs(services) do
		if type(service.Start) == "function" then
			task.spawn(function()
				local ok, err = pcall(function()
					service:Start()
				end)
				if not ok then
					warn(`[Loader] Error during Start of {service}: {err}`)
				end
			end)
		end
	end

	return services
end

local RunService = game:GetService("RunService")

if RunService:IsServer() then
	game:BindToClose(function()
		for _, service in pairs(require(script.Parent.ServiceRegistry):GetAll()) do
			if type(service.Cleanup) == "function" then
				pcall(function()
					service:Cleanup()
				end)
			end
		end
	end)
end


return Loader
