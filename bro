game.StarterGui:SetCore("SendNotification", {
    Title = "CultWare";
    Text =  "Welcome Master";
    Icon = "rbxthumb://type=Asset&id=1332213374&w=150&h=150"
    })
  

local Config = {
    WindowName = "cultware.cc (from tenaki)",
	Color = Color3.fromRGB(255,255,255),
	Keybind = Enum.KeyCode.RightShift
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua"))()
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local Tab1 = Window:CreateTab("Rage")
local yesloltab = Window:CreateTab("Misc")
local Tab4 = Window:CreateTab("Settings")

local Section1 = Tab1:CreateSection("Aimbot")
local Section2 = Tab1:CreateSection("Silent Aim")
local Section0 = Tab1:CreateSection("Fov")
local Section8 = yesloltab:CreateSection("Esp")
local Section23 = yesloltab:CreateSection("Anti Aim")
local Section24 = yesloltab:CreateSection("Rotation")
local Section3 = Tab4:CreateSection("Menu")
local Section4 = Tab4:CreateSection("Background")
local Section5 = Tab4:CreateSection("Configs")
local Section26 = yesloltab:CreateSection("Buffs")
local Section28 = yesloltab:CreateSection("Insane")



-------------
local Techware = Section23:CreateButton("Antilock", true, function(AntiAim)
end)

-------------
local NoRecoil = Section26:CreateButton("No Recoil", true, function(recoil)
goble = recoil
end)

-------------
local LowGfx = Section26:CreateButton("Low Gfx", true, function(Gfx)
end)

-------------
getgenv().AimPart = "HumanoidRootPart" -- For R15 Games: {UpperTorso, LowerTorso, HumanoidRootPart, Head} | For R6 Games: {Head, Torso, HumanoidRootPart}
getgenv().AimlockKey = "q"
getgenv().AimRadius = 30 -- How far away from someones character you want to lock on at
getgenv().ThirdPerson = true 
getgenv().FirstPerson = true
getgenv().TeamCheck = false -- Check if Target is on your Team (True means it wont lock onto your teamates, false is vice versa) (Set it to false if there are no teams)
getgenv().PredictMovement = true -- Predicts if they are moving in fast velocity (like jumping) so the aimbot will go a bit faster to match their speed 
getgenv().PredictionVelocity = 9

local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
local Aimlock, MousePressed, CanNotify = false, false, false;
local AimlockTarget;
getgenv().CiazwareUniversalAimbotLoaded = true

getgenv().WorldToViewportPoint = function(P)
    return Camera:WorldToViewportPoint(P)
end

getgenv().WorldToScreenPoint = function(P)
    return Camera.WorldToScreenPoint(Camera, P)
end

getgenv().GetObscuringObjects = function(T)
    if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then 
        local RayPos = workspace:FindPartOnRay(RNew(
            T[getgenv().AimPart].Position, Client.Character.Head.Position)
        )
        if RayPos then return RayPos:IsDescendantOf(T) end
    end
end

getgenv().GetNearestTarget = function()
    -- Credits to whoever made this, i didnt make it, and my own mouse2plr function kinda sucks
    local players = {}
    local PLAYER_HOLD  = {}
    local DISTANCES = {}
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= Client then
            table.insert(players, v)
        end
    end
    for i, v in pairs(players) do
        if v.Character ~= nil then
            local AIM = v.Character:FindFirstChild("Head")
            if getgenv().TeamCheck == true and v.Team ~= Client.Team then
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            elseif getgenv().TeamCheck == false and v.Team == Client.Team then 
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            end
        end
    end
    
    if unpack(DISTANCES) == nil then
        return nil
    end
    
    local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
    if L_DISTANCE > getgenv().AimRadius then
        return nil
    end
    
    for i, v in pairs(PLAYER_HOLD) do
        if v.diff == L_DISTANCE then
            return v.plr
        end
    end
    return nil
end

Mouse.KeyDown:Connect(function(a)
    if a == AimlockKey and AimlockTarget == nil then
        pcall(function()
            if MousePressed ~= true then MousePressed = true end 
            local Target;Target = GetNearestTarget()
            if Target ~= nil then 
                AimlockTarget = Target
            end
        end)
    elseif a == AimlockKey and AimlockTarget ~= nil then
        if AimlockTarget ~= nil then AimlockTarget = nil end
        if MousePressed ~= false then 
            MousePressed = false 
        end
    end
end)

RService.RenderStepped:Connect(function()
    if getgenv().ThirdPerson == true and getgenv().FirstPerson == true then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    elseif getgenv().ThirdPerson == false and getgenv().FirstPerson == true then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    end
    if Aimlock == true and MousePressed == true then 
        if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().AimPart) then 
            if getgenv().FirstPerson == true then
                if CanNotify == true then
                    if getgenv().PredictMovement == true then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                    elseif getgenv().PredictMovement == false then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                    end
                end
            elseif getgenv().ThirdPerson == true then 
                if CanNotify == true then
                    if getgenv().PredictMovement == true then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                    elseif getgenv().PredictMovement == false then 
                        Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                    end
                end 
            end
        end
    end
end)







