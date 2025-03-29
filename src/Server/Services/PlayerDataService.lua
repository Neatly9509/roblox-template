local PlayerDataService = {}

-- Mocked GetData function (returns mock player data)
function PlayerDataService:GetData(player)
    -- Returning mock data with 'XP' and 'Coins' as expected in the test
    return {
        XP = 0,
        Coins = 0
    }
end

-- Mocked SetData function (simulated saving of player data)
function PlayerDataService:SetData(player, data)
    -- In a real case, we'd store this data in a DataStore
    print(player.Name .. " data saved: ", data)
end

return PlayerDataService
