NPCInteracted = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("NPCInteracted")

ClickDetector = script.Parent:WaitForChild("ClickDetector")

ClickDetector.MouseClick:Connect(function(Player)
	NPCInteracted:FireClient(Player, "EquipmentSeller")
end)
