local WIProject = RegisterMod( "WIProject", 1);
local lifeline_item = Isaac.GetItemIdByName("Lifeline")
local addicted_item = Isaac.GetItemIdByName("Addicted")
local satan_item = Isaac.GetItemIdByName("Satan's Contract")
local stoned_item = Isaac.GetItemIdByName("Stoned Buddy")

--Set Up Variables
local stoned_exist = false
local enemy_chasing = nil

function WIProject:use_lifeline()
	local player = Isaac.GetPlayer(0)
	local healthroll = math.random(1,10)
	if healthroll < 3 then
		player:AddMaxHearts(-2,true)
	elseif healthroll > 2 then
		player:SetFullHearts()
	end
end

function WIProject:take_damage(playerx,damageamount,damageflag,damagesource,invinceframes)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(addicted_item) then
		local chosenpill = math.random(2,PillEffect.NUM_PILL_EFFECTS-1)
		local pillchance = math.random(100)
		if pillchance < 34 then
			player:UsePill(chosenpill,PillColor.PILL_BLUE_BLUE)
		end
	end
	if player:HasCollectible(satan_item) then
		local counter = damageamount
		for i=1,counter do
			if player:GetSoulHearts() > 0 then
				player:AddSoulHearts(-1)
			else
				player:AddHearts(-1)
			end
		end
	end
end

function WIProject:update_cache(player,cacheFlag)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(satan_item) then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage * 2
		elseif cacheFlag == CacheFlag.CACHE_FLYING then
			player.CanFly = true
		end
	end
end

function WIProject:mod_update()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(stoned_item) and stoned_exist == false then
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, 234, 0 ,player.Position,Vector(0,0), nil)
		stoned_exist = true
	end
end

function WIProject:update_familiar(familiar)
	local player = Isaac.GetPlayer(0)
	local entities = Isaac.GetRoomEntities()
	local chasing = false
	if enemy_chasing ~= nil and enemy_chasing:Exists() == false then
		enemy_chasing = nil
	end
	for i = 1, #entities do
		local enemy_check = entities[i]
		if enemy_check:IsVulnerableEnemy() then
			chasing = true
			familiar.State = NpcState.STATE_MOVE
			if enemy_chasing == nil then
				enemy_chasing = enemy_check
			elseif player.Position:Distance(enemy_check.Position) < player.Position:Distance(enemy_chasing.Position) then
				enemy_chasing = enemy_check
			end
		end
	end
	if chasing == false then
		enemy_chasing = nil
		familiar.State = NpcState.STATE_IDLE
	end
	if familiar.State == NpcState.STATE_IDLE then
		familiar.FollowPosition(familiar,player.Position)
	elseif familiar.State == NpcState.STATE_MOVE then
		familiar.FollowPosition(familiar,enemy_chasing.Position)
	end
	local fvelocity = familiar.Velocity
	local sprite = familiar:GetSprite()
	sprite.Offset = Vector(-16,-16)
	if math.abs(fvelocity.X) > math.abs(fvelocity.Y) then
		if fvelocity.X < 0 and not sprite:IsPlaying("WalkLeft") then
			sprite:Play("WalkLeft",false)
		elseif fvelocity.X >= 0 and not sprite:IsPlaying("WalkRight") then
			sprite:Play("WalkRight",false)
		end
	else
		if fvelocity.Y < 0 and not sprite:IsPlaying("WalkUp") then
			sprite:Play("WalkUp",false)
		elseif fvelocity.Y >= 0 and not sprite:IsPlaying("WalkDown") then
			sprite:Play("WalkDown",false)
		end
	end
end

function familiar_init(familiar)
	familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	familiar.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
end

WIProject:AddCallback(ModCallbacks.MC_USE_ITEM, WIProject.use_lifeline, lifeline_item);
WIProject:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, WIProject.take_damage, EntityType.ENTITY_PLAYER);
WIProject:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, WIProject.update_cache);
WIProject:AddCallback(ModCallbacks.MC_POST_UPDATE, WIProject.mod_update)
WIProject:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, WIProject.update_familiar,234)
WIProject:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, WIProject.familiar_init,234)