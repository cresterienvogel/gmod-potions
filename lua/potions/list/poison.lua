POTION.Name = "Poison"

POTION.Model = "models/sohald_spike/props/potion_5.mdl"
POTION.Scale = 3
POTION.Color = Color(0, 127, 31)

POTION.OnDrink = function(pl)
    if SERVER then
        pl:EmitSound("ambient/voices/cough" .. math.random(1, 4) .. ".wav")
        pl:Kill()
    end
end