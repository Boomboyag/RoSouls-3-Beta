-- Required roblox services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local remoteFolder = replicatedStorage:WaitForChild("Remote")

-- The character list
local currentPlayerCharacter = {}