-------------
local Toggle1 = Section1:CreateToggle("Enabled", nil, function(t)
	Aimlock = t
end)


 -------------
local Toggle4 = Section1:CreateToggle("Anti Ground", nil, function ()
end)


-------------
local Toggle5 = Section1:CreateToggle("Team Check", nil, function (Xd)
    getgenv().TeamCheck = Xd
end)



-------------
local TextBox1 = Section1:CreateTextBox("Bullet Prediction", "Value", true, function(E)
	getgenv().PredictionVelocity = E
end)

-------------
local Slider1 = Section1:CreateSlider("Aimbot Radius", 0,100,nil,true, function(Rad)
	getgenv().AimRadius = Rad
end)
Slider1:AddToolTip("Lock On Effect")
Slider1:SetValue(50)

-------------
local Dropdown1 = Section1:CreateDropdown("Aimpart", {"Head","UpperTorso","HumanoidRootPart","LowerTorso"}, function(String)
	getgenv().AimPart = String
end)
Dropdown1:AddToolTip("Lock On Part")
Dropdown1:SetOption("Aimpart")
-------------


local Aiming = loadstring(game:HttpGet("https://pastebin.com/raw/SAsEQV3y"))()
Aiming.TeamCheck(false)


local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera

local DaHoodSettings = {
    SilentAim = false,
    AimLock = false,
    Prediction = 0.157,
    AimLockKeybind = Enum.KeyCode.E
}
getgenv().DaHoodSettings = DaHoodSettings


function Aiming.Check()
-------------
    if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
        return false
    end

    -- // Check if downed
    local Character = Aiming.Character(Aiming.Selected)
    local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
    local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil

    -- // Check B
    if (KOd or Grabbed) then
        return false
    end

    -- //
    return true
end

-- // Hook
local __index
__index = hookmetamethod(game, "__index", function(t, k)
    -- // Check if it trying to get our mouse's hit or target and see if we can use it
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and Aiming.Check()) then
        local SelectedPart = Aiming.SelectedPart

        -- // Hit/Target
        if (DaHoodSettings.SilentAim and (k == "Hit" or k == "Target")) then
            -- // Hit to account prediction
            local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)

            -- // Return modded val
            return (k == "Hit" and Hit or SelectedPart)
        end
    end

    -- // Return
    return __index(t, k)
end)

-- // Aimlock
RunService:BindToRenderStep("AimLock", 0, function()
    if (DaHoodSettings.AimLock and Aiming.Check() and UserInputService:IsKeyDown(DaHoodSettings.AimLockKeybind)) then
        -- // Vars
        local SelectedPart = Aiming.SelectedPart

        -- // Hit to account prediction
        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)

        CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)
    end
    end)

-------------
Section2:CreateLabel("")
-------------
local Toggle2 = Section2:CreateToggle("Enabled", nil, function(Sate)
    DaHoodSettings.SilentAim = Sate
end)

local PoopSex = Section2:CreateToggle("Silent Aim Keybind", nil, function(as)
    DaHoodSettings.SilentAim = as
end)
PoopSex:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)

local colo2 = Section24:CreateButton("Spin" ,false, function(ef)
    
end)



local LMAO = Section2:CreateToggle("Visiblity Check", nil, function(RAR)
    Aiming.VisibleCheck = RAR
end)

