return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local ServiceRegistry = require(ReplicatedStorage.Common.ServiceRegistry)

	describe("PlayerDataService", function()
		it("should return default data for unknown player", function()
			local PlayerDataService = ServiceRegistry:Get("PlayerDataService")
			local fakePlayer = { UserId = 12345, Name = "TestPlayer" }
			local data = PlayerDataService:GetData(fakePlayer)

			expect(data).to.be.ok()
			expect(data.XP).to.equal(0)
			expect(data.Coins).to.equal(0)
		end)
	end)
end
