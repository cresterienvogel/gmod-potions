POTION.Name = "Runner Potion"

POTION.Model = "models/sohald_spike/props/potion_2.mdl"
POTION.Scale = 3
POTION.Color = Color(191, 127, 255)

POTION.CustomCheck = function(pl)
    return not pl:GetNWBool("Runner Potion")
end

POTION.OnDrink = function(pl)
    if SERVER then
        pl:EmitSound("vo/npc/Barney/ba_yell.wav")
        pl:SetRunSpeed(pl:GetRunSpeed() + 40)
        pl:SetNWBool("Runner Potion", true)

        timer.Simple(40, function()
            if not IsValid(pl) then
                return
            end

            pl:SetRunSpeed(pl:GetRunSpeed() - 40)
            pl:SetNWBool("Runner Potion", false)
        end)
    end
end