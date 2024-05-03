-- Valid sound ID's
local validIDs = {

    ["Rolling"] = {

    },

    ["Footsteps"] = {

    },
}

-- Required components
local requestSoundServer = Instance.new("BindableEvent", script)
requestSoundServer.Name = "RequestSoundServer"
local requestSoundClient = Instance.new("RemoteEvent", script)
requestSoundClient.Name = "RequestSoundClient"
local requestSoundClientUnreliable = Instance.new("UnreliableRemoteEvent", script)
requestSoundClientUnreliable.Name = "RequestSoundClientUnreliable"

-- The function to make sure a given ID is valid
local function CheckID(id, type) : boolean

    if not type or id then
        warn("Not all sound data was provided!")
        return false
    end
    
    -- Find the correct table
    for i, v in pairs(validIDs) do
        
        if i == type then
            
            -- Attempt to find the given ID
            local soundTable = v
            if table.find(soundTable, id) then
                return true
            end
        end
    end

    warn("Sound ID " .. id .. " is not valid!")
    return false
end

-- The function to play a sound
local function PlaySound(soundID, soundType, parent)
    
    -- Make sure the ID was provided
    if not soundID then
        warn("Sound ID not provided")
        return
    end

    -- Make sure the sound ID is valid
    if not CheckID(soundID, soundType) then return end
    
end