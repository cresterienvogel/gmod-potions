POTIONS.List = {}

hook.Add("Initialize", "Potion Register", function()
    for _, name in pairs(file.Find("potions/list/*", "LUA")) do
        if SERVER then
            AddCSLuaFile("potions/list/" .. name)
        end

        POTION = {}

        POTION.Key = string.StripExtension(name)
        POTION.Name = "Unknown Potion"

        POTION.Model = "models/sohald_spike/props/potion_4.mdl"
        POTION.Color = color_white
        POTION.Scale = 3

        POTION.CustomCheck = function() 
            return true 
        end

        POTION.OnDrink = function() end

        if CLIENT or SERVER then
            include("potions/list/" .. name)
        end

        POTIONS.List[POTION.Key] = POTION

        --[[
            Register a swep
        ]]

        local SWEP = weapons.Get("potion_base")
        SWEP.PrintName = POTION.Name
        SWEP.Spawnable = true
        SWEP.AdminSpawnable = true

        SWEP.Model = POTION.Model
        SWEP.Color = POTION.Color
        SWEP.CustomCheck = POTION.CustomCheck
        SWEP.OnDrink = POTION.OnDrink

        weapons.Register(SWEP, "potion_" .. POTION.Key)

        --[[
            Register an entity
        ]]

        local ENT = scripted_ents.Get("potion_base_l")
        ENT.PrintName = POTION.Name
        ENT.Spawnable = true

        ENT.Model = POTION.Model
        ENT.Scale = POTION.Scale
        ENT.Color = POTION.Color
        ENT.WeaponGiven = "potion_" .. POTION.Key

        scripted_ents.Register(ENT, "potion_" .. POTION.Key .. "_l")
    end
end)