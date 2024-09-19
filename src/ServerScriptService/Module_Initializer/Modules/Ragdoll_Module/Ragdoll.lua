-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")

-- Required folders
local remoteFolder = replicatedStorage:WaitForChild("Remote")
local bindableFolder = replicatedStorage:WaitForChild("Bindable")

-- Required events
local remoteEvent : RemoteEvent = remoteFolder:WaitForChild("Ragdoll_Remote")
local bindableEvent : BindableEvent = bindableFolder:WaitForChild("Ragdoll_Bindable")

local module = {}

module.Name = "Ragdoll Module"

-- The function to be called
function module:CallFunction(wantToRagdoll : boolean, silly : boolean)

    -- Make sure the character is alive
    if not self.alive and not wantToRagdoll then return end

    -- The character
    local character = self.model
    local humanoid = self.humanoid

    -- Whether or not the character is already ragdolled
    local ragdoll = collectionService:HasTag(character, "Ragdoll")

    -- Make sure the required variables were provided
    if wantToRagdoll == nil then 
        wantToRagdoll = not ragdoll
    end

    -- Check if we want to start the ragdoll
    if wantToRagdoll and not ragdoll then

        -- Change the humanoid state
		humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        self:ApplyImpulse(self.torso, 10)
	elseif ragdoll then
        
        -- Change the humanoid state
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

    -- Fire the event
    if self.onServer then bindableEvent:Fire(character, wantToRagdoll) else remoteEvent:FireServer(wantToRagdoll) end

    return 0
end

return module