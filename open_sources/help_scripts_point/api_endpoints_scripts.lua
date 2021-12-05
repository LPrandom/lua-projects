local option = getgenv().OPTION

local function main()
    if option == "dhlowgfx" then
        local decalsyeeted = true
        local g = game
        local w = g.Workspace
        local l = g.Lighting
        local t = w.Terrain
        t.WaterWaveSize = 1
        t.WaterWaveSpeed = 1
        t.WaterReflectance = 1
        t.WaterTransparency = 1
        l.GlobalShadows = false
        l.FogEnd = 9e9
        l.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        for i,v in pairs(g:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
                v.Transparency = 100
            elseif v:IsA("Decal") and decalsyeeted then 
                v.Transparency = 100
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then 
                v.Lifetime = NumberRange.new(0)
            end
        end
    elseif option == "discord" then
        game.StarterGui:SetCore("SendNotification",{
            Title = "Discord!";
            Text = "https://discord.gg/encrypt";
            Duration = 10;
        })
    elseif option == "encryptcrasher" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LPrandom/lua-projects/master/dahoodcrasher.lua"))()
    elseif option == "randnum" then
        return math.random(1,999999)
    else
        return print("Error with the end point.")
    end
end

local success,err = pcall(main)