-------------
local Dropdown2 = Section2:CreateDropdown("Modules ", {"Normal","Notification","Webhook"}, function(String)
	
end)
Dropdown2:AddToolTip("Expermimental May Not Work [!]")
Dropdown2:SetOption("Normal")
-------------
local Dropdown2 = Section2:CreateDropdown("Hitbox ", {"Head","UpperTorso","HumanoidRootPart","LowerTorso"}, function(STD)
	Aiming.TargetPart = STD
end)
Dropdown2:AddToolTip("Expermimental May Not Work [!]")
Dropdown2:SetOption("Hitbox")
-------------
local NealXD = Section2:CreateDropdown("Aim Type ", {"Nearest","Cursor","Fov"}, function(STD)

end)
Dropdown2:AddToolTip("Expermimental May Not Work [!]")
Dropdown2:SetOption("Nearest")


local Cok123 = Section2:CreateTextBox("Bullet Prediction", "Value", true, function(E)
    DaHoodSettings.Prediction = E
end)
Cok123:AddToolTip("Bullet Speed")
Cok123:SetValue(0.157)





local Slider2 = Section2:CreateSlider("Bullet Range", 0,1000,nil,false, function(Vacalue)
	
end)
Slider2:AddToolTip("Range Distance")
Slider2:SetValue(1000)
-------------



local Goggle = Section0:CreateToggle("View", nil, function(Cape)
    Aiming.ShowFOV = Cape
end)

local Ganger = Section0:CreateSlider("Size", 0,350,nil,false, function(FOV)
	Aiming.FOV = FOV
end)
Slider2:AddToolTip("Size")
Slider2:SetValue(45)


local Colorpicker2 = Section0:CreateColorpicker("View Colour", function(Color)
	Aiming.FOVColour = Color
end)
Colorpicker2:AddToolTip("Fov Colour")
Colorpicker2:UpdateColor(Color3.fromRGB(0,0,255))
-------------
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

local Bruh = Section8:CreateToggle("Enabled", nil, function(bool)
    ESP:Toggle(bool)
end)

local huh = Section8:CreateToggle("Tracers", nil, function(bool)
ESP.Tracers = bool
end)

local cuh = Section8:CreateToggle("Names", nil, function(bool)
    ESP.Names = bool
    end)
    
    local nuh = Section8:CreateToggle("Boxes", nil, function(bool)
        ESP.Boxes = bool
        end)
       
 local Colorpicker4 = Section8:CreateColorpicker("Colour", function(bool)
    ESP.Color = bool
  end)   
    Colorpicker4:UpdateColor(Config.Color)

local Toggle3 = Section3:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)
Toggle3:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)
Toggle3:SetState(true)

local Colorpicker3 = Section3:CreateColorpicker("UI Color", function(Color)
	Window:ChangeColor(Color)
end)
Colorpicker3:UpdateColor(Config.Color)






-- credits to jan for patterns
local Dropdown3 = Section4:CreateDropdown("Image", {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"}, function(Name)
	if Name == "Default" then
		Window:SetBackground("5553946656")
	elseif Name == "Hearts" then
		Window:SetBackground("6073763717")
	elseif Name == "Abstract" then
		Window:SetBackground("6073743871")
	elseif Name == "Hexagon" then
		Window:SetBackground("6073628839")
	elseif Name == "Circles" then
		Window:SetBackground("6071579801")
	elseif Name == "Lace With Flowers" then
		Window:SetBackground("6071575925")
	elseif Name == "Floral" then
		Window:SetBackground("5553946656")
	end
end)
Dropdown3:SetOption("Default")

local Colorpicker4 = Section4:CreateColorpicker("Color", function(Color)
	Window:SetBackgroundColor(Color)
end)
Colorpicker4:UpdateColor(Color3.new(1,1,1))

local Slider3 = Section4:CreateSlider("Transparency",0,1,nil,false, function(Value)
	Window:SetBackgroundTransparency(Value)
end)
Slider3:SetValue(0)

local Slider4 = Section4:CreateSlider("Tile Scale",0,1,nil,false, function(Value)
	Window:SetTileScale(Value)
end)
Slider4:SetValue(0.5)



