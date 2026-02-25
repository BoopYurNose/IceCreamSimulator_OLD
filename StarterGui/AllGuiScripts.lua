local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

-- TweenService
local TweenService = game:GetService("TweenService")


gui = script.Parent

-- Defining Sounds

ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://6895079853"
ClickSound.Parent = script
ClickSound.Volume = 1.5

IceCreamPurchaseSound = Instance.new("Sound")
IceCreamPurchaseSound.SoundId = "rbxassetid://307631257"
IceCreamPurchaseSound.Parent = script

ErrorSound = Instance.new("Sound")
ErrorSound.SoundId = "rbxassetid://550209561"
ErrorSound.Parent = script
ErrorSound.Volume = 1.5

SettingsSound = Instance.new("Sound")
SettingsSound.SoundId = "rbxassetid://97113622160405"
SettingsSound.Parent = script

LevelUpSound = Instance.new("Sound")
LevelUpSound.SoundId = "rbxassetid://3997124966"
LevelUpSound.Parent = script

OpenShopSound = Instance.new("Sound")
OpenShopSound.SoundId = "rbxassetid://8382337318"
OpenShopSound.Parent = script
OpenShopSound.Volume = 1.25

BackgroundMusic = Instance.new("Sound") -- add this in the background of the game
BackgroundMusic.SoundId = "rbxassetid://9047105533"
BackgroundMusic.Parent = script

IceCreamSoldSound = Instance.new("Sound")
IceCreamSoldSound.SoundId = "rbxassetid://3020841054"
IceCreamSoldSound.Parent = script
IceCreamSoldSound.Volume = 1.5

IceCreamSoldFailedSound = Instance.new("Sound")
IceCreamSoldFailedSound.SoundId = "rbxassetid://84538543455629"
IceCreamSoldFailedSound.Parent = script
IceCreamSoldFailedSound.TimePosition = .4
IceCreamSoldFailedSound.Volume = 1.5

-- QuestAccept Sound

QuestAcceptSound = Instance.new("Sound")
QuestAcceptSound.SoundId = "rbxassetid://124617819402413"
QuestAcceptSound.Parent = script
QuestAcceptSound.Volume = 3

-- QuestComplete sound

QuestCompleteSound = Instance.new("Sound")
QuestCompleteSound.SoundId = "rbxassetid://77433517511280"
QuestCompleteSound.Parent = script
QuestCompleteSound.Volume = 1






BackgroundMusic:Play()

BackgroundMusicIsPlaying = true





-- DEFINING FOR ICECREAMSELLING GUI


-- Defining the frame
SellingFrame = gui.SellingFrame

-- Defining Buttons, labels, etc
XButton = SellingFrame.XButton

-- Ice Cream purchase buttons
VanillaFreeGui = SellingFrame.VanillaFreeGui
StrawberryGui = SellingFrame.StrawberryGui


-- DEFINING FOR MONEYGUI


-- defining ScreenGui and Frame
MoneyGui = gui.Parent.MoneyGui
MoneyBackground = MoneyGui.MoneyBackground

-- defining Money label
MoneyDisplay = MoneyBackground.MoneyDisplay

-- defining ScreenGui and Frame for level gui and gems
LevelGuiGemsGui = gui.Parent.LevelGuiGemsGui --  screengui
-- Frames
LevelBackground = LevelGuiGemsGui.LevelBackground
GemsBackground = LevelGuiGemsGui.GemsBackground

-- Defining LevelGuiGemsGui Levels
LevelDisplay = LevelBackground.LevelDisplay
ExperiencePointsGui = LevelBackground.ExperiencePointsGui

-- Defining LevelGuiGemsGui Gems
GemsDisplay = GemsBackground.GemsDisplay



-- Defining InventoryGui
InventoryGui = gui.Parent.InventoryGui
InventorySystemFrame = InventoryGui.InventorySystemFrame
-- Amount of ice cream in inventory GUI
IceCreamSlotAmount1 = InventorySystemFrame.IceCreamSlotAmount1

-- Defining ShopButtongui screengui
ShopGui = gui.Parent.ShopGui

