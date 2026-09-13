-- =============================================================================
-- ADVANCED CYBORG AUTO-FARM ENGINE v1.3 (FULL VEHICLE & ENEMY FARMING MECHANICS)
-- =============================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

-- 1. WINDOW OVERLAP MANAGEMENT
if CoreGui:FindFirstChild("CyborgAutomationSystem") then
    CoreGui.CyborgAutomationSystem:Destroy()
end

-- 2. DYNAMIC INTERFACE FRAMEWORK
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyborgAutomationSystem"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 330, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0.18, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TitleLabel.Text = "⚡ CYBORG MARINER ULTIMATE V1.3"
TitleLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBtn.Size = UDim2.new(0.9, 0, 0.22, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 35, 35)
ToggleBtn.Text = "SYSTEM ENGAGEMENT: DEACTIVATED"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0.4, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "System Status: Standing By\nAnti-Ban Engine: ARMED"
StatusLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextWrapped = true

-- Anti-AFK Simulation Layer
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(math.random(1, 2))
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- 3. GLOBAL VARIABLES & MAP CONSTANTS
local autoCyborgEnabled = false
local currentOwnedBoat = nil
local maxMapBoundary = 5800 -- Distance configuration to catch sea border walls early
local dockPositionSecondSea = CFrame.new(-3821, 15, -3412) -- Standard Docks coordinate vector

local function checkFistOfDarkness()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Fist of Darkness") then
        return true
    end
    if LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") then
        return true
    end
    return false
end

-- 4. ANTI-BAN SMOOTH MAP NAVIGATION MECHANISM
local function secureMoveTo(targetCFrame, speedOverride)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local speed = speedOverride or 220 
        local travelTime = distance / speed
        if travelTime < 1 then travelTime = 1 end
        
        local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
        local navTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
        navTween:Play()
        navTween.Completed:Wait()
    end
end

-- 5. RE-BUY ENGINE MECHANISM (DOCK INTERACTION)
local function procureAndBoardSloop()
    StatusLabel.Text = "🛡️ Anti-Ban: Returning smoothly to Docks to refresh vehicle ID..."
    secureMoveTo(dockPositionSecondSea, 300)
    task.wait(math.random(2, 3)) -- Human choice emulation delay
    
    StatusLabel.Text = "Status: Interacting with Harbor Dealer -> Purchasing Marine Sloop..."
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "MarineSloop")
    end)
    task.wait(3)

    -- Detect the physical creation of the vehicle instance tagged under player ownership
    for _, object in pairs(Workspace:GetChildren()) do
        if object.Name == LocalPlayer.Name .. "'s Boat" or (object:FindFirstChild("Owner") and object.Owner.Value == LocalPlayer) then
            currentOwnedBoat = object
            break
        end
    end

    if currentOwnedBoat then
        local seat = currentOwnedBoat:FindFirstChildOfClass("VehicleSeat") or currentOwnedBoat:FindFirstChild("VehicleSeat", true)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if seat and humanoid then
            StatusLabel.Text = "Status: Pilot located. Anchoring character to helm..."
            seat:Sit(humanoid)
            task.wait(1.5)
            return true
        end
    end
    return false
end

-- 6. SEA BEAST SCANNER ENGINE
local function scanForSeaBeast()
    -- Iterates through active scene objects looking for the Sea Beast instance ID
    for _, entity in pairs(Workspace:GetChildren()) do
        if entity.Name == "Sea Beast" and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0 then
            return entity
        end
    end
    return nil
end

-- 7. PHYSICAL VEHICLE NAVIGATION & COMBAT MATRIX LOOP
local function runSloopSailingProtocol()
    while autoCyborgEnabled and not checkFistOfDarkness() and currentOwnedBoat and currentOwnedBoat.Parent do
        local mainPart = currentOwnedBoat:FindFirstChild("MainPart") or currentOwnedBoat.PrimaryPart
        if not mainPart then break end 
        
        local currentPos = mainPart.Position
        
        -- DYNAMIC STRUCTURAL MONITOR: Watch for Sea Beast Entity Spawns
        local targetSeaBeast = scanForSeaBeast()
        
        if targetSeaBeast then
            StatusLabel.Text = "⚔️ Combat Warning: Sea Beast Sighted! Initiating combat routine..."
            local bodyVel = mainPart:FindFirstChild("AutoDriveVelocity")
            if bodyVel then bodyVel.Velocity = Vector3.new(0, 0, 0) end -- Halt vehicle movement
            
            while targetSeaBeast and targetSeaBeast.Parent and targetSeaBeast.Humanoid.Health > 0 and autoCyborgEnabled do
                pcall(function()
                    local args = { targetSeaBeast.HumanoidRootPart.Position }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AttackTarget", args)
                end)
                task.wait(0.2)
                targetSeaBeast = scanForSeaBeast()
            end
            StatusLabel.Text = "Status: Sea Beast Neutralized. Resuming ocean scouting..."
            task.wait(math.random(1, 3))
        end

        -- ENGINE DRIVE VELOCITY OBJECT CREATION
        local bodyVelocity = mainPart:FindFirstChild("AutoDriveVelocity") or Instance.new("BodyVelocity")
        bodyVelocity.Name = "AutoDriveVelocity"
        bodyVelocity.MaxForce = Vector3.new(150000, 0, 150000)
        bodyVelocity.Parent = mainPart

        -- BOUNDARY VECTOR CONTROL (SIDEWAYS DRIVING ENGINE)
        if math.abs(currentPos.X) > maxMapBoundary or math.abs(currentPos.Z) > maxMapBoundary then
            StatusLabel.Text = "🛡️ Boundary Alert: Border Wall hit. Executing Sideways Scan pattern..."
            local escapeVector = Vector3.new(-currentPos.Z, 0, currentPos.X).Unit
            bodyVelocity.Velocity = escapeVector * 50 -- Sideways search speed
        else
            bodyVelocity.Velocity = mainPart.CFrame.LookVector * 80 -- Standard cruising speed
        end

        task.wait(0.5)
    end
end

-- 8. CORE AUTOMATION WORKFLOW ORCHESTRATOR
local function executeMasterLoop()
    while autoCyborgEnabled do
        if game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
            
            if not checkFistOfDarkness() then
                -- CRITICAL ASSET WATCHER: Validate if boat model is dead or missing
                if not currentOwnedBoat or not currentOwnedBoat.Parent or not currentOwnedBoat:FindFirstChild("MainPart") then
                    StatusLabel.Text = "⚠️ Hull Alert: Vessel destroyed! Resetting sequence..."
                    local successfullySpawning = procureAndBoardSloop()
                    if not successfullySpawning then
                        task.wait(4)
                    end
                else
                    runSloopSailingProtocol()
                end
            else
                -- PROCESS INVENTORY DROP STEP
                StatusLabel.Text = "🛡️ Security: Fist of Darkness Captured! Disengaging all naval engines..."
                currentOwnedBoat = nil
                task.wait(math.random(2, 4))
                
                StatusLabel.Text = "Status: Navigating cleanly to Hot & Cold Secret Lab..."
                local labReceptacleLocation = CFrame.new(-4971, 15, -4527)
                secureMoveTo(labReceptacleLocation, 240)
                
                task.wait(math.random(2, 3))
                StatusLabel.Text = "Status: Accessing console array. Uploading item..."
                
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InsertFist")
                end)
