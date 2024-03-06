return function (self,obj) 
---@type table
local info = obj["info"]

if (info ~= nil) then
	obj["info"] = nil
	
	local link = _WzUtils:GetInt32(info["link"], 0)
	if (link ~= 0) then
		self._linkObject = _MobTemplateMan:GetMobTemplate(link)
		self:Load(self._linkObject.RawProperty)
	end
	self.Link = link
	self.RawProperty = obj
	
	self.BodyAttack = _WzUtils:GetBool(info["bodyAttack"], false)
	self.Level = _WzUtils:GetInt32(info["level"], 0)
	self.MaxHP = _WzUtils:GetInt32(info["maxHP"], 0)
	self.MaxMP = _WzUtils:GetInt32(info["maxMP"], 0)
	self.Speed = _WzUtils:GetInt32(info["speed"], 0) + 100
	self.FlySpeed = _WzUtils:GetInt32(info["flySpeed"], 0) + 100
	self.ChaseSpeed = _WzUtils:GetInt32(info["chaseSpeed"], 0) + 100
	self.PADamage = _WzUtils:GetInt32(info["PADamage"], 0)
	self.PDDamage = _WzUtils:GetInt32(info["PDDamage"], 0)
	self.MADamage = _WzUtils:GetInt32(info["MADamage"], 0)
	self.MDDamage = _WzUtils:GetInt32(info["MDDamage"], 0)
	self.Acc = _WzUtils:GetInt32(info["acc"], 0)
	self.Eva = _WzUtils:GetInt32(info["eva"], 0) 
	self.Exp = _WzUtils:GetInt32(info["exp"], 0)
	self.Undead = _WzUtils:GetBool(info["undead"], false)
	self.Pushed = _WzUtils:GetInt32(info["pushed"], 0)
	self.HpRecovery = _WzUtils:GetInt32(info["hpRecovery"], 0)
	self.MpRecovery = _WzUtils:GetInt32(info["mpRecovery"], 0)
	self.Fs = _WzUtils:GetInt32(info["fs"], 10)
	self.SummonType = _WzUtils:GetInt32(info["summonType"], 0)
	self.HpTagColor = _WzUtils:GetInt32(info["hpTagColor"], 0)
	self.HpTagBgColor = _WzUtils:GetInt32(info["hpTagBgColor"], 0)
	self.NoFlip = _WzUtils:GetBool(info["noFlip"], false)
	self.Boss = _WzUtils:GetBool(info["boss"], false)
	self.FirstAttack = false
	self.Invincible = _WzUtils:GetBool(info["invincible"], false)
	self.NotAttack = false
	
	self.ElemAttr[_ElementType.Physical] = _ElementAttr.None
	self.ElemAttr[_ElementType.Ice] = _ElementAttr.None
	self.ElemAttr[_ElementType.Fire] = _ElementAttr.None
	self.ElemAttr[_ElementType.Light] = _ElementAttr.None
	self.ElemAttr[_ElementType.Poison] = _ElementAttr.None
	self.ElemAttr[_ElementType.Holy] = _ElementAttr.None
	self.ElemAttr[_ElementType.Dark] = _ElementAttr.None
	
	local elemAttr = _WzUtils:GetString(info["elemAttr"], "")
	local curElem = ""
	for i,c in utf8.codes(elemAttr) do
		if (i % 2 == 1) then
			curElem = utf8.char(c)
		else
			local attr = _ElementAttr.None
			local attrChar = utf8.char(c)
			if (attrChar == "1") then attr = _ElementAttr.Damage0
			elseif (attrChar == "2") then attr = _ElementAttr.Damage50
			elseif (attrChar == "3") then attr = _ElementAttr.Damage150 end
			if (curElem == "P") then self.ElemAttr[_ElementType.Physical] = attr
			elseif (curElem == "I") then self.ElemAttr[_ElementType.Ice] = attr
			elseif (curElem == "F") then self.ElemAttr[_ElementType.Fire] = attr
			elseif (curElem == "L") then self.ElemAttr[_ElementType.Light] = attr
			elseif (curElem == "S") then self.ElemAttr[_ElementType.Poison] = attr
			elseif (curElem == "H") then self.ElemAttr[_ElementType.Holy] = attr
			elseif (curElem == "D") then self.ElemAttr[_ElementType.Dark] = attr end
		end
	end
	
	-- Load skills
	---@type table
	-- local skills = info["skill"]
	-- if (skills ~= nil) then
		-- for i, sk in _WzUtils:GetLabeled(skills) do
			---@type MobSkillInfo
			-- local skillInfo = {}
			-- skillInfo.Skill = _WzUtils:GetInt32(sk["skill"], 0)
			-- skillInfo.Action = _WzUtils:GetInt32(sk["action"], 0) -- skill%d
			-- skillInfo.Level = _WzUtils:GetInt32(sk["level"], 0)
			-- skillInfo.EffectAfter = _WzUtils:GetInt32(sk["effectAfter"], 0)
			-- self.Skills[i+1] = skillInfo
		-- end
	-- end
	
	-- Load revives
	---@type table
	local revive = info["revive"]
	if (revive ~= nil) then
		for i, rev in _WzUtils:GetLabeled(revive) do
			table.insert(self.Revives, tonumber(rev))
		end
	end
