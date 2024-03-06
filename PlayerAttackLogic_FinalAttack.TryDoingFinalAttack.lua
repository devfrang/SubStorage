return function (self,finalAttackId,lastAttackSkillId,activatedWeaponType) 
if (Unknown.Use_Skill) then
	return false
end
local localPlayer = _UserService.LocalPlayer
local ac = localPlayer.CharacterActionComponent
local wt = ac.CurrentWeaponType
-- log("doing final attack")
if (wt ~= activatedWeaponType) then
	log("wt different", wt, " / ", activatedWeaponType)
	return false
end
local faLevel = localPlayer.WsCharacterData:GetSkillLevel(finalAttackId)
if (faLevel == 0) then
	log("faLevel 0", finalAttackId)
	return false
end
if (wt == _WeaponType.Bow or wt == _WeaponType.Crossbow or wt == _WeaponType.ThrowingGlove) then
	--log("doing shoot attack ", finalAttackId)
	return _PlayerAttackLogic_Shoot:TryDoingShootAttack(localPlayer, finalAttackId, faLevel, 0.65)
elseif (wt == _WeaponType.OneHandedSword or wt == _WeaponType.OneHandedAxe or wt == _WeaponType.OneHandedMace or
		wt == _WeaponType.TwoHandedSword or wt == _WeaponType.TwoHandedAxe or wt == _WeaponType.TwoHandedMace or
		wt == _WeaponType.Spear or wt == _WeaponType.PoleArm) then
	--log("doing melee attack ", finalAttackId)
	return _PlayerAttackLogic_Melee:TryDoingMeleeAttack(localPlayer, finalAttackId, faLevel, nil, lastAttackSkillId) ~= -1
end
return false
end