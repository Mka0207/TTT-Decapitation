if RandomGibContainer then return end

DMG_TORSO_AND_ARMS = 1
DMG_TORSO_HEAD_ARMS = 2
DMG_TORSO_LEGS = 3
DMG_TORSO_HEAD_LEGS = 4
DMG_ALL = 5
DMG_LEGS = 6
DMG_HEAD = 7

RandomGibContainer = {
	[DMG_TORSO_AND_ARMS] = {
		CallBack = function(ply)
			--Full bloody torso
			ply:SetSubMaterial(0,"models/player/t_arctic/t_arctic_torso_12")
			--Torso skeleton
			--ply:SetBodygroup(0,1)
			--Left and Right arms
			ply:SetBodygroup(2,1)
			ply:SetBodygroup(3,1)
		end
	},
	[DMG_TORSO_HEAD_ARMS] = {
		CallBack = function(ply)
			RandomGibContainer[DMG_TORSO_AND_ARMS].CallBack(ply)
			RandomGibContainer[DMG_HEAD].CallBack(ply)
		end
	},
	[DMG_TORSO_LEGS] = {
		CallBack = function(ply)
			--Torso skeleton
			--ply:SetBodygroup(0,1)

			ply:SetSubMaterial(0,"models/player/t_arctic/t_arctic_torso_12")
			ply:SetSubMaterial(4,"models/player/t_arctic/t_arctic_legs_dmg")

			--Left and Right arms
			ply:SetBodygroup(2,1)
			ply:SetBodygroup(3,1)
			
			--legs
			ply:SetBodygroup(4,1)
		end
	},
	[DMG_TORSO_HEAD_LEGS] = {
		CallBack = function(ply)
			RandomGibContainer[DMG_HEAD].CallBack(ply)
			RandomGibContainer[DMG_TORSO_LEGS].CallBack(ply)
		end
	},
	[DMG_ALL] = {
		CallBack = function(ply)
			RandomGibContainer[DMG_HEAD].CallBack(ply)
			RandomGibContainer[DMG_TORSO_AND_ARMS].CallBack(ply)
			RandomGibContainer[DMG_LEGS].CallBack(ply)
		end
	},
	[DMG_LEGS] = {
		CallBack = function(ply)
			--cut legs
			ply:SetBodygroup(4,1)
			ply:SetSubMaterial(4,"models/player/t_arctic/t_arctic_legs_dmg")
		end
	},
	[DMG_HEAD] = {
		CallBack = function(ply)
			--blood effects
			local Head = ply:LookupBone('valvebiped.bip01_head1')
			if !Head then return end
			local Pos = ply:GetBonePosition( Head )
			local ED = EffectData()
				ED:SetEntity( ply )
				ED:SetNormal( -ply:GetForward() )
				ED:SetScale( ply:EntIndex() )
				ED:SetOrigin( Pos )
			util.Effect( 'headshot', ED )

			--Head decap
			local rndm = 4
			ply:SetBodygroup(1, rndm )
			ply:SetSubMaterial(1,"models/player/t_arctic/t_arctic_head_dmg")
			if rndm == 4 then
				ply:SetSubMaterial(0,"models/player/t_arctic/t_arctic_torso_6")
			end
		end
	}
}