-- Defining ShopButtongui Button

ShopButton = ShopGui.ShopButton
ExitShopButton = ShopGui.ExitShopButton

-- Defining Quest screengui

QuestsGui = gui.Parent.QuestsGui
-- Defining gui inside QuestsGui screengui
QuestButton = QuestsGui.QuestButton
QuestMenuBackground = QuestsGui.QuestMenuBackground

-- Defining gui's inside the quest menu
QuestEntireFrame = QuestMenuBackground.QuestEntireFrame -- frame for the quests


-- Quest Information Frame on the right side of the quest gui and the gui's inside that frame
QuestInfo = QuestEntireFrame.QuestInfo

-- QuestInfo gui's
MissionText = QuestInfo.MissionText
QuestComplete = QuestInfo.QuestComplete
QuestIncrement = QuestInfo.QuestIncrement

-- Gui's apart of the QuestEntireFrame
QuestName = QuestEntireFrame.QuestName
QuestDescription = QuestEntireFrame.QuestDescription
ExitQuests = QuestEntireFrame.ExitQuests
DailyQuests = QuestEntireFrame.DailyQuests
MissionsLabel = QuestEntireFrame.MissionsLabel

-- gui inside DailyQuests
DailyQuestLabel = DailyQuests.DailyQuestLabel
DailyQuestTimer = DailyQuests.DailyQuestTimer



-- Quest scrollbar
QuestSlots = QuestEntireFrame.QuestSlots

-- quest slots inside Quest scrollbar
ScrollQuest1 = QuestSlots.ScrollQuest1

-- text labels inside ScrollQuest1
ScrollQuestComplete = ScrollQuest1.ScrollQuestComplete
ScrollQuestIncrement = ScrollQuest1.ScrollQuestIncrement
ScrollQuestName = ScrollQuest1.ScrollQuestName

-- Making Quest informations invisible when you first join game and view it
QuestName.Visible = false
QuestDescription.Visible = false
MissionsLabel.Visible = false
QuestInfo.Visible = false
ScrollQuest1.Visible = false

DialogTable = {
	["FirstDialog"] = {
		"Hello welcome to ice cream simulator you must be new here right?",
		"Cool! Welcome to the game would you be interested in doing a quest?",
		"Alright cool can you sell 2 of any ice cream flavor to customers? I will give you a reward once you complete this quest. Also feel free to come talk to me again if you want to do anymore quests",
		"No worries always come back if you want to try this quest later", -- if user says no to accepting quest
		"Complete the quest before asking for another quest" -- if user tries to interact with npc again without completing the quest already
	}
}

QuestsAcceptedTable = {
	["FirstQuestAccepted"] = false,
	["SecondQuestAccepted"] = false,
}

QuestCompletedTable = {
	["FirstQuest"] = false,
	["SecondQuest"] = false,
}



  


-- remember arrays in lua start at 1

QuestLabelsTable = {
	["First QuestGui"] = {
		"FIRST QUEST", -- name of quest
		"This quest is the first one you ever get. Neat right?", -- description of quest
		"Sell any ice cream 2 times", -- MissionInfo (pretty much what you need to do)
		"0/2" -- Quest Progress
	}
}

local function QuestRewards(QuestName)
	QuestCompleteSound:Play() -- HERE
	if QuestName == "FirstQuest" then -- if you complete the first quest
		RemoteEvents["QuestCompleteEvent"]:FireServer("FirstQuestComplete")
		QuestGuiReplicate("QuestComplete")
		QuestsAcceptedTable["FirstQuestAccepted"] = false
	end
end

