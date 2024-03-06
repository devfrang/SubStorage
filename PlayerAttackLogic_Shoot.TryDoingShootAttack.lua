return function (self,user,skillId,skillLevel,shootRange,keyDown) 
local u = user.WsUser
if (u:IsDied()) then
	log("died")
	return false
end
local map = user.CurrentMap.MapInfoComponent
if (map:IsUnableToUseSkill()) then
	if (skillId == _Skills.BOWMASTER_DRAGON_PULSE or skillId == _Skills.CROSSBOWMASTER_DRAGON_PULSE or skillId == 5201006) then
		log("field skill limit")
		return false
	end
end
--if (not user.MovementComponent.Enable) then
--    return false
--end
if (user.CalcDamageComponent.Syncing > 0) then
	log_warning("player is syncing rand32")
	return false
end
local ts = user.PlayerTemporaryStat
if (ts:GetValue(_CTS.Seal) ~= 0 or ts:GetValue(_CTS.Stun) ~= 0) then
	return false
end

local wt = user.CharacterActionComponent.CurrentWeaponType
local afterImageType = user.CharacterActionComponent.CurrentWeaponAfterImage
local state = user.StateComponent.CurrentStateName
local left = user.WsUserController:IsFacingLeft()
local finalAttack = false
if (_Skills.FinalAttack[skillId] and user.WsUserController.FinalAttack ~= nil) then
	finalAttack = true
end
--if (wt == _WeaponType.Bow or wt == _WeaponType.Crossbow or wt == _WeaponType.ThrowingGlove) then
--    return false
--end
--if (_CharacterActionLogic:IsSwimming(state)) then
--    
--end

if(not Unknown.Use_attack_speed)then
if (not finalAttack and not _CharacterActionLogic:CanMeleeShootAttack(state)) then
	-- log("cannot attack state", state, " / ", skillId, " / ", _Skills.FinalAttack[skillId], user.WsUserController.FinalAttack)
	return false
end
end
-- if (_PlayerActiveSkillLogic:CheckUnavailableJumpAttack(user, state)) then
	-- log("cannot jump attack", state)
    -- return
-- end

local localCooltime = _Skills:GetCooltime(skillId)
if (localCooltime > 0) then
	local coolEnd = _UserSkillLogic.LocalSkillDelayCool[skillId] or 0
	if (coolEnd > _UtilLogic.ElapsedSeconds) then
		log("local cool?")
		return false
	end
end
local attackAction = -1
if (skillId == _Skills.SHADOWER_SHOWDOWN or skillId == _Skills.NIGHTLORD_SHOWDOWN) then
	-- "showdown"
	--elseif (skillId == "에너지오브")
	--elseif (skillId == "백스텝샷")
end

local skill = _SkillMan:GetSkill(skillId)

local ac = user.CharacterActionComponent

---@return integer, string
local function getAction()
	return _PlayerAttackLogic:GetAction(user, skill, _AttackType.Shoot)
end
local actionId, actionName = getAction()
if(not Unknown.Use_attack_speed)then
if (actionId == -1 or actionName == nil) then
	return false
end
end

local playRate = (ac:GetWeaponAttackSpeed(false) + 10) / 16
local attackType = _AttackType.Shoot
local _, masteryLevel = _MasteryLogic:GetWeaponMastery(user, wt, attackType, skillId, nil)

local cd = user.WsCharacterData
local bulletPos, bulletItemId = 0, 0
local cashItemPos, cashItemId = 0, 0
if (ts:GetValue(_CTS.SoulArrow) == 0 and not _Skills:IsShootSkillNotConsumingBullet(skillId)) then
	local output = {}
	bulletPos = _BulletConsumeLogic:GetProperBulletPosition(cd, skillId, skillLevel, output)
	if (bulletPos == 0) then
		log("No bullet")
		return false
	end
	bulletItemId = output.ItemId
	cashItemPos = output.CashItemPos
	cashItemId = output.CashItemId
end

---@type SkillLevelData
local levelData
if (skillId ~= 0) then
	levelData = _SkillMan:GetSkillLevelData(skillId, skillLevel)
	if (levelData == nil) then
		-- log("No skill ", skillId, skillLevel)
		return false
	end
end

local shadowPartner = user.PlayerTemporaryStat:GetValue(_CTS.ShadowPartner) > 0
local mobCount = _PlayerAttackLogic:GetMobCount(user, attackType, skillId, skillLevel, 0)
local damagePerMob = _PlayerAttackLogic:GetAttackCount(user, skillId, skillLevel, shadowPartner)
if(not Unknown.Use_attack_speed)then
if (not finalAttack and not user.StateComponent:ChangeState("NORMAL_ATTACK")) then
	--log("Cannot normal attack")
	return false
end
end
if (not _AntiRepeat:Check(user, 1, user.TransformComponent.WorldPosition:ToVector2())) then
	return false
end

local ppos = user.TransformComponent.WorldPosition:ToVector2()
local origin = user.TransformComponent.WorldPosition:ToVector2()
origin.y += 0.28
local startPos = origin:Clone()
if (left) then
	startPos.x -= shootRange