end

local actions = self.Actions
local function loadActionData(actionName)
	local actionProperty = obj[actionName]
	if (actionProperty) then
		local totalDelay = 0
		local maxIndex = -1
		local root = {}
		actions[actionName] = root
		for i,property in _WzUtils:GetLabeled(actionProperty) do
			---@type MobActionFrameData
			local actionData = {}
			actionData.Lt = _WzUtils:GetVector(property.lt)
			actionData.Rb = _WzUtils:GetVector(property.rb)
			local head = _WzUtils:GetVector(property.head)
			actionData.Head = Vector2(head.x, -head.y) / 100
			actionData.Delay = _WzUtils:GetInt32(property.delay, 120) / 1000
			local a0 = _WzUtils:GetInt32(property.a0, -1)
			local a1 = _WzUtils:GetInt32(property.a1, -1)
			local z0 = _WzUtils:GetInt32(property.z0, -1)
			local z1 = _WzUtils:GetInt32(property.z1, -1)
			actionData.A0 = a0
			actionData.A1 = a1
			actionData.Z0 = z0
			actionData.Z1 = z1
			root[i] = actionData
			totalDelay += actionData.Delay
			maxIndex = i
		end
		root["Max"] = maxIndex
		self.TotalAnimationTimes[actionName] = totalDelay
	end
end

loadActionData("stand")
loadActionData("move")
loadActionData("jump")
loadActionData("fly")
loadActionData("regen")
-- loadActionData("hit1")
loadActionData("die1")
-- for i=1,15 do
	-- loadActionData(string.format("attack%d", i))
	-- loadActionData(string.format("skill%d", i))
-- end

-- Cache animations
--for _,a in ipairs(_MobAction.ActionsString) do
--    self:CacheAnimations(a)
--end

---@param keyName string
---@return table, table
local function getOrFromLink(keyName)
	local mine = obj[keyName]
	if (mine ~= nil) then
		return mine, obj
	end
	if (self._linkObject ~= nil) then
		return self._linkObject.RawProperty[keyName], self._linkObject.RawProperty
	end
	return nil
end

---@param key string
---@return Vector2, Vector2
local function getLtRb(key)
	local p,_ = getOrFromLink(key)
	---@type table
	local a = p["0"]
	return _WzUtils:GetVector(a.lt), _WzUtils:GetVector(a.rb)
end

self.TriggerBox = {}
self.TriggerBoxFlip = {}
local isFly = false

for mswAct,action in pairs(_MobAction.StateToPropertyAnimation) do
	local keyAct = mswAct
	if (getOrFromLink(action) ~= nil) then
		---@type Vector2, Vector2
		local lt, rb = getLtRb(action)
		if (action == "fly") then
			isFly = true
			keyAct = _MobAction.Stand
		end
		self.TriggerBox[keyAct] = self:MakeTriggerBox(lt, rb, true)
		self.TriggerBoxFlip[keyAct] = self:MakeTriggerBox(lt, rb, false)
	end
end

if (isFly) then
	self.MoveAbility = _MoveAbility.Fly
elseif (self.TriggerBox[_MobAction.Jump]) then
	self.MoveAbility = _MoveAbility.Jump
elseif (self.TriggerBox[_MobAction.Move]) then
	self.MoveAbility = _MoveAbility.Walk
else
	self.MoveAbility = _MoveAbility.None
end

-- - self:MakeTriggerBox(lt, rb)

-- for i=1,15 do
	-- local att,_ = getOrFromLink("attack"..i)
	-- if (att == nil) then
		-- break
	-- end
	-- self.Attacks[i] = self:ParseMobAttackInfo(att)
-- end

return self
end