function QuestGuiReplicate(QuestIndex)
	
	
	if QuestsAcceptedTable["FirstQuestAccepted"] == true then
		if QuestIndex == "First QuestGui" then
			QuestName.Visible = true
			QuestDescription.Visible = true
			MissionsLabel.Visible = true
			QuestInfo.Visible = true
			ScrollQuest1.Visible = true
			ScrollQuest1.UIStroke.Transparency = 0

			-- ScrollQuest Text Gui info
			ScrollQuestName.Text = QuestLabelsTable[QuestIndex][1]
			ScrollQuestIncrement.Text = QuestLabelsTable[QuestIndex][4]


			-- Right side of quest gui text gui info
			QuestName.Text = QuestLabelsTable[QuestIndex][1]
			QuestDescription.Text = QuestLabelsTable[QuestIndex][2]
			MissionText.Text = QuestLabelsTable[QuestIndex][3]
			QuestIncrement.Text = QuestLabelsTable[QuestIndex][4]
			
		elseif QuestIndex == "QuestComplete" then
			print("worked")
			QuestName.Visible = false
			QuestDescription.Visible = false
			MissionsLabel.Visible = false
			QuestInfo.Visible = false
			ScrollQuest1.Visible = false
			ScrollQuest1.UIStroke.Transparency = 1

			-- ScrollQuest Text Gui info
			ScrollQuestName.Text = "" -- reseting all the text info
			ScrollQuestIncrement.Text = ""


			-- Right side of quest gui text gui info
			QuestName.Text = ""
			QuestDescription.Text = ""
			MissionText.Text = ""
			QuestIncrement.Text = ""
		end
	end
end

-- Defining ScreenGui DialogGui
DialogGui = gui.Parent.DialogGui

-- defining Frames for DialogGui
QuestDialogBackground = DialogGui.QuestDialogBackground

-- Defining the NPCName and NPC dialog Options inside the QuestDialogBackground
DialogOption1 = QuestDialogBackground.DialogOption1
DialogOption2 = QuestDialogBackground.DialogOption2
DialogNPCName = QuestDialogBackground.DialogNPCName
QuitDialog = QuestDialogBackground.QuitDialog


-- Defining the NPC dialogFrame

QuestDialog = QuestDialogBackground.QuestDialog

-- Defining the textlabel for the NPC dialog
DialogText = QuestDialog.DialogText



QuestDialogBackground.Visible = false



-- Defining ShopGuiFrame

ShopGuiFrame = ShopGui.ShopGuiFrame



-- Defining ScreenGui and Frame for Settings
SettingsGui = gui.Parent.SettingsGui
SettingsFrame = SettingsGui.SettingsFrame

-- defining stuff inside settings frame
ScrollFrame = SettingsFrame.ScrollFrame
GameMusicFrame = ScrollFrame.GameMusicFrame
GameMusicButton = GameMusicFrame.GameMusicButton

-- Defining Button for Settings
SettingsButton = SettingsGui.SettingsButton

-- Defining buttons Inside Settings Frame
ExitButton = SettingsFrame.ExitButton

-- Defining ImageLabel for SettingsButton and other properties for SettingsButton
SettingsImage = SettingsButton.SettingsImage
UIStroke = SettingsButton.UIStroke


-- notify upon purchase of ice cream
Notification = gui.Notification

-- Notification If player has maximum storage
Notification2 = gui.Notification2

-- Defining Player
local player = game.Players.LocalPlayer

-- Defining Camera object
local Camera = game.Workspace.CurrentCamera


local EquipDisplay = {}-- if player has item it'll show a equip gui option in the shop

RemoteEvents["ItemsOwnedCheck"].OnClientEvent:Connect(function(ItemsOwnedList)
	table.insert(EquipDisplay, ItemsOwnedList)
end)

-- Defining CameraPart1
local CameraPart1 = game.Workspace.SpawnLocation.EquipmentSelling.EquipmentSellingShop.CameraParts:WaitForChild("CameraPart1")

local CameraPart2 = game.Workspace.SpawnLocation.EquipmentSelling.EquipmentSellingShop.CameraParts:WaitForChild("CameraPart2")

CameraPartsTable = {
	game.Workspace.SpawnLocation.EquipmentSelling.EquipmentSellingShop.CameraParts.CameraPart1,
	game.Workspace.SpawnLocation.EquipmentSelling.EquipmentSellingShop.CameraParts.CameraPart2,
}

local IndexCamera = 1

ItemDescriptions = { -- These are descriptions for the items
	"Uhh you kinda just hold 2 ice creams with both your hands.. Nothing really more to it.",
	"This is a cheap tray that allows you to hold 2 different variants of ice creams with 4 slots for each slot.",
}

