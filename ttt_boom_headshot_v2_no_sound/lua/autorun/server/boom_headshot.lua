if SERVER then
	AddCSLuaFile( 'effects/headshot.lua' )
	AddCSLuaFile( 'effects/bloodstream.lua' )
	AddCSLuaFile( 'autorun/client/boom_headshot.lua' )
end

local function NoTTTGib( Ply )

	local Head = Ply:LookupBone('valvebiped.bip01_head1')
	if !Head then return end
	local Pos = Ply:GetBonePosition( Head )

	Ply:ManipulateBoneScale(Head, vector_origin)
	
	local ED = EffectData()
		ED:SetEntity( Ply )
		ED:SetNormal( -Ply:GetForward() )
		ED:SetScale( Ply:EntIndex() )
		ED:SetOrigin( Pos )
	util.Effect( 'headshot', ED )
	
end

local function gibPlayerHead( Ply, Normal )

	local Head = Ply:LookupBone('valvebiped.bip01_head1')
	if !Head then return end
	local Pos = Ply:GetBonePosition( Head )

	local RagHead = Ply.server_ragdoll:LookupBone('valvebiped.bip01_head1')
	if !RagHead then return end
	Ply.server_ragdoll:ManipulateBoneScale(RagHead, Vector(0,0,0) )
	
	local ED = EffectData()
		ED:SetEntity( Ply )
		ED:SetNormal( Normal )
		ED:SetScale( Ply.server_ragdoll:EntIndex() )
		ED:SetOrigin( Pos )
	util.Effect( 'headshot', ED )
end

-- Player Headshots
local function PlayerDeath( Ply, Inflictor, Attacker )
    if !IsValid( Ply.server_ragdoll ) then return end
	if !Ply.was_headshot then return end
	if !IsValid(Attacker) || !Attacker:IsPlayer() then return end
	if !IsValid(Attacker:GetActiveWeapon()) then return end
	if Ply.IsGhost and Ply:IsGhost() then return end
	
	if Ply.OwnedBlackMarketItems then
		if Ply.OwnedBlackMarketItems[CAT_EQUIPMENT] == "fiber_helmet" then return end
	end
	
	local Normal = Attacker:GetForward()
	gibPlayerHead(Ply, Normal)
end
hook.Add('PlayerDeath', 'HeadshotDecap.PlayerDeath', PlayerDeath)

hook.Add( "ScalePlayerDamage", "HeadshotDecap.SetDeathGroup", function( ply, hit_group, dmg_info )
	ply.DeathGroup = hit_group;
end )

hook.Add( "PlayerSpawn", "HeadshotDecap.ResetDeathGroup", function( ply )
	ply.DeathGroup = nil
end )

hook.Add( "DoPlayerDeath", "HeadshotDecap.GetHeadShot", function( ply, attacker, dmg_info )
	ply.DeathGroup = nil
end )