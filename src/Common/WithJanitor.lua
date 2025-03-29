local Janitor = require(game:GetService("ReplicatedStorage").Packages.janitor)

return function(service)
	service._janitor = Janitor.new()

	function service:Cleanup()
		service._janitor:Cleanup()
	end

	return service
end
