return function (self,_dd,appearType,delay) 
-- 네트워크로 전송받은 테이블 캐스팅
---@type Drop
local drop = _dd;

--local entity = self._objectPool.ChildObjectPoolComponent:Get(drop.Position)
--entity.DropComponent.ObjectPool = self._objectPool
--local entity = _SpawnService:SpawnByModelId("model://b9b74107-fdd9-4548-9bf1-09ce4b8affbf", "Drop-"..drop.ItemId, drop.Position, self._objectPool)

-- 퀘스트템은 안보여요 3_3
if (drop.Quest > 0) then
	if (not _UserQuestLogic:CanPickUpQuestItem(_UserService.LocalPlayer.WsCharacterData, drop.ItemId, drop.Quest)) then
		return
	end
end


if Unknown.Use_Not_diffrent_User_Item then
	if (_LocalPartyLogic.LocalParty == nil) then
		if(drop.OwnerId ~= _UserService.LocalPlayer.WsUser.CharacterId)then 
			return
		end
	elseif (_LocalPartyLogic.LocalParty ~= nil) then
		if(drop.OwnerId ~= tostring(_UserService.LocalPlayer.WsUser.PartyId))then 
			return
		end
	end
end

if Unknown.Use_Filter_Arrow then -- 화살
	if (drop.ItemId // 1000) == 2060 or (drop.ItemId // 1000) == 2061 then
		return
	end
end
if Unknown.Use_Filter_Etc then -- 기타
	if (drop.ItemId // 1000000) == 4 then
		return
	end
end

if Unknown.Use_Filter_Equip then -- 장비
	if (drop.ItemId // 1000000) == 1 then
		return
	end
end
if(drop.ItemId == 1002103 or drop.ItemId == 1060002) then
	return
end

local function showDrop()
	-- -@type Entity
	local entity
	local returnPool
	if (drop.ItemId == 0) then
		returnPool = self._mesoObjectPool
		entity = _ObjectPool:Pick(returnPool, "PooledMeso", "model://35623b2c-7d42-4a33-83dc-faa1350af08a", Vector3(0,0,10000), self._dropsGroup)
	else
		returnPool = self._dropObjectPool
		entity = _ObjectPool:Pick(returnPool, "PooledDrop", "model://b9b74107-fdd9-4548-9bf1-09ce4b8affbf", Vector3(0,0,10000), self._dropsGroup)
	end
	
	entity.DropComponent:EnterField(appearType, drop, returnPool)
	self._clientDropMap[drop.ObjectId] = entity
	
	if(Unknown.Use_TemBak)then
		Unknown.MovePosition(entity.DropComponent.Position:ToVector2())
		_UserService.LocalPlayer.WsUserController:TryPick(entity.DropComponent)
	end
	--log("first pos:", entity.TransformComponent.WorldPosition)
	--log("opos:", entity.DropComponent.OriginalPosition, "pos:",entity.DropComponent.Position)
end

if (delay > 0) then
	_TimerService:SetTimerOnce(showDrop, delay)
else
	showDrop()
end
end