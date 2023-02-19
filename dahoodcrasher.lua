-- // made by arrayed

if not game:IsLoaded() then
    game.Loaded:Wait()
end

repeat wait(0.001) until workspace.Players:FindFirstChild(game:service"Players".LocalPlayer.Name)

local player = game:service"Players".LocalPlayer
local isCrasher = G_Settings['host'] == player.UserId
local enabled = true

local function sayMsg(msg)
    game:service"ReplicatedStorage".DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, 'All')
end

local function countTools()
    return #player.Backpack:GetChildren()
end

local function resetChar()
    for i,v in pairs(player.Character:GetChildren()) do
        if v:IsA("MeshPart") or v:IsA("BasePart") or v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

player.Idled:Connect(function()
    game:service"VirtualUser":Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:service"VirtualUser":Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

if isCrasher then
    local totalTools, maximumTools = 0, 1250
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/theracisthub/libs/main/ocinhot"))()
    local main = lib:Create("Crasher")
    local txt = main:NewLabel("Status: 0/0 %0")
    main:NewToggle("Enable","enables the crasher",true,function(bool)
        enabled = bool
        if bool then
            sayMsg("start")
        else
            sayMsg("pause")
        end
    end)
    main:NewSlider("Max","max tools",1250,2500,function(c)
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
            game:service"RunService":Set3dRenderingEnabled(false)
        else
            sayMsg("white_out")
            game:service"RunService":Set3dRenderingEnabled(true)
        end
    end)

    local stop = false
    task.spawn(function()
        while true do wait(0.01)
            if enabled then
                pcall(function()
                    for i,v in pairs(workspace.Ignored.ItemsDrop:GetDescendants()) do
                        if v.Name == "[Knife]" or v.Name == "[LockPicker]" then
                            player.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                            wait(0.5)

                            for i,v in pairs(player.Character:GetChildren()) do
                                if v:IsA("Tool") then
                                    v.Parent = player.Backpack
                                end
                            end
                        end
                    end
                    player.Character.HumanoidRootPart.CFrame = workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5").Head.CFrame * CFrame.new(0,1.5,0)
                    fireclickdetector(workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5"):FindFirstChild("ClickDetector"))

                    for i,v in pairs(workspace.Ignored:GetChildren()) do
                        if v.Name:lower():find("flower") and (player.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 20 then
                            pcall(function() fireclickdetector(v:FindFirstChild("ClickDetector")) end)
                        end
                    end
                end)
            end
            totalTools = countTools()
            txt:Update("Status: "..tostring(math.floor(totalTools)).."/"..tostring(math.floor(maximumTools)).." %"..tostring(string.format("%.2f",totalTools/maximumTools*100)))
            if tonumber(totalTools) >= tonumber(maximumTools) then
                stop = true
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(5000,5000,5000)
                wait(0.2)
                for i,v in pairs(player.Backpack:GetChildren()) do
                    if v:IsA("Tool") then
                        v.Parent = player.Character
                    end
                end
                wait(1)
                resetChar()
            end
        end
    end)
else
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

        task.spawn(function()
            while true do wait(0.01)
                pcall(function()
                    if enabled then
                        repeat
                            player.Character.HumanoidRootPart.CFrame = workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5").Head.CFrame * CFrame.new(math.random(-4,4),1.3,-3)
                            fireclickdetector(workspace.Ignored.Shop:FindFirstChild("[Flowers] - $5"):FindFirstChild("ClickDetector"))
                            wait(0.01)
                        until player.Backpack:FindFirstChild("[FlowersTool]") or player.Character:FindFirstChild("[FlowersTool]")
                        repeat
                            for n, m in pairs(player.Backpack:GetChildren()) do
                                if m.Name:lower():find("flower") then
                                    m.Parent = player.Character
                                    m:Activate()
                                    wait(0.5)
                                end
                            end
                            wait()
                            for i,v in pairs(player.Character:GetChildren()) do
                                if v:IsA("Tool") and v.Name:lower():find("flower") then
                                    v:Activate()
                                    wait(0.5)
                                end
                            end
                            if not player.Backpack:FindFirstChild("[FlowersTool]") and not player.Character:FindFirstChild("[FlowersTool]") then
                                break
                            end
                        until not player.Backpack:FindFirstChild("[FlowersTool]") and not player.Character:FindFirstChild("[FlowersTool]")
                        resetChar()
                    end
                end)
            end
        end)
    end)

    local fpsFunc = setfpscap or set_fps_cap
    pcall(function() fpsFunc(getgenv().G_Settings['fps']) end)
end
