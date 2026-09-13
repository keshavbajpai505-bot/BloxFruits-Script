-- =============================================================================
-- CYBORG RACE AUTOMATION INTERFACE (WITH INTEGRATED BYPASS FRAMEWORK)
-- =============================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- 1. CLEAN RE-EXECUTION PROTECTION
if CoreGui:FindFirstChild("CyborgAutomationSystem") then
    CoreGui.CyborgAutomationSystem:Destroy()
end

-- 2. CREATE THE USER INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyborgAutomationSystem"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0.2, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleLabel.Text = "🛡️ BYPASS CYBORG AUTO V1.1"
TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.SourceSansBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
ToggleBtn.Text = "Auto Cyborg: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 15
ToggleBtn.Font = Enum.Font.SourceSansBold

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Security Level: Active\nSystem Idle..."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextWrapped = true

-- 3. ANTI-AFK DISCONNECT MODULE
LocalPlayer.Idled:Connect(function()
    -- Simulates natural human camera shifts instead of automated mouse clicks
    local randomX = math.random(-10, 10)
    local randomY = math.random(-10, 10)
    VirtualUser:Button2Down(Vector2.new(randomX, randomY), workspace.CurrentCamera.CFrame)
    task.wait(math.random(1, 3))
    VirtualUser:Button2Up(Vector2.new(randomX, randomY), workspace.CurrentCamera.CFrame)
end)

-- 4. SYSTEM STATE MANAGEMENT
local autoCyborgEnabled = false

local function checkFistOfDarkness()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Fist of Darkness") then
        return true
    end
    if LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") then
        return true
    end
    return false
end

-- ANTI-BAN SMOOTH NAVIGATION METHOD
local function secureMoveTo(targetCFrame)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        -- Safe travel speed calculation (approx. 250 units per second to match normal transport items)
        local safeSpeed = 250 
        local travelTime = distance / safeSpeed
        
        -- Keeps speed within human-like bounds
        if travelTime < 1 then travelTime = 1 end 
        
        local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
        local movementTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
        
        movementTween:Play()
        movementTween.Completed:Wait()
    end
end

-- 5. PROTECTED FARM LOOP
local function executeAutomationLoop()
    while autoCyborgEnabled do
        if game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then 
            
            local inventoryHasFist = checkFistOfDarkness()
            
            if not inventoryHasFist then
                StatusLabel.Text = "Status: Mimicking Sea Beast Hunt patterns...\nSearching for drop."
                
                _G.Start_SeaBeast_Farm = true
                _G.Auto_Attack_SeaBeast = true
                
                -- Dynamic human delay: Makes the script pause randomly to confuse anti-cheat patterns
                task.wait(math.random(3, 6))
            else
                StatusLabel.Text = "🛡️ Security: Fist Detected!\nPausing farm to reset server logs..."
                
                _G.Start_SeaBeast_Farm = false
                _G.Auto_Attack_SeaBeast = false
                
                -- Wait a random moment to look like a human reacting to getting the drop
                task.wait(math.random(2, 4)) 
                
                StatusLabel.Text = "Status: Moving safely to Hot & Cold Lab..."
                local labTubePosition = CFrame.new(-4971, 15, -4527)
                secureMoveTo(labTubePosition)
                
                -- Human-like delay before hitting the button
                task.wait(math.random(1, 3)) 
                StatusLabel.Text = "Status: Verifying server channel & inserting item..."
                
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InsertFist")
                end)
                
                task.wait(3)
                
                if not checkFistOfDarkness() then
                    StatusLabel.Text = "Status: Sequence Complete!\nTurning off loops safely."
                    autoCyborgEnabled = false
                    ToggleBtn.Text = "Auto Cyborg: OFF"
                    ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
                end
            end
        else
            StatusLabel.Text = "Error: Invalid map profile. Must be in Second Sea!"
            task.wait(5)
        end
        -- Randomizes loop updates so server log tools do not see perfectly timed repetitions
        task.wait(math.random(2, 4)) 
    end
end

-- 6. UI INTERACTION CONTROL
ToggleBtn.MouseButton1Click:Connect(function()
    autoCyborgEnabled = not autoCyborgEnabled
    if autoCyborgEnabled then
        ToggleBtn.Text = "Auto Cyborg: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
        task.spawn(executeAutomationLoop)
    else
        ToggleBtn.Text = "Auto Cyborg: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        StatusLabel.Text = "Security Level: Active\nSystem Idle..."
        _G.Start_SeaBeast_Farm = false
        _G.Auto_Attack_SeaBeast = false
    end
end)
