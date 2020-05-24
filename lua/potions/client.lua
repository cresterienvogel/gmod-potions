-- ## Fubaru ThirdPerson at https://steamcommunity.com/sharedfiles/filedetails/?id=1914051995

local Loaded = false
timer.Simple(2.5, function()
    Loaded = true
end)

--[[
	Functions detour
]]

local abs = math.abs -- gotta go fast
local sqrt = math.sqrt -- gotta go fast
local ply = LocalPlayer() -- gotta go fast x2 and less symbols
local TraceHull = util.TraceHull -- gotta go fast x3
local QuickTrace = util.QuickTrace -- gotta go fast x4

--[[
	Main variables
]]

local CollideTrace = {}
local CrashTrace1 = {}
local CrashTrace2 = {}
local CrashTrace3 = {}
local view = {origin = Vector()}

local CAM_ang = Angle(0, 130, 0)
local CAM_origin = Vector()

local CAM_originSideMultiplier = 0
local CAM_originFWDMultiplier = 80
local CAM_originFWDMotion = 1
local CAM_originUPMultiplier = 10
local CAM_originOffset = Vector()

local PLAYER_IScrashed
local PLAYER_speedZMul
local PLAYER_speed
local PLAYER_speedXYMul
local PLAYER_IScrashed = true
local PLAYER_crashTime = 0
local PLAYER_crashSpeed = 0

--[[
	Hooks
]]

hook.Add("CalcView", "MyCalcView", function(ply, pos, angles, fov)
	if not Loaded or not IsValid(ply:GetActiveWeapon()) or not string.find(ply:GetActiveWeapon():GetClass(), "potion") then
		return
	end

	view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = true

	return view
end)

hook.Add("RenderScreenspaceEffects", "Fubaru ThirdPerson", function()
	if not Loaded or not IsValid(ply:GetActiveWeapon()) or not string.find(ply:GetActiveWeapon():GetClass(), "potion") or not ply:Alive() then
		return
	end

	CAM_originOffset = (CAM_ang:Forward() * (CAM_originFWDMultiplier + CAM_originFWDMotion)) - CAM_ang:Right() * (CAM_originSideMultiplier + 30) - CAM_ang:Up() * CAM_originUPMultiplier

	CollideTrace = TraceHull({
		start = view.origin,
		endpos = view.origin - CAM_originOffset,
		filter = {ply:GetActiveWeapon(), ply},
		mins = Vector(-9, -9, -9),
		maxs = Vector(9, 9, 9),
	})

	PLAYER_velocity = ply:GetVelocity()
	PLAYER_speed = sqrt(PLAYER_velocity.x * PLAYER_velocity.x + PLAYER_velocity.y * PLAYER_velocity.y + PLAYER_velocity.z * PLAYER_velocity.z)

	if ply:GetMoveType() ~= MOVETYPE_NOCLIP then
		if not ply:IsOnGround() then
			PLAYER_speedZMul = TimedSin(1.5, 0, PLAYER_speed * 0.001, 0)
			CAM_ang.p = CAM_ang.p + PLAYER_speedZMul
			CAM_ang.y = CAM_ang.y + PLAYER_speedZMul
			CAM_ang.r = CAM_ang.r + PLAYER_speedZMul
		end

		CrashTrace1 = QuickTrace(ply:GetPos() + Vector(0, 0, 33), ply:EyeAngles():Right() * 19, ply)
		CrashTrace2 = QuickTrace(ply:GetPos() + Vector(0, 0, 33), -ply:EyeAngles():Right() * 19, ply)
		CrashTrace3 = QuickTrace(ply:GetPos() + Vector(0, 0, 33), Angle(0, ply:EyeAngles().yaw, 0):Forward() * 25, ply)

		if CurTime() > PLAYER_crashTime then
			if (!PLAYER_IScrashed) and (CrashTrace1.Hit or CrashTrace2.Hit or CrashTrace3.Hit) and PLAYER_speed > 300 then
				PLAYER_IScrashed = true
				PLAYER_crashSpeed = PLAYER_speed
				PLAYER_crashTime = CurTime() + 0.6
			elseif not (CrashTrace1.Hit or CrashTrace2.Hit or CrashTrace3.Hit) then
				PLAYER_IScrashed = false
			end
		end

		if PLAYER_IScrashed and CurTime() < PLAYER_crashTime then
			PLAYER_speedXYMul = TimedSin(3, 0, PLAYER_crashSpeed * 0.0025, 0)
			CAM_ang.p = CAM_ang.p + PLAYER_speedXYMul
			CAM_ang.y = CAM_ang.y + PLAYER_speedXYMul
			CAM_ang.r = CAM_ang.r + PLAYER_speedXYMul
		end

		CAM_origin = CollideTrace.HitPos
	else
		CAM_origin = view.origin - CAM_originOffset
	end

	render.RenderView({
		origin = CAM_origin,
		angles = CAM_ang,
		x = 0,
		y = 0,
		w = ScrW(),
		h = ScrH()
	})
end)

hook.Add("InputMouseApply", "Fubaru ThirdPerson", function(cmd, x, y, ang)
	if not Loaded or not IsValid(ply:GetActiveWeapon()) or not string.find(ply:GetActiveWeapon():GetClass(), "potion") then
		return
	end

	if ply:KeyDown(IN_FORWARD) then
		CAM_originFWDMotion = Lerp(FrameTime() * 2, CAM_originFWDMotion, 35)
	else
		CAM_originFWDMotion = Lerp(FrameTime() * 2, CAM_originFWDMotion, 1)
	end

	if ply:KeyDown(IN_MOVERIGHT) then
		CAM_originSideMultiplier = Lerp(FrameTime() * 2, CAM_originSideMultiplier, 70)
	else
		CAM_originSideMultiplier = Lerp(FrameTime() * 2, CAM_originSideMultiplier, 0)
	end

	if ply:KeyDown(IN_MOVELEFT) then
		CAM_originSideMultiplier = Lerp(FrameTime() * 2, CAM_originSideMultiplier, -80)
	else
		CAM_originSideMultiplier = Lerp(FrameTime() * 2, CAM_originSideMultiplier, 0)
	end

	CAM_ang = LerpAngle(FrameTime() * 10, CAM_ang, ang)
end)

hook.Add("HUDShouldDraw", "Fubaru ThirdPerson", function(name)
	ply = LocalPlayer()
	
	if not Loaded or not IsValid(ply:GetActiveWeapon()) or not string.find(ply:GetActiveWeapon():GetClass(), "potion") then
		return
	end

	if name == "CHudCrosshair" then
		return false
	end
end)