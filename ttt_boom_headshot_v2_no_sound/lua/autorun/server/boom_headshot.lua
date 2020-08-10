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

include('gore/gore_sys.lua')

--[[local function NoTTTGib( Ply )

	local Head = Ply:LookupBone('valvebiped.bip01_head1')
	if !Head then return end
	local Pos = Ply:GetBonePosition( Head )

	--Ply:ManipulateBoneScale(Head, vector_origin)
	
	local ED = EffectData()
		ED:SetEntity( Ply )
		ED:SetNormal( -Ply:GetForward() )
		ED:SetScale( Ply:EntIndex() )
		ED:SetOrigin( Pos )
	util.Effect( 'headshot', ED )
	
end]]

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
   	-- if !IsValid( Ply.server_ragdoll ) then return end
	--if !Ply.was_headshot then return end
	if !IsValid(Attacker) || !Attacker:IsPlayer() then return end
	if !IsValid(Attacker:GetActiveWeapon()) then return end
	if Ply.IsGhost and Ply:IsGhost() then return end
	
	if Ply.OwnedBlackMarketItems then
		if Ply.OwnedBlackMarketItems[CAT_EQUIPMENT] == "fiber_helmet" then return end
	end

	if Ply:GetModel() == "models/player/t_arctic_fwkzt_test.mdl" then
		if Ply:LastHitGroup() == HITGROUP_HEAD then
			RandomGibContainer[DMG_HEAD].CallBack(Ply)
		end
	else
		local Normal = Attacker:GetForward()
		gibPlayerHead(Ply, Normal)
	end
end
hook.Add('PlayerDeath', 'HeadshotDecap.PlayerDeath', PlayerDeath)

hook.Add("PlayerSpawn", "Headshot.Reset.Stuff", function(pl)
	for i=1, #pl:GetMaterials() do
		pl:SetSubMaterial(i-1,"")
	end
	for i=1, #pl:GetBodyGroups() do
		pl:SetBodygroup(i-1,0)
	end
end)

hook.Add( "OnDamagedByExplosion", "Gib.Test", function(ply, dmginfo)
	if ply:Health() <= 0 then
		local rndm = math.random(1,5)
		print(rndm)
		RandomGibContainer[rndm].CallBack(ply)
	end
end )