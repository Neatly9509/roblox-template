local Logger = {}

Logger.log = function(message)
    print("[LOG]: " .. message)
end

Logger.error = function(message)
    warn("[ERROR]: " .. message)
end

Logger.debug = function(message)
    if game:GetService("RunService"):IsStudio() then
        print("[DEBUG]: " .. message)
    end
end

return Logger
