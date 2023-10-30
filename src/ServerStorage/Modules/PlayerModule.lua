local PlayerModule = {}

--SERVICES
local Players= game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
--CONSTANTS
local PLAYER_DEFAULT_DATA = {
    hunger = 100,
    inventory = {},
    level = 1,
}

--MEMBERS
local playersCached = {} --- dict com todos os players
local database = DataStoreService:GetDataStore("Survival")
local PlayerLoaded:BindableEvent = game.ServerStorage.BindableEvents.PlayerLoaded
local PlayerUnloaded:BindableEvent = game.ServerStorage.BindableEvents.PlayerUnloaded


function  PlayerModule.Isloaded(player:Player): boolean
    local Isloaded:boolean = playersCached[player.UserId] and true or false
    return Isloaded

end
local function normalizeHunger(hunger:number):number
    if hunger < 0 then
        hunger = 0
    end
    if hunger > 100 then
        hunger = 100
    end
    return hunger
end
-- adiciona fome ao player recebido

function PlayerModule.SetHunger(player:Player, hunger:number)
    hunger = normalizeHunger(hunger)
    playersCached[player.UserId].hunger = hunger

end

-- pega a fome do player recebido
function PlayerModule.GetHunger(player:Player):number
    local hunger =  normalizeHunger(playersCached[player.UserId].hunger)
    return hunger
end

local function onPlayerAdded(player:Player)
    player.CharacterAdded:Connect(function(_)
        local data = database:GetAsync(player.UserId)
        if not data then
            data = PLAYER_DEFAULT_DATA
        end
        playersCached[player.UserId] = data

        -- player carregou
        PlayerLoaded:Fire(player)
    end)
end

local function onPlayerRemoving(player:Player)
    PlayerUnloaded:Fire(player)
    playersCached[player.UserId] = nil
end


Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)


return PlayerModule