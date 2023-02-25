-- // have fun skidding !!!
if not game:IsLoaded() then
    game.Loaded:Wait()
end

repeat wait(0.01) until workspace.Players:FindFirstChild(game:service"Players".LocalPlayer.Name)

local player = game:service"Players".LocalPlayer
local event = game:service"ReplicatedStorage".MainEvent
local location = CFrame.new(-217,-28,335)
local isStomper = player.UserId == getgenv().BountySettings["stomper"]
local isKiller = player.UserId == getgenv().BountySettings["killer"]

player.Idled:connect(function()
	game:service"VirtualUser":Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	game:service"VirtualUser":Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local remotes = {
    "CHECKER_1",
    "CHECKER_2",
    "TeleportDetect",
    "OneMoreTime",
    "BreathingHAMON",
    "VirusCough"
}

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(...)
    local args = {...}
    local method = getnamecallmethod()
    if (method == "FireServer" and args[1].Name == "MainEvent" and table.find(remotes, args[2])) then
        return
    end
    return __namecall(table.unpack(args))
end)

local function lowGFX(host, fps)
    host = host or false
    fps = fps or 3
    local fps_capper = setfpscap or set_fps_cap

    pcall(function() fps_capper(fps) end)
    settings().Physics.PhysicsEnvironmentalThrottle = 1
    settings().Rendering.QualityLevel = 'Level01'
    UserSettings():GetService("UserGameSettings").MasterVolume = 0
    if not host then
        game:service"RunService":Set3dRenderingEnabled(false)
    end
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("Part") then
            v.Material = Enum.Material.SmoothPlastic
            if not host then
                v.Transparency = 1
            end
        elseif v:IsA("Decal") then
            v:Destroy()
        elseif v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("MeshPart") then
            v.TextureID = 0
            if not host then
                v.Transparency = 1
            end
        elseif v.Name == "Terrian" then
            v.WaterReflectace = 1
            v.WaterTransparency = 1
        elseif v:IsA("SpotLight") then
            v.Range = 0
            v.Enabled = false
        elseif v:IsA("WedgePart") then
            if not host then
                v.Transparency = 1
            end
        elseif v:IsA("UnionOperation") then
            if not host then
                v.Transparency = 1
            end
        end
    end
end

if isStomper or isKiller then -- checks for mutual groups
    local killersGroups, stomperGroups = {}, {} 
    for i,v in pairs(game:service"GroupService":GetGroupsAsync(getgenv().BountySettings["killer"])) do
        table.insert(killersGroups, v.Id)
    end
    for i,v in pairs(game:service"GroupService":GetGroupsAsync(getgenv().BountySettings["stomper"])) do
        table.insert(stomperGroups, v.Id)
    end

    event:FireServer("LeaveCrew")
    task.delay(3, function()
        pcall(function()
            player.PlayerGui.MainScreenGui.Crew.CrewFrame:Destroy()
        end)
        for i,v in pairs(killersGroups) do
            for c,n in pairs(stomperGroups) do
                if v == n then
                    repeat -- dumb reason doesn't join first try lol
                        event:FireServer("JoinCrew", tostring(v))
                        wait(0.01)
                    until tostring(player.DataFolder.Information.Crew.Value) == tostring(v)
                end
            end
        end
    end)
end

local function findTool(baseName)
    baseName = tostring(baseName):lower()
    for i,v in pairs(workspace.Ignored.Shop:GetChildren()) do
        if v.Name:lower():sub(1,baseName:len()) == baseName:sub(1,baseName:len()) then
            return v
        end
    end
    return nil
end

game:service"Players".PlayerRemoving:Connect(function(child)
    if child.UserId == getgenv().BountySettings["stomper"] and getgenv().BountySettings["autoLeave"] then
        game:Shutdown()
    end
end)

if isStomper then
    local OldWanted = player.leaderstats.Wanted.Value
    player.leaderstats.Wanted.Changed:Connect(function()
        if player.leaderstats.Wanted.Value >= OldWanted + getgenv().BountySettings["goal"] then
            player:Kick("goal", getgenv().BountySettings["goal"], "reached")
        end
    end)

    task.spawn(function()
        lowGFX(true, 30)
        while true do wait(0.001)
            pcall(function()
                for i,v in pairs(game:service"Players":GetChildren()) do
                    if v.Name ~= player.Name and v.Character.BodyEffects:FindFirstChild("K.O").Value == true and v.Character.BodyEffects:FindFirstChild("Dead").Value == false then
                        repeat
                            player.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.UpperTorso.Position) + Vector3.new(0,1.6,0)
                            event:FireServer("Stomp")
                            wait(0.01)
                        until v.Character.BodyEffects:FindFirstChild("Dead").Value == true
                        pcall(function() workspace.Players:FindFirstChild(v.Name):Destroy() end)
                    end
                end
            end)
        end
    end)
elseif isKiller then
    local bat = findTool("[Bat]")
    task.spawn(function()
        lowGFX(false, 3)
        local weapon = ""
        while true do wait(0.01)
            pcall(function()
                if not player.Backpack:FindFirstChild("[Bat]") and not player.Character:FindFirstChild("[Bat]") and player.DataFolder.Currency.Value >= 1000 then
                    repeat
                        player.Character.HumanoidRootPart.CFrame = bat.Head.CFrame
                        fireclickdetector(bat:FindFirstChildWhichIsA("ClickDetector"))
                        wait(0.01)
                    until player.Backpack:FindFirstChild("[Bat]") or player.Character:FindFirstChild("[Bat]")
                    weapon = "[Bat]"
                elseif not player.Backpack:FindFirstChild("[Bat]") and not player.Character:FindFirstChild("[Bat]") and player.DataFolder.Currency.Value < 1000 then
                    weapon = "Combat"
                end

                if player.Backpack:FindFirstChild(weapon) then
                    player.Backpack:FindFirstChild(weapon).Parent = player.Character
                end
                player.Character.HumanoidRootPart.CFrame = location
                player.Character:FindFirstChild(weapon):Activate()
            end)
        end
    end)
else
    task.spawn(function()
        lowGFX(false, 3)
        while true do wait(0.001)
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = location + Vector3.new(math.random(-1,1), 0, math.random(-1,1))
            end)
        end
    end)
end
