POTION.Name = "Gigant Potion"

POTION.Model = "models/sohald_spike/props/potion_1.mdl"
POTION.Scale = 3
POTION.Color = Color(127, 111, 63)

POTION.CustomCheck = function(pl)
    return not pl:GetNWBool("Gigant Potion")
end

POTION.OnDrink = function(pl)
    if SERVER then
        pl:SetModelScale(pl:GetModelScale() + 0.4)
        pl:SetNWBool("Gigant Potion", true)

        timer.Create("Gigant Potion #" .. pl:UniqueID(), 45, 1, function()
            if not IsValid(pl) or not pl:GetNWBool("Gigant Potion") then
                return
            end

            pl:SetModelScale(pl:GetModelScale() - 0.4)
            pl:SetNWBool("Gigant Potion", false)
        end)
    end
end

if SERVER then
    hook.Add("PlayerDeath", "Gigant Potion", function(pl)
        if pl:GetNWBool("Gigant Potion") then
            pl:SetModelScale(pl:GetModelScale() - 0.4)
            pl:SetNWBool("Gigant Potion", false)
            if timer.Exists("Gigant Potion #" .. pl:UniqueID()) then
                timer.Remove("Gigant Potion #" .. pl:UniqueID())
            end
        end
    end)
end
