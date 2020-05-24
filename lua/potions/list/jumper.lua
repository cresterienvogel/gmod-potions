POTION.Name = "Jumper Potion"

POTION.Model = "models/sohald_spike/props/potion_5.mdl"
POTION.Scale = 3
POTION.Color = Color(0, 255, 157)

POTION.CustomCheck = function(pl)
    return not pl:GetNWBool("Jumper Potion")
end

POTION.OnDrink = function(pl)
    if SERVER then
        pl:SetJumpPower(pl:GetJumpPower() + 200)
        pl:SetNWBool("Jumper Potion", true)

        timer.Simple(60, function()
            if not IsValid(pl) then
                return
            end

            pl:SetJumpPower(pl:GetJumpPower() - 200)
            pl:SetNWBool("Jumper Potion", false)
        end)
    end
end