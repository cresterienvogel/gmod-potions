AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Potion Base"
ENT.Category = "Potions"
ENT.Author = "crester"
ENT.Spawnable = false

if CLIENT then
	function ENT:Initialize()
		self.csModel = ClientsideModel(self.Model)
		self.csModel:SetModelScale(self.Scale, 0)
		self.csModel:SetColor(self.Color)
	end

	function ENT:Draw()
		self.csModel:SetPos(self:GetPos() + Vector(0, 0, (math.sin(CurTime() * 3) * 5) - 1))
		self.csModel:SetAngles(Angle(0, (CurTime() * 90) % 360, 0))
	end

	function ENT:OnRemove()
		self.csModel:Remove()
	end
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/hunter/blocks/cube05x05x05.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetPos(self:GetPos() + Vector(0, 0, 40))
	end
	
	function ENT:Use(activator)
		if activator:HasWeapon(self.WeaponGiven) then
			return
		end
	
		activator:Give(self.WeaponGiven)
		self:Remove()
	end
end