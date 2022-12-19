getgenv().Running = true
getgenv().Amount = 1600 -- make it higher if the crasher fails.

local Crasher = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Label = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

Crasher.Name = "Crasher"
Crasher.Parent = game:service"CoreGui"
Crasher.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = Crasher
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 30, 149)
MainFrame.BorderColor3 = Color3.fromRGB(60, 30, 149)
MainFrame.Position = UDim2.new(0.403971493, 0, 0.614880919, 0)
MainFrame.Size = UDim2.new(0, 242, 0, 63)
MainFrame.Active = true
MainFrame.Draggable = true

Label.Name = "Label"
Label.Parent = MainFrame
Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1.000
Label.Position = UDim2.new(0.0867768601, 0, 0.095238097, 0)
Label.Size = UDim2.new(0, 200, 0, 50)
Label.Font = Enum.Font.Cartoon
Label.Text = "Amount: 0/"..tostring(Amount)
Label.TextColor3 = Color3.fromRGB(0, 0, 0)
Label.TextSize = 30.000

UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = MainFrame

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

local function getAmt()
    local cnt = 0
    for i,v in pairs(game:service"Players".LocalPlayer.Character:GetChildren()) do
        if v.Name == "[SnowBall]" or v.Name == "[SprayCan]" then
            cnt = cnt + 1
        end
    end
    return cnt
end

if game:service"Players".LocalPlayer.Character.BodyEffects:FindFirstChild("Attacking") then
        game:service"Players".LocalPlayer.Character.BodyEffects:FindFirstChild("Attacking"):Destroy()
    end
    local g, groups = {},game:service"GroupService":GetGroupsAsync(game:service"Players".LocalPlayer.UserId)
    for i,v in pairs(groups) do
        table.insert(g,v.Id)
    end
    if not g[1] then
        game:service"StarterGui":SetCore("SendNotification",{
        Title = "Error!";
        Text = "Please be atleast in 1 group.";
        Duration = 10;
    })
    return
end
pcall(function()
    game:GetService("Players").LocalPlayer.PlayerGui.MainScreenGui.Crew.CrewFrame:Destroy()
end)
local SelectedId = g[math.random(#g)]
if game:service"Players".LocalPlayer.Backpack:FindFirstChild("[SprayCan]") then
    game:service"Players".LocalPlayer.Backpack:FindFirstChild("[SprayCan]").Parent = game:service"Players".LocalPlayer.Character
end

while Running == true do
    if not Running then break end
    wait()
    for i,v in pairs(game:service"Players".LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "[SnowBall]" or v.Name == "[SprayCan]" then
            v:FindFirstChild("Handle").Transparency = 100
            v.Parent = game:service"Players".LocalPlayer.Character
        end
    end

    game:service"Players".LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-355,30,269)
    game:service"ReplicatedStorage".MainEvent:FireServer("PickSnow")
    game:service"ReplicatedStorage".MainEvent:FireServer("JoinCrew",tostring(SelectedId))
    local amt = getAmt()
    
    Label.Text = "Amount: "..tostring(amt).."/"..tostring(Amount)

    if amt >= Amount then
        for i,v in pairs(game:service"Players".LocalPlayer.Character:GetChildren()) do
            if v:IsA("MeshPart") then
                v:Destroy()
            end
        end
    end
end