ItemEquippedGui = {
	"Hand"
}

ItemPricesTable = {
	["Hand"] = 0,
	["Tray"] = 5,
}

-- Defining Gui's in equipmentseller gui

EquipmentSellerGui = gui.Parent.EquipmentSellerGui

ItemInformation = EquipmentSellerGui.ItemInformation

-- Defining the Text Labels inside ItemInformation
ItemName = ItemInformation.ItemName
ItemSpecs = ItemInformation.ItemSpecs
ItemPrice = ItemInformation.ItemPrice

-- gui outside ItemInformation Frame
PurchaseItemButton = EquipmentSellerGui.PurchaseItemButton
RightArrow = EquipmentSellerGui.RightArrow
LeftArrow = EquipmentSellerGui.LeftArrow
ExitShop = EquipmentSellerGui.ExitShop
EquipItemButton = EquipmentSellerGui.EquipItemButton
EquipmentShopNotification = EquipmentSellerGui.EquipmentShopNotification

-- making them all invisible upon starting the game
ItemInformation.Visible = false
PurchaseItemButton.Visible = false
RightArrow.Visible = false
LeftArrow.Visible = false
ExitShop.Visible = false
EquipItemButton.Visible = false
EquipmentShopNotification.Visible = false
ShopGuiFrame.Visible = false
ExitShopButton.Visible = false






-- Tween stuff for SettingsButton (making it bigger or smaller)
local tweeninfo = TweenInfo.new(
	.1,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.Out
)


-- Tweening gui for settings button
local SettingsBigger = TweenService:Create(SettingsButton, tweeninfo, {Size = UDim2.new(0.045, 0,0.076, 0)})

local SettingsSmaller = TweenService:Create(SettingsButton, tweeninfo, {Size = UDim2.new(0.039, 0,0.062, 0)})

-- Tweening gui for Shop Button

local ShopBigger = TweenService:Create(ShopButton, tweeninfo, {Size = UDim2.new(0.045, 0,0.076, 0)})

local ShopSmaller = TweenService:Create(ShopButton, tweeninfo, {Size = UDim2.new(0.04, 0,0.062, 0)})

-- Tweening gui for the Left and Right arrows in the Equipment shop gui

local LeftBigger = TweenService:Create(LeftArrow, tweeninfo, {Size = UDim2.new(0.056, 0,0.089)})
local LeftSmaller = TweenService:Create(LeftArrow, tweeninfo, {Size = UDim2.new(0.045, 0,0.071, 0)})

local RightBigger = TweenService:Create(RightArrow, tweeninfo, {Size = UDim2.new(0.056, 0,0.089)})
local RightSmaller = TweenService:Create(RightArrow, tweeninfo, {Size = UDim2.new(0.045, 0,0.071, 0)})

-- Making what the equipment shop menu hides visible upon loading into the game for the first time
InventorySystemFrame.Visible = true
SettingsButton.Visible = true
LevelBackground.Visible = true
MoneyBackground.Visible = true
GemsBackground.Visible = true



-- Updating all player stats here
RemoteEvents["PlayerCash"].OnClientEvent:Connect(function(MoneyAmount) -- updating players money for gui
	MoneyDisplay.Text = "$"..MoneyAmount
end)

RemoteEvents["PlayerLevelRemote"].OnClientEvent:Connect(function(Level) -- updating players level for gui
	if Level > 1 then
		LevelUpSound:Play()
	end
	LevelDisplay.Text = Level
end)

RemoteEvents["PlayerExp"].OnClientEvent:Connect(function(PlayerEXP)
	ExperiencePointsGui.Text = "EXP: "..PlayerEXP
end)

RemoteEvents["PlayerGemsAmount"].OnClientEvent:Connect(function(Gems)
	GemsDisplay.Text = Gems
end)







XButton.MouseButton1Click:Connect(function()
	ClickSound:Play()
	SellingFrame.Visible = false
end)

