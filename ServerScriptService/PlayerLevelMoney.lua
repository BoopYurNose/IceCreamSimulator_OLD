local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEventsFolder = Instance.new("Folder", ReplicatedStorage)
RemoteEventsFolder.Name = "RemoteEvents"

local RemoteEventNames = {
	"PlayerCash",
	"IceCreamBought",
	"SuccessBoughtOrFailed",
	"PlayerExp",
	"PlayerLevelRemote",
	"SellServerCommunication",
	"ItemSold",
	"IceCreamSellSound",
	"NPCInteracted",
	"IceCreamSellEvent",
	"ItemPurchasedEvent",
	"ItemsOwnedCheck",
	"PlayerGemsAmount",
	"ItemEquipEvent",
	"EquipmentNotify",
	"QuestCompleteEvent"
}

local RemoteEvents = {}
for Key, Value in RemoteEventNames do
	RemoteEvents[Value] = Instance.new("RemoteEvent", RemoteEventsFolder) -- creates all the remote events
	RemoteEvents[Value].Name = Value
end


-- PlayerStats
local PlayerMoney = 0
local PlayerLevel = 1
local PlayerExperiencePoints = 0
local ExperienceCap = 40 -- Base Level Cap for experience gain
local IceCreamAmount = 0 -- Amount of IceCream Player is holding
local GemsAmount = 0

local IceCreamValues = { -- Ice cream and how much they cost to purchase
	["Vanilla"] = 0,
	["Strawberry"] = 2,
}

local InventoryItemValues = { -- Items you can buy that allow you to hold more Ice Cream and the values are how much iceCream they can hold
	["Hand"] = 2,
	["Tray"] = 5,
}

local InventoryItemPrice = { -- Prices of Items you can buy (Same script in gui local script too!)
	["Hand"] = 0, -- FREE
	["Tray"] = 5,
}
-- make table for already owned items

local OwnedItems = {
	"Hand",
}

local ItemCurrentlyEquipped = { -- what the player has equipped to hold ice cream
	["Hand"] = 2, -- The key is equal to the item Name and the value is how many item slots it has
}

local IceCreamOwned = { -- the ice cream and the amount they have
	["VanillaOwned"] = 0, -- amount of ice cream player owns
	["StrawberryOwned"] = 0
}

local SalesPrice = { -- how much you earn from each sale depending on ice cream
	["VanillaSale"] = 1,
	["StrawberrySale"] = 3
}


game.Players.PlayerAdded:Connect(function(player) -- upon joining updates player with correct money amount and level
	RemoteEvents["PlayerLevelRemote"]:FireClient(player, PlayerLevel) -- upon joining sending player level
	RemoteEvents["PlayerCash"]:FireClient(player, PlayerMoney) -- upon joining sending player money
	RemoteEvents["PlayerExp"]:FireClient(player, PlayerExperiencePoints)
	RemoteEvents["PlayerGemsAmount"]:FireClient(player, GemsAmount)
	
	for i = 1, #OwnedItems do
		RemoteEvents["ItemsOwnedCheck"]:FireClient(player, OwnedItems[i]) -- Checks what items you have and what you don't have
	end

end)


RemoteEvents["QuestCompleteEvent"].OnServerEvent:Connect(function(player, QuestCompleted)
	if QuestCompleted == "FirstQuestComplete" then
		PlayerMoney = PlayerMoney + 5
		RemoteEvents["PlayerCash"]:FireClient(player, PlayerMoney)
	end
end)



-- function for leveling up
local function LevelUp(Player)
	if PlayerExperiencePoints >= ExperienceCap then -- checking if player can level up
		PlayerExperiencePoints = 0 -- resetting PlayerExp back to 0 after leveling up

		RemoteEvents["PlayerExp"]:FireClient(Player, PlayerExperiencePoints) -- sending updated value of experience points

		ExperienceCap = ExperienceCap + 10 -- increasing amount of level exp needed each time level up occurs

		PlayerLevel = PlayerLevel + 1 -- Increasing player level
		RemoteEvents["PlayerLevelRemote"]:FireClient(Player, PlayerLevel)
	end
end


RemoteEvents["IceCreamBought"].OnServerEvent:Connect(function(PlayerName, IceCreamType)
	local function CanPlayerAfford() -- function to check if player can afford IceCream
		if PlayerMoney >= IceCreamValues[IceCreamType] then -- if player can afford purchased ice cream
			
			IceCreamAmount = IceCreamAmount + 1
			
			
			PlayerMoney = PlayerMoney - IceCreamValues[IceCreamType]
			RemoteEvents["PlayerCash"]:FireClient(PlayerName, PlayerMoney)

			if IceCreamType == "Vanilla" then -- Giving more or less Exp Gain based on what IceCream You purchase
				IceCreamOwned["VanillaOwned"] = IceCreamOwned["VanillaOwned"] + 1
				RemoteEvents["SuccessBoughtOrFailed"]:FireClient(PlayerName, "Success", "Vanilla", IceCreamAmount)
				
			elseif IceCreamType == "Strawberry" then
				IceCreamOwned["StrawberryOwned"] = IceCreamOwned["StrawberryOwned"] + 1
				RemoteEvents["SuccessBoughtOrFailed"]:FireClient(PlayerName, "Success", "Strawberry", IceCreamAmount)
			end
			
		elseif PlayerMoney < IceCreamValues[IceCreamType] then -- if player cannot afford the ice cream
			RemoteEvents["SuccessBoughtOrFailed"]:FireClient(PlayerName, "NotEnoughMoney")
		end
	end
	
	for Key, Value in pairs(ItemCurrentlyEquipped) do -- checking what item player has equipped
		if IceCreamAmount >= Value then -- if Player has more than maximum amount of ice cream that they can hold
			RemoteEvents["SuccessBoughtOrFailed"]:FireClient(PlayerName, "MaxStorage")
			
		elseif IceCreamAmount < Value then -- if player has enough room to hold more ice cream
			CanPlayerAfford()
		end
	end
end)

