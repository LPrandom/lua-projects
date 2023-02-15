--[[
: steps
1. the host on the setting, you put the ID of the crasher or your main acc
2. you can set the fps for your alts, 1-3 reco
3. don't press start until you fully loaded your accs that will help u.

recommend:
- put this on auto-exec
]] 

getgenv().G_Settings = {
    host = 1234567890, -- user id of the crasher / main acc
    fps = 3 -- fps for alts
}

-- [[ no skids allowed no touch code below! ]] --

if not game:IsLoaded() then
    game.Loaded:Wait()
end

repeat wait(0.001) until workspace.Players:FindFirstChild(game:service"Players".LocalPlayer.Name)

local player = game:service"Players".LocalPlayer

local isCrasher = G_Settings['host'] == player.UserId
local enabled = false

local function sayMsg(msg)
    game:service"ReplicatedStorage".DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, 'All')
end

local function countTools()
    return #player.Backpack:GetChildren()
end

local function resetChar()
    for i,v in pairs(player.Character:GetChildren()) do
        if v:IsA("MeshPart") or v:IsA("BasePart") then
            v:Destroy()
        end
    end
end

local remotes = {
    "CHECKER_1",
    "CHECKER_2",
    "TeleportDetect",
    "OneMoreTime",
    "BreathingHAMON",
    "VirusCough",
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

player.Idled:Connect(function()
    game:service"VirtualUser":Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:service"VirtualUser":Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

if isCrasher then
    local totalTools, maximumTools = 0, 450
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/theracisthub/libs/main/ocinhot"))()
    local main = lib:Create("Crasher")
    local txt = main:NewLabel("Status: 0/0 %0")
    main:NewToggle("Enable","enables the crasher",false,function(bool)
        enabled = bool
        if bool then
            sayMsg("start")
        else
            sayMsg("pause")
        end
    end)
    main:NewSlider("Max","max tools",450,1250,function(c)
        maximumTools = c
    end)
    main:NewButton("Stop","stops the whole crashing process",function()
        sayMsg("stop")
    end)
    main:NewButton("Force Crash","force crashes",function()
        for i,v in pairs(player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = player.Character
            end
        end
        resetChar()
    end)
    main:NewSection("Graphics")
    main:NewToggle("White Screen","white screen for alts",false,function(bool)
        if bool then
            sayMsg("white_in")
        else
            sayMsg("white_out")
        end
    end)

    task.spawn(function()
        while true do wait(0.01)
            if enabled then
                pcall(function()
                    player.Character.HumanoidRootPart.CFrame = workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5").Head.CFrame * CFrame.new(0,1.5,0)
                    fireclickdetector(workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5"):FindFirstChild("ClickDetector"))

                    for i,v in pairs(workspace.Ignored:GetChildren()) do
                        if v.Name:lower():find("flower") and (player.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 5 then
                            pcall(function() fireclickdetector(v:FindFirstChild("ClickDetector")) end)
                        end
                    end
                end)
            end
            totalTools = countTools()
            txt:Update("Status: "..tostring(math.floor(totalTools)).."/"..tostring(math.floor(maximumTools)).." %"..tostring(string.format("%.2f",totalTools/maximumTools*100)))
        end
    end)
else
    task.spawn(function()
        local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/theracisthub/libs/main/ocinhot"))()
        local main = lib:Create("Crasher")
        main:NewLabel("you're a slave.")
    end)
    settings().Physics.PhysicsEnvironmentalThrottle = 1
    settings().Rendering.QualityLevel = 'Level01'
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("Part") then
            v.Material = Enum.Material.Pavement
            v.Transparency = 1
        elseif v:IsA("Decal") then
            v:Destroy()
        elseif v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("MeshPart") then
            v.TextureID = 0
            v.Transparency = 1
        elseif v.Name == "Terrian" then
            v.WaterReflectace = 1
            v.WaterTransparency = 1
        elseif v:IsA("SpotLight") then
            v.Range = 0
            v.Enabled = false
        elseif v:IsA("WedgePart") then
            v.Transparency = 1
        elseif v:IsA("UnionOperation") then
            v.Transparency = 1
        end
    end
    game:service"ReplicatedStorage".DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
        local user = game:service"Players":GetPlayerByUserId(game:service"Players":GetUserIdFromNameAsync(data.FromSpeaker))
        local msg = data.Message

        if user.UserId == G_Settings['host'] then
            if msg:lower() == "start" then
                enabled = true
            elseif msg:lower() == "pause" then
                enabled = false
            elseif msg:lower() == "stop" then
                enabled = false
                game:service"Players".LocalPlayer.Character.Humanoid.Health = 0
            elseif msg:lower() == "white_out" then
                game:service"RunService":Set3dRenderingEnabled(true)
            elseif msg:lower() == "white_in" then
                game:service"RunService":Set3dRenderingEnabled(false)
            end
        end

        local poses = {
            CFrame.new(1.5,1.5,0),
            CFrame.new(1.5,1.5,-1),
            CFrame.new(1.5,1.5,-2),
            CFrame.new(-1.5,1.5,0),
            CFrame.new(-1.5,1.5,-1),
            CFrame.new(-1.5,1.5,-2)
        }
    
        local pose = poses[math.random(1, #poses)]

        task.spawn(function()
            while true do wait(0.01)
                pcall(function()
                    if enabled then
                        player.Character.HumanoidRootPart.CFrame = workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5").Head.CFrame * pose
                        fireclickdetector(workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5"):FindFirstChild("ClickDetector"))
                        for n, m in pairs(player.Backpack:GetChildren()) do
                            if m.Name:lower():find("flower") then
                                m.Parent = player.Character
                                m:Activate()
                                wait(1.5)
                            end
                        end
                    end
                end)
            end
        end)
    end)

    local fpsFunc = setfps or set_fps
    pcall(function() fpsFunc(G_Settings['fps']) end)
end
