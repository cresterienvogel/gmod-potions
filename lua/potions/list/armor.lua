POTION.Name = "Armor Potion"

POTION.Model = "models/sohald_spike/props/potion_3.mdl"
POTION.Scale = 3
POTION.Color = Color(0, 0, 200)

POTION.CustomCheck = function(pl)
    return pl:Armor() < 100
end

POTION.OnDrink = function(pl)
    if SERVER then
        pl:SetArmor(100)
    end
end