local PlayerHungerUpdated:RemoteEvent = game.ReplicatedStorage.Network.PlayerHungerUpdated
--SERVICES
local Players = game:GetService("Players")

--CONSTANTS
local BAR_FULL_COLLOR = Color3.fromRGB(154, 255, 1)
local BAR_LOW_COLLOR = Color3.fromRGB(254, 154, 2)

--MEMBERS
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud : ScreenGui = PlayerGui:WaitForChild("HUD")
local leftBar : Frame = hud:WaitForChild("LeftBar")
local hungerUi:Frame = leftBar:WaitForChild("Hunger")
local hungerBar : Frame = hungerUi:WaitForChild("Bar")

PlayerHungerUpdated.OnClientEvent:Connect(function(hunger: number)
    -- hunger bar X size update
    hungerBar.Size = UDim2.fromScale(hunger/100, hungerBar.Size.Y.Scale )

    --hunger bar color update
    if hungerBar.Size.X.Scale > 0.50 then
        hungerBar.BackgroundColor3 = BAR_FULL_COLLOR
    else
        hungerBar.BackgroundColor3 = BAR_LOW_COLLOR
    end

end)
