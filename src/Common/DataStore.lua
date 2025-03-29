local DataStore = {}

-- Mocked function to simulate DataStore behavior
function DataStore:GetData(player)
    -- Simulate a data retrieval, returning a default mock data
    return {
        level = 1,
        experience = 0
    }
end

-- Mocked function to simulate saving data
function DataStore:SetData(player, data)
    -- Simulate saving data (this is where you'd connect to DataStore in a real scenario)
    print(player.Name .. " data saved: ", data)
end

return DataStore
