--MKA0207 SCRIPT LICENSE

--VERSION 1.1 , 25 DECEMBER 2014

--Copyright © 2014 Scott Grissinger

--Anyone is allowed to copy, upload, or distribute copies of this license, but changing it is not allowed.

--The precise terms and conditions for copying, distribution and modification follow.

--TERMS AND CONDITIONS

--0. Definitions

--"License" refers to this file. The version at <https://www.dropbox.com/s/3zaim0sc78l8qs9/license.txt?dl=0> is always correct and up-to-date.

--"Author" refers to the person Scott "Mka0207" Grissinger <g4.tyler@yahoo.com> 

--"Content" refers to all files and folders that the license came with as well as the intellectual property and all derivitive works.

--"Copyright" refers to the laws on intellectual property and the legal rights automatically granted to the Author during the creation of the Content.

--"Modify" refers to editing the Content as well as creating programs or code which depends on the Content to run. For the purpose of this license, deleting things without deleting the entire Content is ALSO considered editing.

--1. For any conditions not outlined in the License, refer to your country or state laws for Copyright.

--2. You may NOT freely copy, distribute, create derivitive works and distribute derivitive works of the Content.
--[do NOT make edits.]

--3. You will not Modify the Content in such a way that it will, directly or indirectly, generate revenue without explicit, written permission from the Author.
--[For example: Sell my work to some poor sap who doesn't know any better.]

--4. You will not deny access to the Author to anything in such a way that it would not allow the Author to see if the Addon/Script was Modified.
--[For example: ban me from your server.]

--5. You will not host, distribute, Modify, or otherwise copy the Content if you are affiliated with Clock Town Gaming <clocktowngaming.net>, Fearsome Gaming <steamcommunity.com/groups/FearSomeGamingServers>, and Chaos Servers <steamcommunity.com/groups/chaosfac>.

--6. If you do not agree to any of the above conditions you must delete the Content in its entirety as well as all copies of the Content and derivitive works of the Content that you have made.

--END TERMS AND CONDITIONS

if SERVER then

AddCSLuaFile( 'effects/headshot.lua' )
AddCSLuaFile( 'effects/bloodstream.lua' )
--AddCSLuaFile( 'autorun/client/boom_headshot_sound.lua' )

--CreateClientConVar("disable_headshot_sound", "0", true, true)

end

resource.AddFile('materials/fwkzt/sprite_bloodspray1.vmt')
resource.AddFile('materials/fwkzt/sprite_bloodspray2.vmt')
resource.AddFile('materials/fwkzt/sprite_bloodspray3.vmt')
resource.AddFile('materials/fwkzt/sprite_bloodspray4.vmt')
resource.AddFile('materials/fwkzt/sprite_bloodspray5.vmt')
resource.AddFile('materials/fwkzt/sprite_bloodspray6.vmt')
resource.AddFile('materials/fwkzt/sprite_bloodspray7.vmt')
resource.AddFile('materials/fwkzt/sprite_bloodspray8.vmt')
resource.AddFile( 'sound/fwkzt/boom_headshot/headshot.wav' )

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
	
	local Normal = Attacker:GetForward()
	gibPlayerHead(Ply, Normal)
	
end
hook.Add('PlayerDeath', 'HeadshotDecap.PlayerDeath', PlayerDeath)

-- NPC Headshots
--[[local function NPCDeath( npc, attacker, inflictor )

    if !IsValid( npc.server_ragdoll ) then return end

	if !npc.was_headshot then return end
	
	if !IsValid(attacker) || !attacker:IsPlayer() then return end
	if !IsValid(attacker:GetActiveWeapon()) then return end
	
	local Normal = attacker:GetForward()
	gibPlayerHead(npc, Normal)
	
end
hook.Add('OnNPCKilled', 'HeadshotDecap.NPCDeath', NPCDeath)]]

hook.Add( "ScalePlayerDamage", "SetDeathGroup", function( ply, hit_group, dmg_info )
	ply.DeathGroup = hit_group;
end )

--[[hook.Add( "ScaleNPCDamage", "SetNPCDeathGroup", function( npc, hit_group, dmg_info )
	npc.DeathGroup = hit_group;
end )]]

hook.Add( "PlayerSpawn", "ResetDeathGroup", function( ply )
	ply.DeathGroup = nil
end )

hook.Add( "DoPlayerDeath", "GetHeadShot", function( ply, attacker, dmg_info )
	if ply.DeathGroup and ply.DeathGroup == HITGROUP_HEAD then

	end;
	
	ply.DeathGroup = nil
end )