RemoteEvents["NPCInteracted"].OnClientEvent:Connect(function(NPCType) -- opening NPC menu
	OpenShopSound:Play()
	if NPCType == "Seller" then
		if SellingFrame.Visible == false then
			SellingFrame.Visible = true
		elseif SellingFrame.Visible == true then
			SellingFrame.Visible = false
		end
	
	elseif NPCType == "Quest" then
		DialogNPCName.Text = "Quest Giver"
		if QuestDialogBackground.Visible == false then
			QuestDialogBackground.Visible = true
			
			if QuestCompletedTable["FirstQuest"] == false then
				
				DialogOption2.Text = "YES"
				DialogOption1.Text = "NO"
				
				DialogText.Text = DialogTable["FirstDialog"][1]
			end
				
			
		elseif QuestDialogBackground.Visible == true then
			QuestDialogBackground.Visible = false
			DialogText.Text = ""
		end
		
		
	elseif NPCType == "EquipmentSeller" then
		if InventorySystemFrame.Visible == true then
			
			-- Making all the gui invisible when in the shop menu
			InventorySystemFrame.Visible = false
			SettingsButton.Visible = false
			SettingsFrame.Visible = false
			LevelBackground.Visible = false
			SellingFrame.Visible = false
			
			-- Making ShopGui visible
			ItemInformation.Visible = true
			PurchaseItemButton.Visible = true
			RightArrow.Visible = true
			LeftArrow.Visible = true
			ExitShop.Visible = true
			
			-- Moving player camera menu to view shop
			Camera.CameraType = "Scriptable"
			Camera.CFrame = CameraPart1.CFrame
			
			IndexCamera = 1
			
			
			for k, v in (EquipDisplay) do
				if v == "Hand" then
					EquipItemButton.Visible = true
				end
			end
			
			for k, v in ItemEquippedGui do
				if v == "Hand" then
					EquipItemButton.Text = "EQUIPPED"
				else
					EquipItemButton.Text = "EQUIP"
				end
			end
			
			ItemName.Text = "Hand"
			ItemSpecs.Text = ItemDescriptions[1]
			ItemPrice.Text = "Price: "..ItemPricesTable["Hand"]
		end
	end
end)

-- Equipment Shop gui stuff

ExitShop.MouseButton1Click:Connect(function()
	ClickSound:Play()
	
	-- Making all the gui Visible when out of the shop menu
	InventorySystemFrame.Visible = true
	SettingsButton.Visible = true
	LevelBackground.Visible = true
	
	-- Making ShopGui invisible
	ItemInformation.Visible = false
	PurchaseItemButton.Visible = false
	RightArrow.Visible = false
	LeftArrow.Visible = false
	ExitShop.Visible = false
	EquipItemButton.Visible = false
	
	Camera.CameraType = "Custom"
	workspace.Camera.CameraSubject = player
end)

PurchaseItemButton.MouseButton1Click:Connect(function()
	ClickSound:Play()
	if IndexCamera == 1 then
		RemoteEvents["ItemPurchasedEvent"]:FireServer("Hand")
	elseif IndexCamera == 2 then
		RemoteEvents["ItemPurchasedEvent"]:FireServer("Tray")
	end
end)

-- Tween effects for the left and right arrows in the shop gui if your mouse hovers over them
LeftArrow.MouseEnter:Connect(function()
	LeftBigger:Play()
end)

LeftArrow.MouseLeave:Connect(function()
	LeftSmaller:Play()
end)

RightArrow.MouseEnter:Connect(function()
	RightBigger:Play()
end)

RightArrow.MouseLeave:Connect(function()
	RightSmaller:Play()
end)


