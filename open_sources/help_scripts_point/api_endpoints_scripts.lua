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
    end
end

local success,err = pcall(main)