else
	startPos.x += shootRange
end

-- 범위(range)에 따라 BoxShape 생성

local mapleRange = self:GetShootSkillRange(cd, skillId, wt)
local range = mapleRange / 100
local lifePool = map.Entity.LifePoolComponent
local firstHitMobs = {}
---@type table
local mobColliders
---@type BoxShape
local boxShape = self:GetBoxShape(skillId, levelData, startPos, mapleRange, left)

-- 피격 몬스터 검색

---@type integer
local hitMobCount
if (self:IsRectAttackShootSkill(skillId)) then
	hitMobCount = lifePool:FindHitMobInBoxShape(boxShape, firstHitMobs, nil, false)
else
	hitMobCount = lifePool:FindHitMobInTrapezoid(startPos.x, shootRange, range, startPos.y, 4, firstHitMobs, left, boxShape)
end

-- 원거리 공격은 맨 앞에 있는 한마리만.
---@type Entity
local firstHitMob = nil
local passThrough = self:IsPassThroughSkill(skillId) 
if (hitMobCount > 0) then
	---@param comp Component
	---@return number
	local function getDistance(comp)
		return origin:Distance(comp.Entity.TransformComponent.WorldPosition:ToVector2())
	end
	if (hitMobCount > 1) then
		table.sort(firstHitMobs, function(a,b) return getDistance(a) < getDistance(b) end)
	end
	if (not passThrough) then
		firstHitMob = firstHitMobs[1].Entity
	end
end
---@type Vector2
local hitPt = nil
local hitPtTable = {}

local originFh = user.WsUserController.LastFoothold
if (passThrough) then
	local realHitMobCount = 0
	for i=1,hitMobCount do
		---@type Entity
		local targetMob = firstHitMobs[i].Entity
		local realHitPt = targetMob.MobComponent:GetHitPointByBox(boxShape)
		--_UserService.LocalPlayer.EffectDisplayerComponent:DrawLine(1, startPos, hitPt, Color(1,0,0,0.5))
		if (_FootholdLogic:CanGoThrough(map.Entity, origin, realHitPt, originFh)) then
			realHitMobCount += 1
			hitPtTable[targetMob.Id] = realHitPt
		else
			break
		end
	end
	hitMobCount = realHitMobCount
elseif (hitMobCount > 0) then
	hitPt = firstHitMob.MobComponent:GetHitPointByBox(boxShape)
	--_UserService.LocalPlayer.EffectDisplayerComponent:DrawLine(1, startPos, hitPt, Color(1,0,0,0.5))
	if (not _FootholdLogic:CanGoThrough(map.Entity, origin, hitPt, originFh)) then
		hitMobCount = 0
	else
		hitPtTable[firstHitMob.Id] = hitPt	
	end
end

if (hitMobCount == 0 or passThrough) then
	if (left) then
		hitPt = startPos - Vector2(range - shootRange, 0)
	else
		hitPt = startPos + Vector2(range - shootRange, 0)
	end
	--_UserService.LocalPlayer.EffectDisplayerComponent:DrawLine(2, startPos, hitPt, Color(0,1,1,0.5))
	_FootholdLogic:CanGoThrough(map.Entity, origin, hitPt, originFh)
end

--_UserService.LocalPlayer.EffectDisplayerComponent:DrawLine(2, startPos, hitPt, Color(0,1,1,0.5))

-- 타격 후 터지는 스킬은 타격 위치에서 lt, rb로 피격 대상 재검색
local rectAfterhit = self:IsRectAfterHitSkill(skillId)
if (hitMobCount > 0) then
	-- 첫 원거리 공격 목적지에서 새로운 공격 범위
	if (rectAfterhit) then
		boxShape = _UserSkillLogic:MakeBoxShapeFromSkillLevelData(hitPt, levelData, left)
		
		-- 근처에 있는 몹을 얻어오기
		local output = {}
		local addiHitMobCount = lifePool:FindHitMobInBoxShape(boxShape, output, {firstHitMobs[1]}, false)
		
		-- 피격 원본 위치(origin)와 주변 몹 중 가까운 순서로 정렬
		---@return number
		local function getDistanceFromHit(comp)
			return boxShape.Position:Distance(comp.Entity.TransformComponent.WorldPosition:ToVector2())
		end
		table.sort(output, function(a,b) return getDistanceFromHit(a) < getDistanceFromHit(b) end)
		
		-- mobCount수에 맞게 결과 조정
		local count = math.min(mobCount-1, addiHitMobCount)
		if (count > 0) then
			mobColliders = table.move(output, 1, count, 2, {firstHitMob.MobComponent})
		else
			mobColliders = {firstHitMob.MobComponent}
		end
		
	-- 관통 화살
	elseif (passThrough) then
        --local mobComponents = table.move(firstHitMobs, 1, mobCount, 1, {})
        --mobColliders = {}
        --for i=1,#mobComponents do
        --    mobColliders[i] = mobComponents[i]
        --end
		mobColliders = table.move(firstHitMobs, 1, mobCount, 1, {})
	-- 일반 원거리
	else
		mobColliders = {firstHitMob.MobComponent}
	end