-- if you click on leftArrow
LeftArrow.MouseButton1Click:Connect(function()
	ClickSound:Play()
	
	if IndexCamera == 1 then
		IndexCamera = #CameraPartsTable
	else
		IndexCamera = IndexCamera - 1
	end
	
	Camera.CFrame = CameraPartsTable[IndexCamera].CFrame
	
	if IndexCamera == 1 then
		ItemName.Text = "Hand"
		ItemSpecs.Text = ItemDescriptions[1]
		ItemPrice.Text = "Price: "..ItemPricesTable["Hand"]
		
		for k, v in ItemEquippedGui do
			if v == "Hand" then
				EquipItemButton.Text = "EQUIPPED"
			else
				EquipItemButton.Text = "EQUIP"
			end
		end
		
		for k, v in EquipDisplay do
			if v == "Hand" then
				EquipItemButton.Visible = true
			end
		end
		
	elseif IndexCamera == 2 then
		ItemName.Text = "Tray"
		ItemSpecs.Text = ItemDescriptions[2]
		ItemPrice.Text = "Price: "..ItemPricesTable["Tray"]
		
		for k, v in ItemEquippedGui do
			if v == "Tray" then
				EquipItemButton.Text = "EQUIPPED"
			else
				EquipItemButton.Text = "EQUIP"
			end
		end
		
		for k, v in EquipDisplay do
			if v == "Tray" then
				EquipItemButton.Visible = true
			else
				EquipItemButton.Visible = false
			end
		end
		
	end
end)

RightArrow.MouseButton1Click:Connect(function()
	ClickSound:Play()
	
	IndexCamera = IndexCamera + 1
	
	if IndexCamera > #CameraPartsTable then
		IndexCamera = 1
	end
	
	Camera.CFrame = CameraPartsTable[IndexCamera].CFrame
	
	if IndexCamera == 1 then
		ItemName.Text = "Hand"
		ItemSpecs.Text = ItemDescriptions[1]
		ItemPrice.Text = "Price: "..ItemPricesTable["Hand"]
		
		for k, v in ItemEquippedGui do
			if v == "Hand" then
				EquipItemButton.Text = "EQUIPPED"
			else
				EquipItemButton.Text = "EQUIP"
			end
		end
		
		for k, v in EquipDisplay do
			if v == "Hand" then
				EquipItemButton.Visible = true
			end
		end
		
	elseif IndexCamera == 2 then
		ItemName.Text = "Tray"
		ItemSpecs.Text = ItemDescriptions[2]
		ItemPrice.Text = "Price: "..ItemPricesTable["Tray"]
		
		for k, v in ItemEquippedGui do
			if v == "Tray" then
				EquipItemButton.Text = "EQUIPPED"
			else
				EquipItemButton.Text = "EQUIP"
			end
		end
		
		for k, v in EquipDisplay do
			if v == "Tray" then
				EquipItemButton.Visible = true
			else
				EquipItemButton.Visible = false
			end
		end
		
	end
end)

RemoteEvents["ItemsOwnedCheck"].OnClientEvent:Connect(function(OwnedItem)
	if ItemInformation.Visible == true then
		if OwnedItem == "Tray" and IndexCamera == 2 then
			EquipItemButton.Visible = true
		end
	else
		print("Your not on the EquipmentShop Menu")
	end
end)

EquipItemButton.MouseButton1Click:Connect(function()
	EquipItemButton.Text = "EQUIPPED"
	ItemEquippedGui = {} -- resetting the tableValue
	if IndexCamera == 1 then
		RemoteEvents["ItemEquipEvent"]:FireServer("Hand")
		table.insert(ItemEquippedGui, "Hand")
	elseif IndexCamera == 2 then
		RemoteEvents["ItemEquipEvent"]:FireServer("Tray")
		table.insert(ItemEquippedGui, "Tray")
	end
end)

RemoteEvents["EquipmentNotify"].OnClientEvent:Connect(function(Reason)
	if Reason == "AlrHaveItem" then
		ErrorSound:Play()
		EquipmentShopNotification.Visible = true
		EquipmentShopNotification.Text = "You already have that item"
		task.wait(1.5)
		EquipmentShopNotification.Visible = false
		EquipmentShopNotification.Text = ""
	elseif Reason == "NotEnoughMoney" then
		ErrorSound:Play()
		EquipmentShopNotification.Visible = true
		EquipmentShopNotification.Text = "You don't have enough money to purchase this item"
		task.wait(1.5)
		EquipmentShopNotification.Visible = false
		EquipmentShopNotification.Text = ""
	end
end)



VanillaFreeGui.MouseButton1Click:Connect(function()
	RemoteEvents["IceCreamBought"]:FireServer("Vanilla")
end)

