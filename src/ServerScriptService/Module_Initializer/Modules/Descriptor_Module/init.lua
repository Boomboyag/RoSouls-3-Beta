-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")

local module = {}

-- The function to initialize the module
function module:Init()
    
    -- Add in the bindable event
    local bindableEvent = Instance.new("BindableEvent")
    bindableEvent.Name = "Manage_Character_Descriptor"

    -- Fired when the bindable event is fired
    bindableEvent.Event:Connect(function(character, descriptor, remove, lifeTime)

        -- Check if want to remove or add the descriptor
        if not remove then

             -- Add the descriptor
             collectionService:AddTag(character, descriptor)

             -- Remove the descriptor after a certain number of seconds if applicable
             if lifeTime then
                task.wait(lifeTime)
                if not character then return end
                collectionService:RemoveTag(character, descriptor)
             end
             return
        else

             collectionService:RemoveTag(character, descriptor)
        end
    end)

    -- Get the bindable folder
    local bindableFolder = replicatedStorage:FindFirstChild("Bindable")
    if not bindableFolder then
        
        bindableFolder = Instance.new("Folder")
        bindableFolder.Name = "Bindable"
        bindableFolder.Parent = replicatedStorage
    end
    bindableEvent.Parent = bindableFolder
end

return module