-- Get the required services
local players = game:GetService("Players")

local UI_Handler = {}
UI_Handler.__index = UI_Handler

-- Get the UI
function UI_Handler.new(player)
	local self = setmetatable({}, UI_Handler)
	
	self.playerGui = player.PlayerGui
	self.statHeader = self.playerGui:WaitForChild("Dev_Stats").Header.Stats
	self.currentSpeed = self.statHeader["Current Speed"]
	self.health = self.statHeader.Health
	self.stamina = self.statHeader.Stamina
	self.animation = self.statHeader["Core Animation"]
	self.effects = self.statHeader.Frame
	self.effectsPrefab = self.effects.PREFAB
	
	return self
end

function UI_Handler:ChangeSpeed(newSpeed)
	local val = newSpeed or "nil"
	self.currentSpeed.Text = "Current Walkspeed: " .. val
end

function UI_Handler:ChangeHealth(newHealth)
	local val = newHealth or "nil"
	self.health.Text = "Health: " .. val
end

function UI_Handler:ChangeStamina(newStamina)
	local val = newStamina or "nil"
	self.stamina.Text = "Current Stamina: " .. val
end

function UI_Handler:CoreAnimationChange(newAnim)
	local val =  newAnim or "nil"
	self.animation.Text = "Current Core Animation: " .. tostring(val)
end

function UI_Handler:ChangeEffects(effects)
	
	for i, v in ipairs(self.effects:GetChildren()) do
		if v.Name ~= "PREFAB" and not v:IsA("UIListLayout") and v.Name ~= "Header" then
			v:Destroy()
		end
	end
	
	for i, v in effects do
		local clone = self.effectsPrefab:Clone()
		clone.Parent = self.effects
		clone.Text = tostring(i)
		clone.Name = tostring(i)
		clone.Visible = true
	end
end

function UI_Handler:Destroy()
	setmetatable(self, {})
end

return UI_Handler