StrawberryGui.MouseButton1Click:Connect(function()
	RemoteEvents["IceCreamBought"]:FireServer("Strawberry")
end)

RemoteEvents["SuccessBoughtOrFailed"].OnClientEvent:Connect(function(Success, Type, AmountIceCream)
	if Success == "Success" then
		IceCreamPurchaseSound:Play()
		IceCreamSlotAmount1.Text = AmountIceCream
	if Type == "Vanilla" then
		Notification.Text = "Purchased Vanilla!"
		Notification.Visible = true
		task.wait(1)
		Notification.Visible = false
		Notification.Text = ""
	elseif Type == "Strawberry" then
		Notification.Text = "Purchased Strawberry!"
		Notification.Visible = true
		task.wait(1)
		Notification.Visible = false
		Notification.Text = ""
	end
		
		
	elseif Success == "NotEnoughMoney" then
		ErrorSound:Play()
		Notification2.Text = "YOU DON'T HAVE ENOUGH MONEY FOR THIS ITEM"
		Notification2.Visible = true
		task.wait(1.5)
		Notification2.Text = ""
		Notification2.Visible = false
	elseif Success == "MaxStorage" then
		ErrorSound:Play()
		Notification2.Text = "YOU DON'T HAVE INVENTORY SPACE FOR THIS ITEM"
		Notification2.Visible = true
		task.wait(1.5)
		Notification2.Text = ""
		Notification2.Visible = false
	end
end)

-- Settings Button functionality
SettingsButton.MouseButton1Click:Connect(function()
	SettingsSound:Play()
	if SettingsFrame.Visible == false then -- if the menu isn't visible then do
		SettingsBigger:Play()
		SettingsFrame.Visible = true
		SettingsImage.Visible = false
		SettingsButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		SettingsButton.Text = "X"
		
		
	elseif SettingsFrame.Visible == true then -- if menu is visible then do
		SettingsSmaller:Play()
		SettingsFrame.Visible = false
		SettingsImage.Visible = true
		SettingsButton.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
		SettingsButton.Text = ""
		
	end
end)

SettingsButton.MouseEnter:Connect(function()
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
end)

SettingsButton.MouseLeave:Connect(function()
	UIStroke.Color = Color3.fromRGB(0, 0, 0)
end)

ExitButton.MouseButton1Click:Connect(function()
	ClickSound:Play()
	SettingsFrame.Visible = false
	SettingsSmaller:Play()
	SettingsImage.Visible = true
	SettingsButton.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
	SettingsButton.Text = ""
end)

-- if ice cream sale happens
RemoteEvents["IceCreamSellEvent"].OnClientEvent:Connect(function(IceCreamSoldType)
	RemoteEvents["SellServerCommunication"]:FireServer(IceCreamSoldType)
end)

local Debounce1 = false

-- IceCreamInventory sale decreasing amount of ice cream in inventory
RemoteEvents["ItemSold"].OnClientEvent:Connect(function(IceCreamAmount)
	IceCreamSlotAmount1.Text = IceCreamAmount
	
	-- Quest script
	
	for k, v in QuestsAcceptedTable do
		if v == true then -- checking if your currently active in a quest
			
			if Debounce1 == false then
				IceCreamSoldIncrement = 0
				Debounce1 = true
			end
			
			-- Adding increment value each time you sell one ice cream
			
			IceCreamSoldIncrement = IceCreamSoldIncrement + 1
			
			if QuestsAcceptedTable["FirstQuestAccepted"] == true then -- actions for the first quest
				ScrollQuestIncrement.Text = IceCreamSoldIncrement.."/2"
				QuestIncrement.Text = IceCreamSoldIncrement.."/2"
				
				if IceCreamSoldIncrement == 2 then
					QuestCompletedTable["FirstQuest"] = true
					QuestRewards("FirstQuest") -- passing in function
					local Debounce1 = false
				end
			elseif QuestsAcceptedTable["Second Quest"] == true then
				-- do stuff here later for the second quest
			end
		end
	end
	
end)