RemoteEvents["SellServerCommunication"].OnServerEvent:Connect(function(Player, CustomerIceCreamType) -- selling ice cream
	print("Customer type is "..CustomerIceCreamType)
	if IceCreamAmount <= 0 then -- if you don't have a single ice cream at all it'll just let you know
		print("You don't have any ice cream at all")
		RemoteEvents["IceCreamSellSound"]:FireClient(Player, false)
	else --[[if the if statement is false and you do have ice cream it will check what type of customer your 
	trying to sell too]]
		
		if CustomerIceCreamType == "Vanilla" then -- if the customer type is vanilla then
			if IceCreamOwned["VanillaOwned"] > 0 then -- checks if you even have vanilla ice cream
				IceCreamAmount = IceCreamAmount - 1
				IceCreamOwned["VanillaOwned"] = IceCreamOwned["VanillaOwned"] - 1 -- decrements value from table and total icecream amount
				
				PlayerMoney = PlayerMoney + SalesPrice["VanillaSale"] -- crediting player with money from sale
				RemoteEvents["PlayerCash"]:FireClient(Player, PlayerMoney) -- updating gui with new money amount
				
				PlayerExperiencePoints = PlayerExperiencePoints + 10 -- giving player experience points when selling IceCream
				RemoteEvents["PlayerExp"]:FireClient(Player, PlayerExperiencePoints) -- updating player experience points
				
				RemoteEvents["ItemSold"]:FireClient(Player, IceCreamAmount)
				RemoteEvents["IceCreamSellSound"]:FireClient(Player, true)
				
				LevelUp(Player)
			elseif IceCreamOwned["VanillaOwned"] <= 0 then -- if you even get to this point its confirmed you do have ice cream but not the right type for this specific customer
				RemoteEvents["IceCreamSellSound"]:FireClient(Player, false)
			end
		elseif CustomerIceCreamType == "Strawberry" then
			if IceCreamOwned["StrawberryOwned"] > 0 then
				IceCreamAmount = IceCreamAmount - 1
				IceCreamOwned["StrawberryOwned"] = IceCreamOwned["StrawberryOwned"] - 1
				
				RemoteEvents["IceCreamSellSound"]:FireClient(Player, true)
				

				PlayerMoney = PlayerMoney + SalesPrice["StrawberrySale"] -- crediting player with money from sale
				RemoteEvents["PlayerCash"]:FireClient(Player, PlayerMoney) -- updating gui with new money amount

				PlayerExperiencePoints += 20 -- giving player experience points when selling IceCream
				RemoteEvents["PlayerExp"]:FireClient(Player, PlayerExperiencePoints) -- updating player experience points

				RemoteEvents["ItemSold"]:FireClient(Player, IceCreamAmount)

				LevelUp(Player)
			elseif IceCreamOwned["StrawberryOwned"] <= 0 then
				RemoteEvents["IceCreamSellSound"]:FireClient(Player, false)
			end
			
		end
	end
end)

RemoteEvents["ItemPurchasedEvent"].OnServerEvent:Connect(function(player, ItemType)
	local AlreadyOwned = false
	for i = 1, #OwnedItems do
		if OwnedItems[i] == ItemType then -- if player already owns the item 
			AlreadyOwned = true
			break
		end
	end
	
	if AlreadyOwned then
		RemoteEvents["EquipmentNotify"]:FireClient(player, "AlrHaveItem")
		return
	end
	
	
	
		
	if PlayerMoney >= InventoryItemPrice[ItemType] then -- If player has enough money to purchase
		PlayerMoney = PlayerMoney - InventoryItemPrice[ItemType] -- Subtracting money from player
		
		RemoteEvents["PlayerCash"]:FireClient(player, PlayerMoney)-- Updating Player Money
		
		table.insert(OwnedItems, ItemType)

		for i = 1, #OwnedItems do
			RemoteEvents["ItemsOwnedCheck"]:FireClient(player, OwnedItems[i])
		end

		print("Purchased "..ItemType)


	elseif PlayerMoney < InventoryItemPrice[ItemType] then -- If player does not have enough money to purchase
		RemoteEvents["EquipmentNotify"]:FireClient(player, "NotEnoughMoney")
	end
end)

RemoteEvents["ItemEquipEvent"].OnServerEvent:Connect(function(player, ItemEquip)
	
	for k, v in ItemCurrentlyEquipped do
		--print(k,v)
	end
	
	
	ItemCurrentlyEquipped = {} -- clearing the table of any previous items that were equipped
	
	--print(ItemCurrentlyEquipped)
	--print(ItemEquip)
	
	local ItemInventoryValue = InventoryItemValues[ItemEquip]
	--print(ItemInventoryValue)
	ItemCurrentlyEquipped[ItemEquip] = ItemInventoryValue
	
	--print(ItemCurrentlyEquipped)
end)
