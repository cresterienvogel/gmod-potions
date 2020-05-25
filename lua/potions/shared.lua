POTIONS = POTIONS or {}

POTIONS.Author = "crester"
POTIONS.Build = "05/25/20"

hook.Add("PlayerSwitchWeapon", "Potions", function(pl, old, new)
    if not IsValid(old) or not string.find(old:GetClass(), "potion") then
        return
    end

    if old:GetUsing() then
        return true
    end
end)
