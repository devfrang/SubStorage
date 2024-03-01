return function (self,actionName,attackSpeed,body,key) 
local ad = _CharacterActionLogic:GetActionData(actionName)
local playRate = (attackSpeed + 10) / 16
---@type BodyAction
local registered = {
	ActionData = ad,
	ActionAttackSpeed = attackSpeed,
	ActionBody = body,
	CurrentActionIndex = 0
}
if (key == nil) then
	self.LastState = self.Entity.StateComponent.CurrentStateName
	local now = _UtilLogic.ServerElapsedSeconds
	local totalDelay = ad:GetTotalFrameDelay(playRate)
	local actionDelay = ad:GetActionDelay(playRate)
	-- self:RegisterStopMovementHack(totalDelay)
	self.CurrentActionEnd = now + totalDelay
	if (actionName == "rope2" or actionName == "ladder2") then
		self.NextActionTime = now + 0.6 -- 왜 그랬어야 했을까?
	else
		self.NextActionTime = now + actionDelay
	end
	--log("next:", self.NextActionTime, "/totalDelay:", totalDelay, "/actionDelay:", actionDelay, "/now:", now)
	key = self.LocalBodyKey
end
self.Registered[key] = registered
end