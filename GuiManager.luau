local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local MODULE_PATHS = {
	
	Status = {
		Parent = PlayerGui:WaitForChild("TimerGui"),
		ModuleName = "StatusClient"
	},
	Shop = {
		Parent = PlayerGui:WaitForChild("ShopGui"),
		ModuleName = "ShopFunctions"
	},
	Inventory = {
		Parent = PlayerGui:WaitForChild("InventoryGui"),
		ModuleName = "InventoryFunctions"
	},
	Sprint = {
		Parent = PlayerGui:WaitForChild("StaminaGui"),
		ModuleName = "SprintController"
	},
	
}

local InitializedModules = {}

local function InitializeUI()
	print("Loading UI...")
	local startTime = os.clock()

	for name, info in pairs(MODULE_PATHS) do
		local moduleStartTime = os.clock()
		local moduleScript = info.Parent:FindFirstChild(info.ModuleName)

		if moduleScript and moduleScript:IsA("ModuleScript") then
			local success, result = pcall(function()
				return require(moduleScript)
			end)

			local moduleEndTime = os.clock()
			local loadTime = string.format("%.4f", moduleEndTime - moduleStartTime)

			if success then
				InitializedModules[name] = result
				if name == "Sprint" then
					local mainGui = PlayerGui:WaitForChild("StaminaGui") 
					local staminaLabel = mainGui:WaitForChild("StaminaLabel")

					result.Init(staminaLabel)
				end
			else
				warn("[GuiHandler]: Failed " .. name .. " after " .. loadTime .. "s | Error: " .. tostring(result))
			end
		else
			warn("[GuiHandler]: Missing module for " .. name)
		end
	end

	local totalEndTime = os.clock()
	local totalTime = string.format("%.4f", totalEndTime - startTime)

	print("Total Load Time: " .. totalTime .. " seconds")
end

InitializeUI()
