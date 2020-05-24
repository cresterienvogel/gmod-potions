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
        pl:SetRunSpeed(pl:GetRunSpeed() + 100)
        pl:SetNWBool("Runner Potion", true)

        timer.Create("Runner Potion #" .. pl:UniqueID(), 40, 1, function()
            if not IsValid(pl) or not pl:GetNWBool("Runner Potion") then
                return
            end

            pl:SetRunSpeed(pl:GetRunSpeed() - 100)
            pl:SetNWBool("Runner Potion", false)
        end)
    end
end

if SERVER then
    hook.Add("PlayerDeath", "Runner Potion", function(pl)
        if pl:GetNWBool("Runner Potion") then
            pl:SetRunSpeed(pl:GetRunSpeed() - 100)
            pl:SetNWBool("Runner Potion", false)
            if timer.Exists("Runner Potion #" .. pl:UniqueID()) then
                timer.Remove("Runner Potion #" .. pl:UniqueID())
            end
        end
    end)
end
