POTION.Name = "Dragon Potion"

POTION.Model = "models/sohald_spike/props/potion_5.mdl"
POTION.Scale = 3
POTION.Color = Color(127, 0, 0)

POTION.OnDrink = function(pl)
    if SERVER then
        pl:EmitSound("npc/antlion/pain1.wav")
        pl:EmitSound("ambient/voices/cough" .. math.random(1, 4) .. ".wav")
        pl:Ignite(7, 250)
    end
end