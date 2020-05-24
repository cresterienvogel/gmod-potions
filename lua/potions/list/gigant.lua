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

        timer.Simple(45, function()
            if not IsValid(pl) then
                return
            end

            pl:SetModelScale(pl:GetModelScale() - 0.4)
            pl:SetNWBool("Gigant Potion", false)
        end)
    end
end