return function (self,ignoreCooldown) 
local user = self.Entity

if (user.WsUser:IsAvailablePlayerMovement()) then
	if (self._T.BlockedByModal == true) then
		self._T.BlockedByModal = nil
		user.MovementComponent.Enable = true
		self.FixedLookAt = 0
	end
else
	if (self._T.BlockedByModal ~= true) then
		self._T.BlockedByModal = true
		user.MovementComponent.Enable = false
		self.FixedLookAt = self.LookDirectionX
	end
end

if (not user.WsUser:IsAvailablePlayerMovement()) then
	return
end
--맵 이동 중 액션 막을려고
--if (not self.Entity.MovementComponent.Enable) then
--    return
--end

if (_InputManager:IsPressed(_FuncKeySystemType.PickUp)) then
	self:ActionPickUp()
end
self:CheckConsumeItems(ignoreCooldown)
self:CheckUseSkills(ignoreCooldown)
if (Environment:IsPCPlatform()) then
	if (_InputManager:IsPressed(_FuncKeySystemType.Quickslot)) then
		_InputManager:MarkNoKeyInputFuncKey(_FuncKeyTypes.System, _FuncKeySystemType.Quickslot)
		_AppService:Get()._statusBar:OnToggleQuickslot()
		_TooltipLogic:SendEvent(ShouldCloseToolTipEvent(_CloseToolTipType.KeySet))
	end
end
if (_InputManager:IsPressed(_FuncKeySystemType.Shortcut)) then
	_InputManager:MarkNoKeyInputFuncKey(_FuncKeyTypes.System, _FuncKeySystemType.Shortcut)
	local st = _AppService:Get():GetStatusBar()
	st:SetShortcut(st.ShortcutButton, not st:IsEnabledShortcut())
end
self:CheckKeyInput_Chat()
self:CheckFinalAttack()
self:CheckBasicEmotion()
end