-- These can be accessed without pointing to the IMaterial by using ! before the material string.
local function CreateSpriteMaterials()
	local params = {["$translucent"] = "1", ["$vertexcolor"] = "1", ["$vertexalpha"] = "1"}
	for i=1, 8 do
		params["$basetexture"] = "Decals/blood"..i
		CreateMaterial("sprite_bloodspray"..i, "UnlitGeneric", params)
	end
end

local function FixSubMaterialClientRagdoll(entity, ragdoll)
	ragdoll:RemoveAllDecals()
	for k, v in ipairs(entity:GetMaterials()) do
		ragdoll:SetSubMaterial( k-1, entity:GetSubMaterial( k-1 ) )	
	end
end

hook.Add("Initialize","CreateBlood.TTT", function()
	CreateSpriteMaterials()
	if engine.ActiveGamemode() == "sandbox" then
		hook.Add( "CreateClientsideRagdoll", "Fix.SubMaterials.Sandbox", FixSubMaterialClientRagdoll )
	end
end)