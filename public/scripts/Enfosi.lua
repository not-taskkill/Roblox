local hCloneref = cloneref or clonereference or clone_reference or function(ref)
	if not getreg then return ref end

	local InstanceList

	local a = Instance.new("Part")
	for _, c in pairs(getreg()) do
		if type(c) == "table" and #c then
			if rawget(c, "__mode") == "kvs" then
				for d, e in pairs(c) do
					if e == a then
						InstanceList = c
						break
					end
				end
			end
		end
	end
	local f = {}
	function f.invalidate(g)
		if not InstanceList then
			return
		end
		for b, c in pairs(InstanceList) do
			if c == g then
				InstanceList[b] = nil
				return g
			end
		end
	end
	return f.invalidate
end

local function Create(Class, Properties)
	if not Class then return end

	Properties = Properties or {}

	local success, CreatedClass = pcall(function()
		return Instance.new(Class)
	end)

	if not success then
		return
	end

	for Entry, Value in pairs(Properties) do
		CreatedClass[Entry] = Value
	end

	return CreatedClass
end

local function YieldForChild(inst, name)
	local First = inst:FindFirstChild(name)

	if First then
		return First
	end
	
	local running = coroutine.running()
	local CurrentTime = time()
	local Found = false

	local connection
	connection = inst.ChildAdded:Connect(function(child)
		if child.Name == name then
			connection:Disconnect()
			Found = true
			coroutine.resume(running, child)
		end
	end)

	task.spawn(function()
		while task.wait(0.1) do
			if time() - CurrentTime >= 25 and not Found then
				if connection then
					connection:Disconnect()
				end

				coroutine.resume(running, nil)
				break
			end
		end
	end)
	
	return coroutine.yield()
end

local ugc = hCloneref(game)
local rng = Random.new(os.clock())

repeat task.wait() until ugc:IsLoaded()

local TaskHubScriptIdentity = {
	ScriptIdentity = "TaskHub - Enfosi",
	ScriptVersion = "v1.1",
	
	ScriptPlaceVersion = {
		["Enfosi-game"] = 141
	},
	ScriptPlaceIdentity = {
		["Lobby"] = 78353262320982,
		["Enfosi-game"] = 99811418619120
	},
	
	BaseNotificationIcon = "rbxassetid://7138511050",
	BaseNotificationSound = "rbxassetid://127205266270030",
	
	Librarys = {
		Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/not-taskkill/Librarys/refs/heads/main/scr/Notification.luau", true))(),
		PlaceSignature = loadstring(game:HttpGet("https://raw.githubusercontent.com/not-taskkill/Librarys/refs/heads/main/scr/PlaceSignature.luau", true))(),
		GCBypass = loadstring(game:HttpGet("https://raw.githubusercontent.com/secretisadev/Babyhamsta_Backup/refs/heads/main/Universal/Bypasses.lua", true))()
	},
	
	Connections = {},
	
	DynamicChamConfiguration = {
		TransitionInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In) 
	},
	
	PlaceId = ugc.PlaceId,
	PlaceVersion = ugc.PlaceVersion,
	MaxDisplayOrder = 2147483647
}

local Players = hCloneref(ugc:GetService("Players"))
local CoreGui = hCloneref(ugc:GetService("CoreGui"))
local TweenService = hCloneref(ugc:GetService("TweenService"))
local UserInputService = hCloneref(ugc:GetService("UserInputService"))

local LocalUser = hCloneref(Players.LocalPlayer)
local function GetCharacter()
	local Char = LocalUser.Character
	if Char and Char.Parent then
		return Char
	else
		return LocalUser.CharacterAdded:Wait()
	end
end

