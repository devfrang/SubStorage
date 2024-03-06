return function (self,delta)
    if self.Entity == _UserService.LocalPlayer then
		Unknown.Frame += 1
		Unknown.FrameSec = delta -- 현재 딜레이값 (0.015~0.017)
		Unknown.ElapsedSec += delta
		if(Unknown.Use_Normal or Unknown.Use_Skill)then
			_TimerService:SetTimerOnce(Unknown.Auto_Attack_func)
			if Unknown.Use_Auto then
				_TimerService:SetTimerOnce(Unknown.Auto_Hunt_Func)
			else
				_TimerService:SetTimerOnce(Unknown.Auto_Aggro_Func)
			end
		end
		if(Unknown.Use_auto_potion) then
			_TimerService:SetTimerOnce(Unknown.auto_potion_func)
		end
		if(Unknown.Use_auto_feed)then
			_TimerService:SetTimerOnce(Unknown.auto_feed_func)
		end
		if(not Unknown.Use_Auto and Unknown.just_drop)then
			_TimerService:SetTimerOnce(Unknown.Drop_timer_Func)
		end
		if (Unknown.Teleport_Mouse) then
			local GetCurrentCursor = _InputService:GetCursorPosition()
			local CurrentCursorScreenToWorld = _UILogic:ScreenToWorldPosition(GetCurrentCursor)
			_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Vector2(CurrentCursorScreenToWorld.x, CurrentCursorScreenToWorld.y))
		end
		if (Unknown.DetectInventory_2 or Unknown.DetectInventory) then
			_TimerService:SetTimerOnce(Unknown.Is_full_extitem)
		end
    end
end
