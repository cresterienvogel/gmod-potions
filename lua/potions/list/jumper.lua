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

        timer.Create("Jumper Potion #" .. pl:UniqueID(), 60, 1, function()
            if not IsValid(pl) or not pl:GetNWBool("Jumper Potion") then
                return
            end

            pl:SetJumpPower(pl:GetJumpPower() - 200)
            pl:SetNWBool("Jumper Potion", false)
        end)
    end
end

if SERVER then
    hook.Add("PlayerDeath", "Jumper Potion", function(pl)
        if pl:GetNWBool("Jumper Potion") then
            pl:SetJumpPower(pl:GetJumpPower() - 200)
            pl:SetNWBool("Jumper Potion", false)
            if timer.Exists("Jumper Potion #" .. pl:UniqueID()) then
                timer.Remove("Jumper Potion #" .. pl:UniqueID())
            end
        end
    end)
end
