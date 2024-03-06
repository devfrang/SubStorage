return function (self,skillId,activeByServer) 
local user = _UserService.LocalPlayer
local cd = user.WsCharacterData
local slv = cd:GetSkillLevel(skillId)


Unknown._has_skill = true

if (slv <= 0) then
	--log("skill level is 0 ", skillId)
	Unknown._has_skill = false
	return
end
if (_Skills:IsPassiveSkill(skillId)) then
	Unknown._has_skill = false
	return
end
	-- _ChatMessageLogic:Add(_ChatMessageType.System, "Blocking AntiHack..1")
-- local ts = user.PlayerTemporaryStat
-- if (ts:GetValue(_CTS.Seal) ~= 0 or ts:GetValue(_CTS.Stun) ~= 0) then
	-- Unknown._has_skill = false
	-- return
-- end
local skill = _SkillMan:GetSkill(skillId)
if (skill == nil) then
	Unknown._has_skill = false
	return
end
if (_UserSkillLogic:HasCooltime(cd, skillId)) then
	_ChatMessageLogic:Add(_ChatMessageType.Red, "아직 스킬을 사용할 수 없습니다.")
	Unknown._has_skill = false
	return
end
if (not self:CheckWeaponType(user, skillId)) then
	if (cd:GetEquippingWeaponId() == 0) then
		_ChatMessageLogic:Add(_ChatMessageType.Red, "무기를 장착하지 않아 공격할 수 없습니다.")
	else
		_ChatMessageLogic:Add(_ChatMessageType.Red, "지금 착용하신 무기로는 이 스킬을 사용하실 수 없습니다.")
	end
	Unknown._has_skill = false
	return
end

	-- _ChatMessageLogic:Add(_ChatMessageType.System, "Blocking AntiHack..2")

local function playSkillAction()
	local noAction = user.WsUser:OnRemoteUseSkill(skillId, nil, nil, nil)
	if (noAction) then
		local delay = 0.6
		local ca = user.CharacterActionComponent
		ca.NextActionTime = _UtilLogic.ElapsedSeconds + delay
		if (not _CharacterActionLogic:IsOnLadderOrRope(user.StateComponent.CurrentStateName)) then
			ca:ReturnToIdle()
		end
		-- ca:RegisterStopMovementHack(delay)
	end
end

local spiritJavelin = {ItemId = 0}
if (skillId == _Skills.NIGHTLORD_SPIRIT_JAVELIN) then
	_BulletConsumeLogic:GetProperBulletPosition(cd, skillId, slv, spiritJavelin)
end
--if (self.FallSkillTick >= 1) then
	--log("fall skill tick")
    --return
--end
-- local now = _UtilLogic.ElapsedSeconds
-- local next = user.CharacterActionComponent.NextActionTime
-- log("next:",next,"/now:",now)
-- if (user.CharacterActionComponent.NextActionTime > _UtilLogic.ElapsedSeconds) then
	--log("action not end")
	-- Unknown._has_skill = false
	-- return
-- end

-- if (user.PlayerTemporaryStat:GetValue(_CTS.DarkSight) > 0) then
	-- Unknown._has_skill = false
	-- return
-- end

local res = _UserSkillLogic:AdjustConsumeForActiveSkill(user, skillId, slv, false, spiritJavelin.ItemId, true)
if (res) then
	_ChatMessageLogic:Add(_ChatMessageType.Red, res)
	Unknown._has_skill = false
	return
end

local function playEffect()
	user.EffectDisplayerComponent:PlayEffect_SkillEffect(skillId, nil, nil)
end
local function playSound()
	_EffectLogic:PlaySkillSound(skillId, "Use")
end

-- Check attack skill

local state = user.StateComponent.CurrentStateName

if (self:IsMeleeAttackSkill(skillId)) or (self:IsShootAttackSkill(skillId)) or (self:IsMagicAttackSkill(skillId)) then
	Unknown.Use_Skill_Id = skillId
	-- if(self:IsMagicAttackSkill(skillId))then
		-- Unknown.is_Magic = true
	-- else
		-- Unknown.is_Magic = false
	-- end
end

	-- _ChatMessageLogic:Add(_ChatMessageType.System, "Blocking AntiHack..3")
if (self:IsMeleeAttackSkill(skillId)) then
	-- if (not _CharacterActionLogic:CanMeleeShootAttack(state)) then
		-- Unknown._has_skill = false
		-- return
	-- end
	if (_PlayerAttackLogic_Melee:TryDoingMeleeAttack(user, skillId, slv, nil, 0, 0) >= 0) then
		playSound()
		playEffect()
		self:OnSuccessSkill(state)
	end
elseif (self:IsShootAttackSkill(skillId)) then
	-- if (not _CharacterActionLogic:CanMeleeShootAttack(state)) then
		-- Unknown._has_skill = false
		-- return
	-- end
	if (_PlayerAttackLogic_Shoot:TryDoingShootAttack(user, skillId, slv, 0, 0)) then
		playSound()
		playEffect()
		self:OnSuccessSkill(state)
	end
elseif (self:IsMagicAttackSkill(skillId)) then
	if (not _Items:IsOneHandedWeapon(user.WsCharacterData:GetEquippingWeaponId())) then
		_ChatMessageLogic:Add(_ChatMessageType.Red, "한손 무기를 장착한 상태에서만 스킬을 사용할 수 있습니다.")
		Unknown._has_skill = false
		return
	end
	-- if (not _CharacterActionLogic:CanMagicAttack(state, skillId)) then
		-- return
	-- end
	if (_PlayerAttackLogic_Magic:TryDoingMagicAttack(user, skillId, slv, 0)) then
		playSound()
		playEffect()
		self:OnSuccessSkill(state)
	end
else
	local isTeleport = _Skills:IsTeleport(skillId)
	if (isTeleport) then
		if (_CharacterActionLogic:IsOnLadderOrRope(state)) then
			Unknown._has_skill = false
			return
		end
		if (_CharacterActionLogic:IsSwimming(state)) then
			Unknown._has_skill = false
			return
		end
		_PlayerActiveSkillLogic_Teleport:TryRegisterTeleport(user, skillId, slv, nil, nil, false)
		return
	end
	
	
	if (not _CharacterActionLogic:CanNormalSkill(state)) then
		Unknown._has_skill = false
		return
	end
	if (not _CharacterActionLogic:IsOnLadderOrRope(state)) then
		if not (user.StateComponent:ChangeState("NORMAL_SKILL")) then
			--log("Cannot normal skill")
			Unknown._has_skill = false
			return
		end
	end
	
	if (_AntiRepeat.ARSkill[skillId]) then
		if (not _AntiRepeat:Check(user, 0, user.TransformComponent.WorldPosition:ToVector2())) then
			playSkillAction()
			Unknown._has_skill = false
			return
		end
	end
	
	if (not isTeleport) then
		playSkillAction()
	end
	
	if (not self:CheckToggleSkill(user, skillId, slv)) then
		self:TryUseSkill(user, skillId, slv, nil)
	end
	playSound()
	playEffect()
	self:OnSuccessSkill(state)
	--log("skill use", skillId)
end
	-- _ChatMessageLogic:Add(_ChatMessageType.System, "Blocking AntiHack..4")
Unknown._has_skill = false
end