RemoteEvents["IceCreamSellSound"].OnClientEvent:Connect(function(Sold)
	if Sold == true then
		IceCreamSoldSound:Play()
	elseif Sold == false then
		IceCreamSoldFailedSound:Play()
	end
end)

GameMusicButton.MouseButton1Click:Connect(function()-- if user clicks the button
	ClickSound:Play()
	if BackgroundMusicIsPlaying == true then
		GameMusicButton.Text = "OFF"
		BackgroundMusicIsPlaying = false
		BackgroundMusic:Pause()
		GameMusicFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		GameMusicButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	elseif BackgroundMusicIsPlaying == false then
		GameMusicButton.Text = "ON"
		BackgroundMusicIsPlaying = true
		BackgroundMusic:Resume()
		GameMusicFrame.BackgroundColor3 = Color3.fromRGB(67, 200, 0)
		GameMusicButton.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
	end
end)

ShopButton.MouseButton1Click:Connect(function()
	OpenShopSound:Play()
	if ShopGuiFrame.Visible == false then
		ShopBigger:Play()
		ShopButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
		ShopGuiFrame.Visible = true
		ExitShopButton.Visible = true
	elseif ShopGuiFrame.Visible == true then
		ShopSmaller:Play()
		ShopButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
		ShopGuiFrame.Visible = false
		ExitShopButton.Visible = false
	end
end)

ShopButton.MouseEnter:Connect(function()
	ShopButton.UIStroke.Color = Color3.fromRGB(255, 255, 255)
end)

ShopButton.MouseLeave:Connect(function()
	ShopButton.UIStroke.Color = Color3.fromRGB(0, 0, 0)
end)

ExitShopButton.MouseButton1Click:Connect(function()
	ClickSound:Play()
	ShopGuiFrame.Visible = false
	ExitShopButton.Visible = false
	ShopSmaller:Play()
	ShopButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
end)

QuestButton.MouseButton1Click:Connect(function()
	ClickSound:Play()
	if QuestMenuBackground.Visible == false then
		QuestMenuBackground.Visible = true
	elseif QuestMenuBackground.Visible == true then
		QuestMenuBackground.Visible = false
	end	
end)

ExitQuests.MouseButton1Click:Connect(function()
	ClickSound:Play()
	QuestMenuBackground.Visible = false
end)

ScrollQuest1.MouseButton1Click:Connect(function()
	ClickSound:Play()
	if MissionsLabel.Visible == false then
		ScrollQuest1.UIStroke.Transparency = 0
		QuestName.Visible = true
		QuestDescription.Visible = true
		MissionsLabel.Visible = true
		QuestInfo.Visible = true
	elseif MissionsLabel.Visible == true then
		ScrollQuest1.UIStroke.Transparency = 1
		QuestName.Visible = false
		QuestDescription.Visible = false
		MissionsLabel.Visible = false
		QuestInfo.Visible = false
	end
end)


QuitDialog.MouseButton1Click:Connect(function()
	ClickSound:Play()
	Iterator = 1
	QuestDialogBackground.Visible = false
end)

DialogOption1.MouseButton1Click:Connect(function() -- Answer NO
	ClickSound:Play()
	Iterator = 1
	QuestDialogBackground.Visible = false
end)
local Debounce = false

DialogOption2.MouseButton1Click:Connect(function() -- Answer YES
	ClickSound:Play()
	
	if QuestCompletedTable["FirstQuest"] == false then -- if user hasn't completed first quest yet
		if Debounce == false then
			Debounce = true
			Iterator = 1
		end
		Iterator = Iterator + 1
		DialogText.Text = DialogTable["FirstDialog"][Iterator]
		
		if Iterator > 3 then -- if user accepts the quest
			QuestsAcceptedTable["FirstQuestAccepted"] = true
			QuestAcceptSound:Play()
			Iterator = 1
			DialogText.Text = ""
			QuestDialogBackground.Visible = false
			QuestGuiReplicate("First QuestGui")
		end
		
		if QuestsAcceptedTable["FirstQuestAccepted"] == true then
			DialogText.Text = DialogTable["FirstDialog"][5]
		end
		
	end
end)
