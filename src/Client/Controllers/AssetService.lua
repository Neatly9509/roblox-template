local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WithJanitor = require(ReplicatedStorage.Common.WithJanitor)

local AssetService = WithJanitor({})

-- Optional: a library of pre-named asset references
AssetService.Assets = {
	ClickSound = "rbxassetid://123456789",
	ExplosionSound = "rbxassetid://987654321",
	SomeImage = "rbxassetid://555555555",
}

function AssetService:Init()
	print("[AssetService] Init")
end

function AssetService:Start()
	print("[AssetService] Start")

	-- Example preload on startup
	local toPreload = {
		self.Assets.ClickSound,
		self.Assets.ExplosionSound,
	}

	self:PreloadAssets(toPreload)
end

function AssetService:PreloadAssets(assetList)
	if typeof(assetList) ~= "table" then
		warn("[AssetService] Expected table of asset IDs or instances")
		return
	end

	print("[AssetService] Preloading", #assetList, "assets...")

	ContentProvider:PreloadAsync(assetList)

	print("[AssetService] Preloading complete.")
end

function AssetService:Cleanup()
	self._janitor:Cleanup()
end

return AssetService
