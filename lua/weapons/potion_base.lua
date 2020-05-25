AddCSLuaFile()

SWEP.PrintName = "Base Potion"
SWEP.Slot = 1
SWEP.SlotPos = 9
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Category = "Potions"

SWEP.Author	= "crester"
SWEP.Contact = "https://steamcommunity.com/profiles/76561198159772522/"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModelFOV = 64
SWEP.ViewModelFlip = false
SWEP.ViewModel	= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel	= "models/hunter/blocks/cube025x025x025.mdl"

SWEP.Spawnable	= false
SWEP.AdminSpawnable	= false

SWEP.Primary.ClipSize = -1	
SWEP.Primary.DefaultClip = -1	
SWEP.Primary.Automatic = false	
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.OffsetVec = Vector(5, -1, -5)
SWEP.OffsetAng = Angle(0, 0, 0)

SWEP.DeployTime = 1.75

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Using")
end

function SWEP:Initialize()
	self:SetUsing(false)
	self:SetHoldType("normal")
end

function SWEP:CustomCheck(pl)
	return pl:IsPlayer()
end

function SWEP:OnDrink(pl)
	print(pl:Name() .. " just used a potion\n")
end

function SWEP:PrimaryAttack()
	local Owner = self.Owner
	if not self.CustomCheck(Owner) then
		Owner:EmitSound("vo/npc/male01/stopitfm.wav", 75, 100, 0.5, CHAN_AUTO)
		self:SetNextPrimaryFire(CurTime() + 3)
		self:SetNextSecondaryFire(CurTime() + 3)
		return
	end

	self:SetNextPrimaryFire(CurTime() + self.DeployTime + 0.5)
	self:SetNextSecondaryFire(CurTime() + self.DeployTime + 0.5)
	self:SetUsing(true)

	Owner:DoAnimationEvent(ACT_GMOD_TAUNT_SALUTE)

	timer.Simple(self.DeployTime, function()
		if not IsValid(Owner) or not Owner:Alive() then
			return
		end

		if SERVER then
			Owner:EmitSound("npc/barnacle/barnacle_gulp" .. math.random(1, 2) .. ".wav")
			Owner:EmitSound("npc/vort/attack_shoot.wav", 75, 100, 0.1)
		end

		self.OnDrink(Owner)

		self:SetUsing(false)
		if SERVER then
			self:Remove()
			Owner:SwitchToDefaultWeapon()
		end
	end)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
	return
end

function SWEP:Deploy()
	self:SetUsing(false)
	self.Owner:DrawViewModel(false)
end

function SWEP:Holster()
	return true
end

if CLIENT then
	local PotionModel = ClientsideModel(SWEP.WorldModel)
	PotionModel:SetColor(color_white)
	PotionModel:SetNoDraw(true)

	function SWEP:Think()
		if self.Model then
			if PotionModel:GetModel() ~= self.Model then
				PotionModel:SetModel(self.Model)
			end
		end
	end

	function SWEP:DrawWorldModel()
		if not IsValid(PotionModel) then
			return
		end

		local Owner = self.Owner
		if not IsValid(Owner) then
			SafeRemoveEntity(PotionModel)
		end

		if (IsValid(Owner)) then
			local offsetVec = self.OffsetVec
			local offsetAng = self.OffsetAng

			local boneid = Owner:LookupBone("ValveBiped.Bip01_L_Hand")
			if not boneid then 
				return 
			end

			local matrix = Owner:GetBoneMatrix(boneid)
			if not matrix then 
				return 
			end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
			PotionModel:SetPos(newPos)
			PotionModel:SetAngles(newAng)

			PotionModel:SetupBones()
		else
			PotionModel:SetPos(self:GetPos())
			PotionModel:SetAngles(self:GetAngles())
		end

		render.SetColorModulation(self.Color.r / 255, self.Color.g / 255, self.Color.b / 255)
			render.SetBlend(self.Color.a / 255)
				PotionModel:DrawModel()
			render.SetBlend(1)
		render.SetColorModulation(1, 1, 1)
	end
end
