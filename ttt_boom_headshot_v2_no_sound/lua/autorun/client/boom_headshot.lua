-- These can be accessed without pointing to the IMaterial by using ! before the material string.
function CreateSpriteMaterials()
	local params = {["$translucent"] = "1", ["$vertexcolor"] = "1", ["$vertexalpha"] = "1"}
	for i=1, 8 do
		params["$basetexture"] = "Decals/blood"..i
		CreateMaterial("sprite_bloodspray"..i, "UnlitGeneric", params)
	end
end

hook.Add("Initialize","CreateBlood.TTT", function()
	CreateSpriteMaterials()
end)

local function getBoneDescendants(ent, bone, tbl)
	tbl = tbl or {}
	table.insert(tbl, bone)
	for _, v in pairs(ent:GetChildBones(bone)) do
		getBoneDescendants(ent, v, tbl)
	end
	return tbl
end

hook.Remove( "CreateClientsideRagdoll", "FWKZT.Headshot.CreateCRagdolls" )
hook.Add( "CreateClientsideRagdoll", "FWKZT.Headshot.CreateCRagdolls", function( entity, ragdoll )
	if GAMEMODE_NAME ~= "sandbox" then return end
	
	if entity.WasHeadshotDeath and entity:WasHeadshotDeath() then
		local Head = ragdoll:LookupBone('valvebiped.bip01_head1')
		if !Head then return end
		local Pos = ragdoll:GetBonePosition( Head )

		local RagHead = ragdoll:LookupBone('valvebiped.bip01_head1')
		if !RagHead then return end
		for _, v in pairs(getBoneDescendants(ragdoll, RagHead)) do
			ragdoll:ManipulateBoneScale(v, Vector(0,0,0) )
		end

		local ED = EffectData()
			ED:SetEntity( entity )
			ED:SetNormal( -entity:GetForward() )
			ED:SetScale( entity:EntIndex() )
			ED:SetOrigin( Pos )
		util.Effect( 'headshot', ED )
	end
end )