return function (self) 
if (self:IsClient()) then
    _TimerService:SetTimerRepeat(self.UpdateClient, 0.1, 0)
    if (self.Entity.OwnerId == _UserService.LocalPlayer.OwnerId) then
		self.StatusBar = _AppService:Get():GetStatusBar()
        _TimerService:SetTimerRepeat(self.UpdateClientLocal, 0.5, 0)
        _TimerService:SetTimerRepeat(self.UpdateClientRealTimeLocal, 0.016, 1)
        -- _TimerService:SetTimerRepeat(self.Collect, 45, 30)
	else
        _TimerService:SetTimerRepeat(self.UpateClientRemote, 0.5, 1)
    end
else
    self:OnBeginPlay_Server()
end
end