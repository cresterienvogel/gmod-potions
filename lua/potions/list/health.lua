POTION.Name = "Health Potion"

POTION.Model = "models/sohald_spike/props/potion_4.mdl"
POTION.Scale = 3
POTION.Color = Color(255, 0, 0)

POTION.CustomCheck = function(pl)
    return pl:Health() < pl:GetMaxHealth()
end

POTION.OnDrink = function(pl)
    if SERVER then
        pl:SetHealth(pl:GetMaxHealth())
    end
end