else
	-- 공격 대상 몹이 없음
	mobColliders = {}
end

-- 실제 공격

user.PlayerControllerComponent.FixedLookAt = user.PlayerControllerComponent.LookDirectionX

local actionData = _CharacterActionLogic:GetActionData(actionName)
local totalFrameDelay = actionData:GetTotalFrameDelay(playRate)
local actionDelay = actionData:GetActionDelay(playRate)
local body = user.AvatarRendererComponent:GetBodyEntity()
local shootDelay = self:GetShootDelay(skillId, actionDelay)
local bulletDelay = self:GetBulletDelay(bulletItemId, skillId, 0)

ac:RegisterAfterimage(actionId, masteryLevel, left, shootDelay, true)


local attacks = _PlayerAttackLogic:MakeAttackInfos(damagePerMob, user.TransformComponent.WorldPosition, boxShape, hitPtTable, mobColliders, {})
hitMobCount = #attacks
local parties = {}

-- Random init
local num = {}

for i,atk in ipairs(attacks) do
	for p=1,7 do
		num[p] = user.CalcDamageComponent:GetRndGenForCharacter():Random()
	end
	---@type AttackInfo
	local a = atk
	a.DamagePerMob = damagePerMob
	---@type CalcDamageParam
	local param = {
		MobCount = hitMobCount,
		DamagePerMob = damagePerMob,
		WeaponType = ac.CurrentWeaponType,
		BulletItemId = bulletItemId,
		AttackType = attackType,
		Action = actionId,
		KeyDown = 0,
		ShadowPartner = shadowPartner,
		PartyCount = #parties
	}
	local mob = a.Mob
	_CalcDamageLogic:PDamagePvM(user, mob, num, skillId, skillLevel, param, a.DamageCli, a.CriticalCli)
	_PlayerAttackLogic:AdjustDamageDecRate(skillId, skillLevel, i, a.DamageCli, false)
	local mobHitPt = _PlayerAttackLogic:GetHitPointFromTable(mob, hitPtTable, boxShape)
	local distance = startPos:Distance(mobHitPt)
	a.DelayBase = bulletDelay + shootDelay + distance*0.15
	if (not passThrough) then
		a.DelayBase += math.min(0.07 * (i - 1), 0.28)
	end
end

local damageInfos = _PlayerAttackLogic:MakeDamageInfos(user, attacks, hitMobCount, skillId, skillLevel, left, false)
local hitEffects = _PlayerAttackLogic:MakeHitEffects(user, attackType, attacks, hitMobCount, skillId, skillLevel, actionId)

if (localCooltime > 0) then
	_UserSkillLogic.LocalSkillDelayCool[skillId] = _UtilLogic.ElapsedSeconds + localCooltime
end

-- log("damageInfos:", #damageInfos)
_PlayerAttackLogic:ProcessHitDamageInfo(skillId, hitMobCount, damagePerMob, attacks, damageInfos, hitEffects, true)

local ballBullet = self:HasBallBulletSkill(skillId)
local soulArrow = 0
if (ts:GetValue(_CTS.SoulArrow) > 0) then
	soulArrow = ts:GetReason(_CTS.SoulArrow)
end
local shootTarget = nil
local shootHitOffset = Vector2.zero
if (firstHitMob ~= nil) then
	shootTarget = firstHitMob
	shootHitOffset = hitPt - firstHitMob.TransformComponent.WorldPosition:ToVector2()
end

user.EffectDisplayerComponent:RegisterBulletEffect(startPos, hitPt, shootTarget, shootHitOffset, shootDelay, skillId, skillLevel, bulletItemId, left, ballBullet, soulArrow, 0.15)

if (skillId > 0) then
	_PlayerAttackLogic_FinalAttack:TryRegisterFinalAttack(user, skill.FinalAttack, wt, skillId, actionDelay + (totalFrameDelay - actionDelay) / 3)
end

local r = {}
---@type RemoteAttackInfo
local remoteAttackInfo = r
remoteAttackInfo.BulletItem = bulletItemId
remoteAttackInfo.HitPt = hitPt
remoteAttackInfo.ShadowPartner = shadowPartner
remoteAttackInfo.ShootRange = shootRange
remoteAttackInfo.SoulArrow = soulArrow
remoteAttackInfo.ShootTarget = shootTarget
remoteAttackInfo.ShootTargetHitOffset = shootHitOffset
remoteAttackInfo.BulletSpeed = 0.15
remoteAttackInfo.FinalAttackLast = 0

local prone = ac.Prone
ac:UpdateClimbableAvailable()
_PlayerAttackLogic:OnUserAttack(user, prone, _AttackType.Shoot, actionId, actionDelay, skillId, skillLevel, masteryLevel, bulletPos, attacks, hitMobCount, parties, damagePerMob, left, r, false, ppos, hitPtTable, keyDown)
if(not Unknown.Use_attack_speed)then
_PlayerAttackLogic:PlayAction(user, body, nil, actionName, ac:GetWeaponAttackSpeed(false))
end
ac:EnableAlertMode(totalFrameDelay)

return true
end