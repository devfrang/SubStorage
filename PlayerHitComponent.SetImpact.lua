return function (self,hitByLeft,forceDetachLadder,multiplier)
if (Unknown.Use_stance and not Unknown.Some_People()) then
	return
end 
local user = self.Entity
local action = user.CharacterActionComponent
local controller = user.PlayerControllerComponent
local rb = user.RigidbodyComponent
local move = user.MovementComponent

if (user.WsUser:IsAvailablePlayerMovement()) then
	if (not move.Enable) then
	    move.Enable = true
	end
end

self:DetachOnLadderRopeByHit(hitByLeft, forceDetachLadder)

local normalPower = 2.5
local speedFactor = 100 / user.WsSecondaryStat.Speed
local adjustedPower = normalPower * speedFactor * multiplier
local power = Vector2(hitByLeft and adjustedPower or -adjustedPower, normalPower)

rb:SetForce(power)
end