return function (self,user,skillId,skillLevel,keyDown,spiritJavelin,cli) 
if (_Skills:IsPassiveSkill(skillId)) then
	return false
end
local cd = user.WsCharacterData
if (cd:GetSkillLevel(skillId) < skillLevel) then
	return cli and "사용할 수 없는 스킬입니다." or true
end
local levelData = _SkillMan:GetSkillLevelData(skillId, skillLevel)
if (levelData == nil) then
	return cli and "사용할 수 없는 스킬입니다." or true
end
local pts = user.PlayerTemporaryStat
if (skillId == _Skills.HERO_ENRAGE and pts:GetValue(_CTS.ComboCounter) < 10) then
	return cli and "" or true
end
local incMpCon = {}
_CalcDamageLogic:GetAmplification(cd, skillId, incMpCon)
local hpCon = levelData.hpCon
local mpCon = levelData.mpCon * incMpCon[1] // 100
if (skillId == _Skills.DRAGONKNIGHT_DRAGON_ROAR) then
	if ((user.WsUser.MaxHp >> 1) > user.WsUser.Hp) then
		_ItemConsumeLogic:TryConsumeFromFuncKey(2030000)
		Unknown.Reset_All_Variable()
		return cli and "스킬을 사용하는 데 필요한 HP가 부족합니다." or true
	end
	hpCon = user.WsUser.MaxHp * levelData.x // 100
end
if (keyDown or pts:GetValue(_CTS.Infinity) > 0) then
	mpCon = 0
end
local concentration = pts:GetValue(_CTS.Concentration)
if (concentration > 0) then
	mpCon = math.ceil((100 - concentration) * mpCon / 100)
end
local moneyCon = levelData.moneyCon
if (skillId == _Skills.HERMIT_SHADOW_MESO and pts:GetValue(_CTS.ShadowPartner) > 0) then
	local nd = _SkillMan:GetSkillLevelData(_Skills.HERMIT_SHADOW_PARTNER, cd:GetSkillLevel(_Skills.HERMIT_SHADOW_PARTNER))
	if (nd ~= nil) then
		moneyCon += (moneyCon * nd.y // 100)
	end
end
local itemCon = levelData.itemCon
local itemConNo = levelData.itemConNo
if (user.WsUser:IsDied()) then
	return cli and "" or true
end
if (hpCon > 0 and hpCon >= user.WsUser.Hp) then
	_ItemConsumeLogic:TryConsumeFromFuncKey(2030000)
	Unknown.Reset_All_Variable()
	return cli and "스킬을 사용하는 데 필요한 HP가 부족합니다." or true
end
if (mpCon > 0 and mpCon > user.WsUser.Mp) then
	_ItemConsumeLogic:TryConsumeFromFuncKey(2030000)
	Unknown.Reset_All_Variable()
	return cli and "스킬을 사용하는 데 필요한 MP가 부족합니다." or true
end
if (moneyCon > 0 and moneyCon > cd.Money) then
	return cli and "스킬을 사용하는 데 필요한 메소가 부족합니다." or true
end
if (itemCon > 0 and itemConNo > 0 and itemConNo > _InventoryLogic:GetItemCount(cd, itemCon)) then
	_ItemConsumeLogic:TryConsumeFromFuncKey(2030000)
	Unknown.Reset_All_Variable()
	return cli and string.format("스킬을 사용하는 데 필요한 %s의 개수가 부족합니다.", _StringMan:GetItemName(itemCon)) or true
end
if (spiritJavelin > 0) then
	if (levelData.bulletConsume > _InventoryLogic:GetItemCount(cd, spiritJavelin)) then
		_ItemConsumeLogic:TryConsumeFromFuncKey(2030000)
		Unknown.Reset_All_Variable()
		return cli and "스킬을 사용하는 데 필요한 표창이 부족합니다." or true
	end
end
if (self:IsServer()) then
	if (hpCon > 0) then
		user.WsUser:IncHp(-hpCon)
	end
	if (mpCon > 0) then
		user.WsUser:IncMp(-mpCon)
	end
	if (moneyCon > 0) then
		_InventoryLogic:AddMoney(cd, -moneyCon)
	end
	if ((itemCon > 0 and itemConNo > 0) or spiritJavelin > 0) then
		local t = InventoryTransaction():Direct(cd)
		if (spiritJavelin > 0) then
			t:WasteItem(spiritJavelin, levelData.bulletConsume)
		end
		if (itemCon > 0 and itemConNo > 0) then
			t:RawDeleteItem(itemCon, itemConNo)
		end
		_InventoryLogic:ExecuteInventoryOperation(cd, t.ChangeLog, false)
	end
end
return false
end