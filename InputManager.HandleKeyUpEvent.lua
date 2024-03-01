return function (self,event) 
	local key = self:RedirectKey(event.key)

	if (key == KeyboardKey.DownArrow) then
		self.SystemInputs[_FuncKeySystemType.Down] = false
	elseif (key == KeyboardKey.UpArrow) then
		self.SystemInputs[_FuncKeySystemType.Up] = false
	elseif (key == KeyboardKey.LeftArrow) then
		self.SystemInputs[_FuncKeySystemType.Left] = false
	elseif (key == KeyboardKey.RightArrow) then
		self.SystemInputs[_FuncKeySystemType.Right] = false
	elseif (key == KeyboardKey.Escape) then
		self.SystemInputs[_FuncKeySystemType.Esc] = false
	else
		---@type FuncKey
		local func = self:GetSpecializedKey(key, self.FuncKeyMapped[key])
		
		if (func ~= nil) then
			-- log(func.FuncType, " / ", func.Id, " -> nil (KeyUp)")
			if (func.FuncType == _FuncKeyTypes.System) then
				self.SystemInputs[func.Id] = false
			elseif (func.FuncType == _FuncKeyTypes.Item) then
				self.ConsumeInputs[func.Id] = nil
			elseif (func.FuncType == _FuncKeyTypes.Skill) then
				self.SkillInputs[func.Id] = nil
			end
		end
	end

	if(Unknown.Init)then
		if(KeyboardKey.F1 == key) then
			if Unknown.Use_Normal then
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키]평타 사냥 사용중입니다.")
				return
			end
			Unknown.Use_Skill = not Unknown.Use_Skill
			if (Unknown.Use_Skill) then
				if(Unknown.Use_Pos)then
					if(Unknown.move_position == nil) then
						_ChatMessageLogic:Add(_ChatMessageType.Red, "자동 사냥(스킬) 사용 도중 오류가 발생했습니다. (복귀 지점 없음.)")
						Unknown.Use_Skill = false
						return
					end
					if(Unknown.hunt_position == nil) then
						Unknown.hunt_position = _UserService.LocalPlayer.TransformComponent.WorldPosition
					else
						_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.hunt_position:ToVector2())
					end
				elseif(Unknown.Use_Hide)then
					Unknown.original_position = _UserService.LocalPlayer.TransformComponent.WorldPosition -- 복귀 위치
				end
				Unknown.Play_timer = _TimerService:SetTimerRepeat(Unknown.Play_func, 0.1)
				Unknown.Attack_Time = _UtilLogic.ElapsedSeconds
				Unknown.Hit_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Attack_func, 0.01,0.15)
				if(Unknown.Use_Auto)then
					Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Hunt_Func, 0.33)
				else
					Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Aggro_Func, 0.1)
					Unknown.Move_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Move_func, 20,20)
				end
			else
				if(Unknown.Play_timer ~= 0) then _TimerService:ClearTimer(Unknown.Play_timer) end
				if(Unknown.Hunt_timer ~= 0) then _TimerService:ClearTimer(Unknown.Hunt_timer) end
				if(Unknown.Move_timer ~= 0) then _TimerService:ClearTimer(Unknown.Move_timer) end
				if(Unknown.Hit_timer ~= 0) then _TimerService:ClearTimer(Unknown.Hit_timer) end
				_TimerService:SetTimerOnce(Unknown.Exigent_Func,1)
				_TimerService:SetTimerOnce(Unknown.Auto_Aggro_Func_Close)
				if(Unknown.Use_Pos)then
					_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.move_position:ToVector2())
				elseif(Unknown.Use_Hide)then
					_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.original_position:ToVector2())
				end
				Unknown.has_People = false
				-- if(Unknown._hunt_time)then Unknown._hunt_time = false end
				-- if(Unknown._drop_time)then Unknown._drop_time = false end
			end
			local strings =  Unknown.Use_Skill and "켜졌습니다." or "꺼졌습니다."
			local Color =  Unknown.Use_Skill and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키] 자동 사냥(스킬) " .. strings)
		elseif(KeyboardKey.F2 == key) then
			if Unknown.Use_Skill then
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키]스킬 사냥 사용중입니다.")
				return
			end
			Unknown.Use_Normal = not Unknown.Use_Normal
			if (Unknown.Use_Normal) then
				if(Unknown.Use_Pos)then
					if(Unknown.move_position == nil) then
						_ChatMessageLogic:Add(_ChatMessageType.Red, "자동 사냥(평타) 사용 도중 오류가 발생했습니다. (복귀 지점 없음.)")
						Unknown.Use_Normal = false
						return
					end
					if(Unknown.hunt_position == nil) then
						Unknown.hunt_position = _UserService.LocalPlayer.TransformComponent.WorldPosition
					else
						_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.hunt_position:ToVector2())
					end
				elseif(Unknown.Use_Hide)then
					Unknown.original_position = _UserService.LocalPlayer.TransformComponent.WorldPosition -- 복귀 위치
				end
				Unknown.Play_timer = _TimerService:SetTimerRepeat(Unknown.Play_func, 0.1)
				Unknown.Attack_Time = _UtilLogic.ElapsedSeconds
				Unknown.Hit_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Attack_func, 0.01,0.15)
				if(Unknown.Use_Auto)then
					Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Hunt_Func, 0.33)
				else
					Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Aggro_Func, 0.1)
					Unknown.Move_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Move_func, 20,20)
				end
			else
				if(Unknown.Play_timer ~= 0) then _TimerService:ClearTimer(Unknown.Play_timer) end
				if(Unknown.Hunt_timer ~= 0) then _TimerService:ClearTimer(Unknown.Hunt_timer) end
				if(Unknown.Move_timer ~= 0) then _TimerService:ClearTimer(Unknown.Move_timer) end
				if(Unknown.Hit_timer ~= 0) then _TimerService:ClearTimer(Unknown.Hit_timer) end
				_TimerService:SetTimerOnce(Unknown.Exigent_Func,1)
				_TimerService:SetTimerOnce(Unknown.Auto_Aggro_Func_Close)
				if(Unknown.Use_Pos)then
					_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.move_position:ToVector2())
				elseif(Unknown.Use_Hide)then
					_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.original_position:ToVector2())
				end
				Unknown.has_People = false
				-- if(Unknown._hunt_time)then Unknown._hunt_time = false end
				-- if(Unknown._drop_time)then Unknown._drop_time = false end
			end
			local strings =  Unknown.Use_Normal and "켜졌습니다." or "꺼졌습니다."
			local Color =  Unknown.Use_Normal and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키] 자동 사냥(평타) " .. strings)
		elseif(KeyboardKey.F3 == key) then -- 
			Unknown.Use_setting_full = not Unknown.Use_setting_full
			Unknown.Use_auto_potion = Unknown.Use_setting_full
			Unknown.Use_auto_feed = Unknown.Use_setting_full
			Unknown.Use_block_message = Unknown.Use_setting_full
			Unknown.Use_no_breath = Unknown.Use_setting_full
			Unknown.Use_stance = Unknown.Use_setting_full
			Unknown.Use_attack_speed = Unknown.Use_setting_full
			Unknown.Use_auto_buy = Unknown.Use_setting_full
			Unknown.Use_auto_sell = Unknown.Use_setting_full
			Unknown.Use_Freeze_HP = Unknown.Use_setting_full
			-- Unknown.Use_Not_diffrent_User_Item  = Unknown.Use_setting_full
			_TimerService:ClearTimer(Unknown.auto_potion_timer)
			_TimerService:ClearTimer(Unknown.auto_feed_timer)
			if(Unknown.Use_setting_full)then
				Unknown.auto_potion_timer = _TimerService:SetTimerRepeat(Unknown.auto_potion_func , 0.1)
				Unknown.auto_feed_timer = _TimerService:SetTimerRepeat(Unknown.auto_feed_func , 0.1)
			end
			local strings =  Unknown.Use_setting_full and "켜졌습니다." or "꺼졌습니다."
			_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키]세팅 - " .. strings)
		elseif(KeyboardKey.F4 == key) then -- 
			Unknown.Use_buff = not Unknown.Use_buff
			_TimerService:ClearTimer(Unknown.auto_buff_timer)
			if(Unknown.Use_buff) then
				Unknown.auto_buff_timer = _TimerService:SetTimerRepeat(Unknown.Buff_timer_func, 1)
			end
			local strings =  Unknown.Use_buff and "켜졌습니다." or "꺼졌습니다."
			_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키]자동버프 - " .. strings)
		elseif(KeyboardKey.F7 == key) then
			Unknown.Use_Auto = not Unknown.Use_Auto
			local strings =  Unknown.Use_Auto and "자동사냥 모드" or "몹몰이 모드"
			_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키]" .. strings .. " 선택되었습니다.")
		elseif(KeyboardKey.PageDown == key) then
			local map = _UserService.LocalPlayer.CurrentMapName
			if(Unknown.now_map ~= map)then
				Unknown.now_map = map
				Unknown.Use_Portal_Number = 1
			end
			local box = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100.0, 100.0), 0)
			local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer.WsCharacterData.Entity)
			local output = {}
			local hit = simulator:OverlapAllFast(CollisionGroups.MaplePortal, box, output)

			if hit > 0 then
				if(Unknown.Use_Portal_Number > hit) then Unknown.Use_Portal_Number = 1 end
				local moved = false
				while not moved and Unknown.Use_Portal_Number <= hit do
					local portal = output[Unknown.Use_Portal_Number]
					local portalId = portal.Entity.MaplePortalComponent.Tm
					local portalType = portal.Entity.MaplePortalComponent.Pt
					if tostring(portalId) ~= "m999999999" and (portalType == _PortalType.Visible or portalType == _PortalType.Invisible) then
						local Target_Position = portal.Entity.TransformComponent.WorldPosition
						local footholdComponent = _UserService.LocalPlayer.CurrentMap.FootholdComponent
						local nearestFoothold = footholdComponent:GetNearestFootholdByPoint(Vector2(Target_Position.x, Target_Position.y), 1)
						Target_Position.y = nearestFoothold:GetYByX(Target_Position.x)
						
						_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Vector2(Target_Position.x,Target_Position.y))
						_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[포탈이동] " .. Unknown.Use_Portal_Number .. "번 포탈로 이동했습니다.")
						moved = true
					end
					Unknown.Use_Portal_Number = Unknown.Use_Portal_Number + 1
					if Unknown.Use_Portal_Number > hit then
						Unknown.Use_Portal_Number = 1
					end
				end
			else
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[포탈이동] 포탈을 찾지 못했습니다.")
			end		
		elseif(KeyboardKey.Delete == key) then
			Unknown.Teleport_Mouse = not Unknown.Teleport_Mouse
			local strings = Unknown.Teleport_Mouse and "설정" or "해제"
			local color = Unknown.Teleport_Mouse and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[마우스박] " .. strings .. " 되었습니다.")
		elseif(KeyboardKey.PageUp == key) then
			local box = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100.0, 100.0), 0)
			local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer.WsCharacterData.Entity)
			local output = {}
			local hit = simulator:OverlapAllFast(CollisionGroups.MaplePortal, box, output)

			if hit > 0 then
				for _,portal in ipairs(output) do
					local portalId = portal.Entity.MaplePortalComponent.Tm
					for i,pt in ipairs(Unknown.PortalList) do
						if tostring(portalId) == pt.id then
							local Target_Position = portal.Entity.TransformComponent.WorldPosition
							local footholdComponent = _UserService.LocalPlayer.CurrentMap.FootholdComponent
							local nearestFoothold = footholdComponent:GetNearestFootholdByPoint(Vector2(Target_Position.x, Target_Position.y), 1)
							Target_Position.y = nearestFoothold:GetYByX(Target_Position.x)
							
							_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Vector2(Target_Position.x,Target_Position.y))
							_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[포탈이동] 잡화상점 포탈로 이동했습니다.")
							moved = true
							return
						end
					end
				end
			else
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[포탈이동] 포탈을 찾지 못했습니다.")
			end
		elseif(KeyboardKey.F9 == key) then
			Unknown.just_drop = not Unknown.just_drop
			if(not Unknown.Use_Auto)then
				_TimerService:ClearTimer(Unknown.auto_drop_timer)
				if(Unknown.just_drop)then
					Unknown.Drop_Time = _UtilLogic.ElapsedSeconds
					Unknown.auto_drop_timer = _TimerService:SetTimerRepeat(Unknown.drop_timer_func, 3)
				end
			end
			local strings = Unknown.just_drop and "설정" or "해제"
			local color = Unknown.just_drop and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[자동줍기] " .. strings .. " 되었습니다.")
		elseif(KeyboardKey.F10 == key) then
			if(Unknown.Use_Pos)then
				Unknown.move_position = _UserService.LocalPlayer.TransformComponent.WorldPosition
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키] 현재위치가 안전지대로 설정 되었습니다.")
			end
		elseif(KeyboardKey.F11 == key) then
			if(Unknown.Use_Pos)then
				Unknown.move_position = nil
				Unknown.hunt_position = nil
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[단축키] 좌표가 모두 초기화되었습니다.")
			end
		end
	end
end