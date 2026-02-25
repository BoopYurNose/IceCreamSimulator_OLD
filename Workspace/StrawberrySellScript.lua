IceCreamSellEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("IceCreamSellEvent")

ClickDetector = script.Parent:WaitForChild("ClickDetector")

ClickDetector.MouseClick:Connect(function(Player)
	IceCreamSellEvent:FireClient(Player, "Strawberry")
end)
