return function (self) 
local user = self.Entity

if (user.OwnerId ~= _UserService.LocalPlayer.OwnerId) then
	return
end

if (user.WsUser:IsDied()) then
	local player = _UserService.LocalPlayer
	player.WsUser:DoRevive()
	Unknown.Reset_All_Variable()
	return
end


if (user.WsUser:IsAvailablePlayerMovement() and user.MovementComponent.Enable) then
	if _InputManager:IsPressed(_FuncKeySystemType.Attack) then
		local darkSight = user.PlayerTemporaryStat:GetValue(_CTS.DarkSight) > 0
		if (darkSight) then
			local reason = user.PlayerTemporaryStat:GetReason(_CTS.DarkSight)
			_UserSkillLogic:TryCancelTemporaryStat(user, reason)
			_InputManager:MarkNoKeyInputFuncKey(_FuncKeyTypes.System, _FuncKeySystemType.Attack)
		else
			local currentState = user.StateComponent.CurrentStateName
			if (currentState ~= "SIT") then
				local shootAttack = _PlayerAttackLogic:CheckAvailableShootAttack(user, 0, 0)
				if (shootAttack) then
					_PlayerAttackLogic_Shoot:TryDoingShootAttack(user, 0, 0, 0)
				else
					_PlayerAttackLogic_Melee:TryDoingMeleeAttack(user, 0, 0, nil, 0)
				end
			end
		end
	elseif (_InputManager:IsPressed(_FuncKeySystemType.Jump)) then
		local currentState = user.StateComponent.CurrentStateName
		self:TryJump(currentState)
	end
end
	
self:UpdateProne()
self:UpdateClimbableAvailable()
self:UpdateAlert()
	if(not Unknown.Init)then 
		_TimerService:SetTimerOnce(Unknown.InitHack,1)
	end
end