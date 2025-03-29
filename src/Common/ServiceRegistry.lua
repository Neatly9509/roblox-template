local ServiceRegistry = {}
local services = {}

function ServiceRegistry:Register(name, service)
	services[name] = service
end

function ServiceRegistry:Get(name)
	assert(services[name], `[ServiceRegistry] No service registered under name '{name}'`)
	return services[name]
end

function ServiceRegistry:GetAll()
	return services
end

function ServiceRegistry:WaitFor(name, timeout)
	local startTime = os.clock()
	while not services[name] do
		if os.clock() - startTime > (timeout or 5) then
			error(`[ServiceRegistry] Timed out waiting for service: {name}`)
		end
		task.wait()
	end
	return services[name]
end

return ServiceRegistry
