--SERVICES
local ProximityPromptService = game:GetService("ProximityPromptService")

-- CONSTANT
local PROXIMITY_ACTION = "Eat"
local EATING_SOUND_ID = "rbxassetid://6748255118"
--MEMBERS
local PlayerModule = require(game.ServerStorage.Modules.PlayerModule)
local PlayerHungerUpdated:RemoteEvent = game.ReplicatedStorage.Network.PlayerHungerUpdated

local function playEatingSound()
    local eatingSound = Instance.new("Sound", game:GetService("Workspace"))
    eatingSound.SoundId = EATING_SOUND_ID
    eatingSound:Play()
end

--detect prompt is triggered
local function onPromptTriggered(promptObject, player)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end
    local foodModel:Instance = promptObject.Parent
    local foodvalue = foodModel.Food.Value
    local currentHunger = PlayerModule.GetHunger(player)
    playEatingSound()
    task.wait(1.4)

    PlayerModule.SetHunger(player, currentHunger + foodvalue)
    PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))
    foodModel:Destroy()
end


-- connect prompt events to handling functions
ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)