function randomString()
	local length = rng:NextInteger(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(rng:NextInteger(32, 126))
	end
	return table.concat(array)
end

local array, result = TaskHubScriptIdentity.Librarys.PlaceSignature:Matches({
	ExpectedPlace = TaskHubScriptIdentity.ScriptPlaceIdentity,
	ExpectedVersion = TaskHubScriptIdentity.ScriptPlaceVersion,
	AllowOutdatedVersions = true
})

if not array then
	TaskHubScriptIdentity.Librarys.Notification:Send({
		Title = "error",
		Text = result,
		Icon = TaskHubScriptIdentity.BaseNotificationIcon,
		Duration = 10.5,
		Sound = TaskHubScriptIdentity.BaseNotificationSound
	})
	return
elseif array and array.MatchedPlace == "Lobby" then
	TaskHubScriptIdentity.Librarys.Notification:Send({
		Title = "warn",
		Text = "start the game before using the script",
		Icon = TaskHubScriptIdentity.BaseNotificationIcon,
		Duration = 10.5,
		Sound = TaskHubScriptIdentity.BaseNotificationSound
	})
	return
elseif getgenv()[`@{LocalUser.UserId or LocalUser.Name}_TaskHubEnfosiLoaded`] then
	TaskHubScriptIdentity.Librarys.Notification:Send({
		Title = "error",
		Text = "Already Loaded.",
		Icon = TaskHubScriptIdentity.BaseNotificationIcon,
		Duration = 10.5,
		Sound = TaskHubScriptIdentity.BaseNotificationSound
	})
	return
end

TaskHubScriptIdentity.Librarys.Notification:Send({
	Title = TaskHubScriptIdentity.ScriptIdentity,
	Text = `Welcome, @{LocalUser.Name}`,
	Icon = TaskHubScriptIdentity.BaseNotificationIcon,
	Duration = 6,
	Sound = TaskHubScriptIdentity.BaseNotificationSound
})

local HiddenSource = nil
if gethui or get_hidden_ui or get_hidden_gui then
	local hiddenUI = gethui or get_hidden_ui or get_hidden_gui
	local UI = Create("ScreenGui", {
		Name = randomString(),
		ResetOnSpawn = false,
		DisplayOrder = TaskHubScriptIdentity.MaxDisplayOrder,
		Parent = hiddenUI()
	})
	HiddenSource = UI
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
	local hiddenUI = Create("ScreenGui", {
		Name = randomString(),
		ResetOnSpawn = false,
		DisplayOrder = TaskHubScriptIdentity.MaxDisplayOrder,
		Parent = CoreGui
	})
	syn.protect_gui(hiddenUI)
	HiddenSource = hiddenUI
elseif CoreGui:FindFirstChild("RobloxGui") then
	HiddenSource = CoreGui.RobloxGui
else
	local hiddenUI = Create("ScreenGui", {
		Name = randomString(),
		ResetOnSpawn = false,
		DisplayOrder = TaskHubScriptIdentity.MaxDisplayOrder,
		Parent = CoreGui
	})
	HiddenSource = hiddenUI
end

pcall(function()
	getgenv()[`@{LocalUser.UserId or LocalUser.Name}_TaskHubEnfosiLoaded`] = true
end)

local NPCs = YieldForChild(workspace, "NPCs")
local Bosses = {
	["Risio"] = true,
	["Gergro"] = true,
	["Borgack"] = true
}

local FirstTime = true

task.delay(3.75, function()
	TaskHubScriptIdentity.Librarys.Notification:Send({
		Title = "Tooltip",
		Text = "say on chat 'mods/ball' or 'mods/block' to enable some modes.",
		Icon = TaskHubScriptIdentity.BaseNotificationIcon,
		Duration = 7.65,
		Sound = TaskHubScriptIdentity.BaseNotificationSound
	})
end)

task.delay(7.25, function()
	TaskHubScriptIdentity.Librarys.Notification:Send({
		Title = "Tooltip",
		Text = "If you have not completed Roblox's age verification, then press M to use the mods in Input format.",
		Icon = TaskHubScriptIdentity.BaseNotificationIcon,
		Duration = 10.5,
		Sound = TaskHubScriptIdentity.BaseNotificationSound
	})
end)

local function SyncConnection(Signal, func)
	local Connection
	local RandomIndex = randomString()

	Connection = Signal:Connect(function(...)
		func(Connection, RandomIndex, ...)
	end)

	TaskHubScriptIdentity.Connections[RandomIndex] = Connection

	return Connection, RandomIndex
end

local function CollectGarbage(mode, Index)
	if mode == "All" then
		for Index, Connection in pairs(TaskHubScriptIdentity.Connections) do
			if Connection and Connection.Disconnect then
				Connection:Disconnect()
				TaskHubScriptIdentity.Connections[Index] = nil
			end
		end
	elseif mode == "TableIndexing" then
		if Index and type(Index) == "string" then
			local Connection = TaskHubScriptIdentity.Connections[Index]
			if Connection and Connection.Disconnect then
				Connection:Disconnect()
				TaskHubScriptIdentity.Connections[Index] = nil
			end
		end
	end
end

local ChatIndex, InputIndex = nil, nil
local CurrentMethod = nil

function ChangeModsActivationFormat(ActivationMethod, ShouldShowNotification)
	if ActivationMethod == "Chat" then
		if InputIndex and type(InputIndex) == "string" then
			CollectGarbage("TableIndexing", InputIndex)
		end
		
		ShouldShowNotification = ShouldShowNotification or false
		CurrentMethod = "Chat"
		
		if ShouldShowNotification then
			TaskHubScriptIdentity.Librarys.Notification:Send({
				Title = "Mods Activation Method",
				Text = "Chat Method.",
				Icon = TaskHubScriptIdentity.BaseNotificationIcon,
				Duration = 5,
				Sound = TaskHubScriptIdentity.BaseNotificationSound
			})
		end
		
		local tempCon, tempIdx = SyncConnection(LocalUser.Chatted, function(a0, a1, Source)  
			if not Source or type(Source) ~= "string" then
				return
			end
			
			local Message = Source:lower()
			
			if Message == "mods/ball" then
				SetCharacterMode("Ball")
			elseif Message == "mods/block" then
				SetCharacterMode("Block")
			end
		end)
		
		tempIdx = ChatIndex
	elseif ActivationMethod == "Input" then
		if ChatIndex and type(ChatIndex) ~= "string" then
			CollectGarbage("TableIndexing", ChatIndex)
		end
		
		CurrentMethod = "Input"
		
		if ShouldShowNotification then
			TaskHubScriptIdentity.Librarys.Notification:Send({
				Title = "Mods Activation Method",
				Text = "Input Method.",
				Icon = TaskHubScriptIdentity.BaseNotificationIcon,
				Duration = 5,
				Sound = TaskHubScriptIdentity.BaseNotificationSound
			})
		end
		
		if FirstTime then
			TaskHubScriptIdentity.Librarys.Notification:Send({
				Title = "Tooltip",
				Text = "You are now on Input Method to use mods, Press M to use Ball mode or N to Block mode.",
				Icon = TaskHubScriptIdentity.BaseNotificationIcon,
				Duration = 10.5,
				Sound = TaskHubScriptIdentity.BaseNotificationSound
			})
			
			FirstTime = false
		end
		
		local tempCon, tempIdx = SyncConnection(UserInputService.InputBegan, function(a0, a1, InputObject, Processed) 
			if Processed then
				return
			end
			
			if InputObject.KeyCode == Enum.KeyCode.M then
				SetCharacterMode("Ball")
			elseif InputObject.KeyCode == Enum.KeyCode.N then
				SetCharacterMode("Block")
			end
		end)
		
		tempIdx = InputIndex
	end
end

local function ApplyDynamicCham(Object, Ancestry)
	if not Object or not Ancestry then
		return
	end
	
	for _, Descendant in ipairs(Object:GetDescendants()) do
		if Descendant and Descendant.Parent then
			if not Descendant:IsA("Highlight") then
				continue
			end
			
			Descendant:Destroy()
		end
	end
	
	local Cham = Create("Highlight", {
		Name = randomString(),
		Enabled = true,
		FillColor = Color3.new(1, 1, 1),
		FillTransparency = 0,
		OutlineColor = Color3.new(1, 1, 1),
		OutlineTransparency = 0,
		Adornee = Object,
		Parent = HiddenSource
	})
	
	local Transition = TweenService:Create(Cham, TaskHubScriptIdentity.DynamicChamConfiguration.TransitionInfo, {
		FillTransparency = 0.55,
		FillColor = Color3.fromRGB(85, 0, 0),
		OutlineColor = Color3.fromRGB(85, 0, 0),
		OutlineTransparency = 0.5
	})
	
	Transition.Completed:Once(function()
		Transition:Destroy()
	end)
	
	Transition:Play()
	
	local _, tempIndex = SyncConnection(Object.ChildAdded, function(_, _, Kid)
		if typeof(Kid) ~= "Instance" then
			return
		end
		
		if Kid:IsA("Highlight") then
			Kid:Destroy()
		end
	end)
	
	SyncConnection(Object.AncestryChanged, function(Connection, Index, _, newAncestry)
		if newAncestry ~= Ancestry then
			Cham:Destroy()
			CollectGarbage("TableIndexing", tempIndex)
			CollectGarbage("TableIndexing", Index)
			return
		end
	end)
end

function SetCharacterMode(mode)
	if not mode then
		return
	end
	
	local Character = GetCharacter()
	
	for _, Kid in pairs(Character:GetChildren()) do
		if Kid and Kid.Parent then
			if not Kid:IsA("BasePart") then
				continue
			end
			
			Kid.Shape = Enum.PartType[mode]
		end
	end
end

local function NpcCompressionCheck(_, _, Npc)
	if not Npc or typeof(Npc) ~= "Instance" then
		return
	end
	
	if (not Npc:IsA("Model")) or Npc.Name == "Statue" then
		return
	end
	
	local Points = Npc:GetAttribute("Points")
	if Points ~= nil then
		ApplyDynamicCham(Npc, NPCs)
		return
	end
	
	local Human = Npc:FindFirstChildOfClass("Humanoid")
	if Human then
		local MaxHealth = Human.MaxHealth
		if MaxHealth >= 1900 then
			ApplyDynamicCham(Npc, NPCs)
			return
		end
	end
	
	if Bosses[Npc.Name] then
		ApplyDynamicCham(Npc, NPCs)
		return
	end
end

ChangeModsActivationFormat("Chat", false)

SyncConnection(UserInputService.InputBegan, function(a0, a1, InputObject, Processed) 
	if Processed then
		return
	end
	
	if InputObject.KeyCode == Enum.KeyCode.P then
		if CurrentMethod == "Input" then
			ChangeModsActivationFormat("Chat", true)
		elseif CurrentMethod == "Chat" then
			ChangeModsActivationFormat("Input", true)
		end
	end
end)

for _, Kid in ipairs(NPCs:GetChildren()) do
	if typeof(Kid) == "Instance" then
		if Kid.Parent then
			NpcCompressionCheck(Kid)
		end
	end
end

SyncConnection(NPCs.ChildAdded, NpcCompressionCheck)