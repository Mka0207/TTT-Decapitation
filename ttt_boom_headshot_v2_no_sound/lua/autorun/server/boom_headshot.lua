if SERVER then
	AddCSLuaFile( 'effects/headshot.lua' )
	AddCSLuaFile( 'effects/bloodstream.lua' )
	AddCSLuaFile( 'autorun/client/boom_headshot.lua' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray1.vmt' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray2.vmt' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray3.vmt' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray4.vmt' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray5.vmt' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray6.vmt' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray7.vmt' )
	resource.AddFile( 'materials/fwkzt/sprite_bloodspray8.vmt' )
end

local function getBoneDescendants(ent, bone, tbl)
	tbl = tbl or {}
	table.insert(tbl, bone)
	for _, v in pairs(ent:GetChildBones(bone)) do
		getBoneDescendants(ent, v, tbl)
	end
	return tbl
end

local function NoTTTGib( Ply )

	local Head = Ply:LookupBone('valvebiped.bip01_head1')
	if !Head then return end
	local Pos = Ply:GetBonePosition( Head )

	for _, v in pairs(getBoneDescendants(Ply, Head)) do
		Ply:ManipulateBoneScale(v, Vector(0,0,0) )
	end
	
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

	for _, v in pairs(getBoneDescendants(Ply.server_ragdoll, RagHead)) do
		Ply.server_ragdoll:ManipulateBoneScale(v, Vector(0,0,0) )
	end
	
	local ED = EffectData()
		ED:SetEntity( Ply )
		ED:SetNormal( Normal )
		ED:SetScale( Ply.server_ragdoll:EntIndex() )
		ED:SetOrigin( Pos )
	util.Effect( 'headshot', ED )
end

-- Player Headshots
local function PlayerDeath( Ply, Inflictor, Attacker )
	if GAMEMODE_NAME ~= "terrortown" then return end
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

hook.Remove("DoPlayerDeath", "FWKZT.SandboxHeadshot.DoPlayerDeath")
hook.Add("DoPlayerDeath", "FWKZT.SandboxHeadshot.DoPlayerDeath", function(pl,attacker,dmg)
	if GAMEMODE_NAME ~= "sandbox" then return end
	pl:SetDTBool(DT_PLAYER_HEADSHOT_BOOL, pl:LastHitGroup() == HITGROUP_HEAD)
end)

hook.Remove("ScaleNPCDamage", "FWKZT.SandboxHeadshot.ScaleNPCDamage")
hook.Add( "ScaleNPCDamage", "FWKZT.SandboxHeadshot.ScaleNPCDamage", function( npc, hitgroup, dmginfo )
	if GAMEMODE_NAME ~= "sandbox" then return end
	npc.LastHitGroup = hitgroup
	npc:SetDTBool(DT_NPC_HEADSHOT_BOOL, hitgroup == HITGROUP_HEAD)
end )

hook.Remove("OnNPCKilled", "FWKZT.SandboxHeadshot.OnNPCKilled")
hook.Add("OnNPCKilled", "FWKZT.SandboxHeadshot.OnNPCKilled", function(npc, attacker, inf)
	if GAMEMODE_NAME ~= "sandbox" then return end
	npc:SetDTBool(DT_NPC_HEADSHOT_BOOL, npc.LastHitGroup == HITGROUP_HEAD)
end)