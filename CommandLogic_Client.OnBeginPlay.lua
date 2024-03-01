return function (self) 
	Unknown = {}
	Unknown.Init = false
	Unknown.InitHack = function(self)
		if(not Unknown.Init)then
			Unknown.Init = true;
			
			-- 자동사냥관련
			Unknown.Use_Skill = false -- 자동 사냥(스킬)
			Unknown.Use_Normal = false -- 자동 사냥(평타)
			Unknown.Use_Skill_Id = 0 -- (스킬 아이디)
			Unknown._has_Skill = false -- 스킬(사용여부)
			Unknown._hunt_time = false -- 자사(사용여부)
			
			Unknown.Use_Auto = false -- 자사 여부
			Unknown.Use_attack_speed_Value = 4
			Unknown.Use_Auto_Distance = 0.5
			
			Unknown.Use_Pos = false -- 좌표 저장 시스템
			Unknown.move_position = nil -- 복귀 위치
			Unknown.hunt_position = nil -- 사냥 위치
			
			Unknown.Use_Hide = false -- 숨기 시스템
			Unknown.original_position = nil -- 복귀 위치
			
			Unknown.Use_LogOut = false -- 로그아웃 시스템
			
			Unknown.Use_Return = false -- 마을귀환 시스템
			
			Unknown.has_People = false
			Unknown._isLeftMove = false
			Unknown.Musi = false
			
			Unknown.Count_Mob = 0;
			Unknown.Drop_Time = 0
			
			-- 자동버프관련
			Unknown.Use_buff = false;
			Unknown.using_buff = false;
			Unknown.buff_ = 0
			
			-- 유틸기능관련
			Unknown.Use_setting_full = false
			Unknown.Use_auto_potion = false
			Unknown._has_Potion = false
			Unknown.Use_auto_feed = false
			Unknown.Use_stance = false
			Unknown.Use_no_breath = false
			Unknown.Use_attack_speed = false
			Unknown.Use_block_message = false
			Unknown.Use_auto_buy = false
			Unknown.Use_auto_sell = false
			Unknown.Use_Filter_Arrow = true;
			Unknown.Use_Filter_Etc = false;
			Unknown.Use_Filter_Equip = false
			Unknown.Use_Not_diffrent_User_Item = false;
			Unknown.Teleport_Mouse = false;
			Unknown.Use_Portal_Number = 1;
			Unknown.now_map = nil;
			Unknown.ToHome = false;
			Unknown.DetectInventory = false;
			Unknown.DetectInventory_2 = false;
			Unknown.Attack_Time = nil;
			Unknown.Avatar = nil;
			
			Unknown.Reset_All_Variable = function()
				-- 자동사냥관련
				Unknown.Use_Skill = false -- 자동 사냥(스킬)
				Unknown.Use_Normal = false -- 자동 사냥(평타)
				Unknown.Use_Skill_Id = 0 -- (스킬 아이디)
				Unknown._has_Skill = false -- 스킬(사용여부)
				Unknown._hunt_time = false -- 자사(사용여부)
				
				Unknown.Use_Auto = false -- 자사 여부
				Unknown.Use_attack_speed_Value = 4
				
				Unknown.Use_Pos = false -- 좌표 저장 시스템
				Unknown.move_position = nil -- 복귀 위치
				Unknown.hunt_position = nil -- 사냥 위치
				
				Unknown.Use_Hide = false -- 숨기 시스템
				Unknown.original_position = nil -- 복귀 위치
				
				Unknown.Use_LogOut = false -- 로그아웃 시스템
				
				Unknown.Use_Return = false -- 마을귀환 시스템
				
				Unknown.has_People = false
				Unknown._isLeftMove = false
				Unknown.Musi = false
				
				Unknown.Count_Mob = 0;
				Unknown.Drop_Time = 0
				
				-- 자동버프관련
				Unknown.Use_buff = false;
				Unknown.using_buff = false;
				Unknown.buff_ = 0
				
				-- 유틸기능관련
				Unknown.Use_setting_full = false
				Unknown.Use_auto_potion = false
				Unknown._has_Potion = false
				Unknown.Use_auto_feed = false
				Unknown.Use_stance = false
				Unknown.Use_no_breath = false
				Unknown.Use_attack_speed = false
				Unknown.Use_block_message = false
				Unknown.Use_auto_buy = false
				Unknown.Use_auto_sell = false
				Unknown.Use_Filter_Arrow = true;
				Unknown.Use_Filter_Etc = false;
				Unknown.Use_Filter_Equip = false
				Unknown.Use_Not_diffrent_User_Item = false;
				Unknown.Teleport_Mouse = false;
				Unknown.Use_Portal_Number = 1;
				Unknown.now_map = nil;
				Unknown.Attack_Time = nil;
				Unknown.Avatar = nil;
				Unknown.DetectInventory = false;
				Unknown.DetectInventory_2 = false;
				

				_UserService.LocalPlayer.RigidbodyComponent.IsQuaterViewMove = false
				
				if(Unknown.Play_timer ~= 0) then _TimerService:ClearTimer(Unknown.Play_timer) end
				if(Unknown.Hunt_timer ~= 0) then _TimerService:ClearTimer(Unknown.Hunt_timer) end
				if(Unknown.Move_timer ~= 0) then _TimerService:ClearTimer(Unknown.Move_timer) end
				if(Unknown.Hit_timer ~= 0) then _TimerService:ClearTimer(Unknown.Hit_timer) end
			end
			Unknown.filter_only_live_mobs = function (hit,temp,output) 
				if (hit > 0) then
					local count = 0
					for _,c in ipairs(temp) do
						---@type MobComponent
						local mob = c.Entity.MobComponent
						if (mob.DeadType ~= -1) then
							continue
						end
						count += 1
						output[#output + 1] = mob
					end
					if (count > 0) then
						return count
					end
				end
				return 0
			end

			Unknown.MovePosition = function(target)
				_UserService.LocalPlayer.MovementComponent:SetWorldPosition(target)
				_UserService.LocalPlayer.RigidbodyComponent:SetWorldPosition(target)
			end
			
			Unknown.Some_People = function()
				if(Unknown.hide_name or Unknown.Musi) then
					return false
				end
				local localUser = _UserService.LocalPlayer
				local party = _LocalPartyLogic.LocalParty
				if (party ~= nil) then
					local users = _UserService:GetUsersByMapName(_UserService.LocalPlayer.CurrentMapName)
					local count = #users
					for _,user in ipairs(users) do
						if (isvalid(user)) then
							if (_PartyLogic:IsLeaderMember(party, user.WsUser.CharacterId)) then
								count -= 1
							elseif (_PartyLogic:IsPartyMember(party, user.WsUser.CharacterId)) then
								count -= 1
							end
						end
					end
					return count > 0
				else
					local users = _UserService:GetUsersByMapName(_UserService.LocalPlayer.CurrentMapName)
					return #users ~= 1
				end
			end
			
			Unknown.PortalList2 = {
				{id = "m103000000",name="헤네시스"},
				{id = "m102000000",name="엘리니아"},
				{id = "m101000000",name="페리온"},
				{id = "m100000000",name="커닝시티"},
				{id = "m104000000",name="리스항구"},
				{id = "m105000000",name="리스항구"},
				{id = "m200000000",name="오르비스"},
				{id = "m211000100",name="엘나스 시장"},
				{id = "m220000000",name="루디브리엄"}
			}
			
			Unknown.PortalList = {
				{id = "m100000102",name="헤네시스 잡화상점"},
				{id = "m101000002",name="엘리니아 잡화상점"},
				{id = "m102000002",name="페리온 잡화상점"},
				{id = "m103000002",name="커닝시티 잡화상점"},
				{id = "m104000002",name="리스항구 잡화상점"},
				{id = "m105000010",name="슬리피우드 호텔로비"},
				{id = "m200000002",name="오르비스 잡화상점"},
				{id = "m211000102",name="엘나스 잡화상점"},
				{id = "m220000002",name="루디브리엄 잡화상점"}
			}
			
			local hpPotions = {
				{id = 2000000, name = "빨간 포션", description = "붉은 약초로 만든 물약이다.\nHP를 약 50 회복시킨다."},
				{id = 2000001, name = "주황 포션", description = "붉은 약초의 농축 물약이다.\nHP를 약 150 회복시킨다."},
				{id = 2000002, name = "하얀 포션", description = "붉은 약초의 고농축 물약이다.\nHP를 약 300 회복시킨다."},
				{id = 2000015, name = "빨간 포션", description = "붉은 약초로 만든 물약이다.\nHP를 약 50 회복시킨다."},
				{id = 2000016, name = "주황 포션", description = "붉은 약초의 농축 물약이다.\nHP를 약 150 회복시킨다."},
				{id = 2000017, name = "하얀 포션", description = "붉은 약초의 고농축 물약이다.\nHP를 약 300 회복시킨다."},
				{id = 2001500, name = "빨간 포션", description = "붉은 약초로 만든 물약이다.\nHP를 약 50 회복시킨다."},
				{id = 2001501, name = "주황 포션", description = "붉은 약초의 농축 물약이다.\nHP를 약 150 회복시킨다."},
				{id = 2001502, name = "하얀 포션", description = "붉은 약초의 고농축 물약이다.\nHP를 약 300 회복시킨다."},
				{id = 2001527, name = "장어 구이", description = "잘 양념된 장어 구이이다.\nHP를 약 1000 회복시켜 준다."},
				{id = 2022003, name = "장어 구이", description = "잘 양념된 장어 구이이다.\nHP를 약 1000 회복시켜 준다."},
				{id = 2020001, name = "통닭", description = "닭고기를 잘 튀긴 음식이다.\nHP를 약 200 회복시킨다."},
				{id = 2020002, name = "케이크", description = "달콤한 크림의 케이크이다. HP를 약 100 회복시키며 MP를 약 100 회복시킨다."},
				{id = 2020003, name = "피자", description = "갓 구워낸 피자이다. HP를 약 400 회복시킨다."},
				{id = 2020004, name = "햄버거", description = "불고기가 들어간 햄버거이다. HP를 약 400 회복시킨다."},
				{id = 2020005, name = "길쭉이 핫도그", description = "케첩이 뿌려진 핫도그이다. HP를 약 300 회복시킨다."},
				{id = 2020006, name = "뚱뚱이 핫도그", description = "푸짐한 미국식 핫도그이다. HP를 약 500 회복시킨다."}
			}
			local mpPotions = {
				{id = 2000003, name = "파란 포션", description = "푸른 약초로 만든 물약이다.\nMP를 약 100 회복시킨다."},
				{id = 2000006, name = "마나 엘릭서", description = "전설의 비약이다.\nMP를 약 300 회복시킨다."},
				{id = 2000017, name = "파란 포션", description = "푸른 약초로 만든 물약이다.\nMP를 약 100 회복시킨다."},
				{id = 2000018, name = "마나 엘릭서", description = "전설의 비약이다.\nMP를 약 300 회복시킨다."},
				{id = 2001503, name = "파란 포션", description = "푸른 약초로 만든 물약이다.\nMP를 약 100 회복시킨다."},
				{id = 2001506, name = "마나 엘릭서", description = "전설의 비약이다.\nMP를 약 300 회복시킨다."},
				{id = 2001526, name = "맑은 물", description = "매우 깨끗한 물이다.\nMP를 약 800 회복시킨다."},
				{id = 2020000, name = "샐러드", description = "신선한 야채로 만든 음식이다.\nMP를 약 200 회복시킨다."},
				{id = 2020002, name = "케이크", description = "달콤한 크림의 케이크이다. HP를 약 100 회복시키며 MP를 약 100 회복시킨다."},
				{id = 2022000, name = "맑은 물", description = "매우 깨끗한 물이다.\nMP를 약 800 회복시킨다."},
				{id = 2001514, name = "팥빙수", description = "매우 깨끗한 물이다.\nMP를 약 800 회복시킨다."},
				{id = 2001535, name = "레몬", description = "매우 신 과일이다.\nMP를 약 150 회복시킨다."},
				{id = 2001002, name = "팥빙수", description = "매우 깨끗한 물이다.\nMP를 약 800 회복시킨다."}
			}
			
			function getPercentage(current, max)
				return (current / max) * 100
			end
			
			Unknown.auto_potion_func = function(self)
				if(Unknown.Use_auto_potion) then
					local hp = _UserService.LocalPlayer.WsUser.Hp
					local maxHp = _UserService.LocalPlayer.WsUser.MaxHp
					if getPercentage(hp, maxHp) < 40 then
						for _, potion in ipairs(hpPotions) do
							_ItemConsumeLogic:TryConsumeFromFuncKey(potion.id)
						end
					end
					local mp = _UserService.LocalPlayer.WsUser.Mp
					local maxMp = _UserService.LocalPlayer.WsUser.MaxMp
					if getPercentage(mp, maxMp) < 30 then
						for _, potion in ipairs(mpPotions) do
							_ItemConsumeLogic:TryConsumeFromFuncKey(potion.id)
						end
					end
				end
			end
			Unknown.auto_feed_func = function(self)
				if isvalid(_UserService.LocalPlayer.PetOwnerComponent.Pet) then
					petRepleteness = _UserService.LocalPlayer.PetOwnerComponent.Pet.PetComponent.Repleteness
					if petRepleteness <= 50 then
						_ItemConsumeLogic:TryConsumeFromFuncKey(2120000)
						_ItemConsumeLogic:TryConsumeFromFuncKey(2120008)
					end
				end
			end
			
			
			Unknown.calculateDistance = function(pos1, pos2)
				local dx = pos1.x - pos2.x
				local dy = pos1.y - pos2.y
				return math.sqrt(dx*dx + dy*dy)
			end

			Unknown.Auto_Aggro_Func_Close = function(self)
				local box = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100.0, 100.0), 0) --> i think 0 still god cuzof size
				local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer) --> if not working, lets put map's one
				local temp = {}
				local output = {}
				local hit = simulator:OverlapAllFast(CollisionGroups.MapleMob, box, temp)
				Unknown.Count_Mob = Unknown.filter_only_live_mobs(hit, temp, output)
				
				for i,v in ipairs(output) do
					local mob = v.Entity
					mob.MobAIComponent:SetControlling(false)
					mob.MobAIComponent:EnableNextControlTimer(1)
					mob.MobAIComponent.Target = nil
				end
			end
			
			Unknown.Auto_Aggro_Func = function(self)
				if (Unknown.Use_Normal or Unknown.Use_Skill) and not Unknown.Some_People() then
					local box = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100.0, 100.0), 0) --> i think 0 still god cuzof size
					local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer) --> if not working, lets put map's one
					local temp = {}
					local output = {}
					local hit = simulator:OverlapAllFast(CollisionGroups.MapleMob, box, temp)
					Unknown.mob_count = Unknown.filter_only_live_mobs(hit, temp, output)
					
					for i,v in ipairs(output) do
						local mob = v.Entity
						local ai = mob.MobAIComponent
						local mobId = mob.MobComponent.MobTemplateID
						local moveAbility = mob.MobComponent:GetMoveAbility()
						
						if(moveAbility == _MoveAbility.Fly)then
							pcall(function() Unknown.Flying(mob) end)
						elseif(moveAbility == _MoveAbility.Walk or moveAbility == _MoveAbility.Jump)then
							pcall(function() Unknown.JumpMove(mob,mobId) end)
						end
					end
				end
			end
			
			Unknown.Flying = function(mob)
				local kb = mob.MobKnockbackComponent
				local ai = mob.MobAIComponent
				local rb = mob.MobRigidbodyComponent
				
				local map = mob.CurrentMap
				local boundLt, boundRb = map.MapComponent:GetBound()
				local minX = boundLt.x + 0.1
				local maxX = boundRb.x - 0.1
				local mobPos = mob.TransformComponent.WorldPosition:ToVector2()
				local sqrt = math.sqrt
				
				local timelines = {}
				local timelineIndex = 0
				local currentX = mobPos.x
				local currentY = mobPos.y
				
				local function makeDistance(x1, y1, x2, y2)
					return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
				end
				
				kb:SetShoeAttr(2)
				local knockbackSpeed = rb.WalkSpeed * _Physics.FlySpeed / 1
				
				local function makeFlyCommand(cmd, destX, destY, floating)
					local distance = makeDistance(currentX, currentY, destX, destY) 
					currentX = destX
					currentY = destY
					local duration = distance / knockbackSpeed
					timelines[timelineIndex + 1] = {cmd, {destX, destY, duration, floating}, 0}
					timelineIndex += 1
					return duration
				end
				
				local TargetX =  _UserService.LocalPlayer.TransformComponent.WorldPosition.x
				local TargetY =  _UserService.LocalPlayer.TransformComponent.WorldPosition.y
				local DirX = (_UserService.LocalPlayer.PlayerControllerComponent.LookDirectionX < 0 and -1 or 1)
				DirX = DirX * Unknown.Use_Auto_Distance
				local knockbackDestX = math.min(maxX, TargetX + DirX)
				
				if (mobPos.x ~= knockbackDestX) then
					makeFlyCommand(_MobActionPartType.KnockbackFly, knockbackDestX, TargetY , false)
				end
				
				if (timelineIndex > 0) then
					ai:ControlCommands(timelines,timelineIndex,true)
				end
			end
			Unknown.JumpMove = function(mob,mobId)
				local ai = mob.MobAIComponent
				local kb = mob.MobKnockbackComponent
				local rb = mob.MobRigidbodyComponent

				local now = _UtilLogic.ServerElapsedSeconds
				if (now < ai.NextActionTime) then
					ai:EnableNextControlTimer(math.max(ai.NextActionTime - now, 0) + 0.1)
					return
				end
				kb:SetShoeAttr(2)

				local target = _UserService.LocalPlayer
				local targetX = target.TransformComponent.WorldPosition.x
				local DirX = (_UserService.LocalPlayer.PlayerControllerComponent.LookDirectionX < 0 and -1 or 1)
				DirX = DirX * Unknown.Use_Auto_Distance
				targetX = targetX + DirX
				local targetY = target.TransformComponent.WorldPosition.y
				local nextAction = 0.1
				local newInputX = nil
				local mobX = mob.TransformComponent.WorldPosition.x
				if math.abs(targetX - mobX) > 6 then
					newInputX = targetX > mobX and 3 or -3
				else
					newInputX = math.max(targetX - mobX, -3)
				end
				local timelines = {}
				local timelineIndex = 0
				local lastTimeline = 0
				
				local function makeCommand(cmd, value, timeline, nextActionTime)
					timelines[timelineIndex + 1] = {cmd, value, timeline - lastTimeline, nextActionTime}
					timelineIndex += 1
					lastTimeline = timeline
				end
				local function makeCommand2(cmd, value, timeline, val2)
					timelines[timelineIndex + 1] = {cmd, value, timeline - lastTimeline, val2}
					timelineIndex += 1
					lastTimeline = timeline
				end
				
				local mobY = mob.TransformComponent.WorldPosition.y
				local gapX = math.abs(mobX - targetX)
				local gapY = math.abs(mobY - targetY)
				if gapX > 3 then
					makeCommand(_MobActionPartType.Move, newInputX, 0, nextAction)
					makeCommand(_MobActionPartType.Jump, 1, 0)
				elseif gapY > 0.8 then
					makeCommand(_MobActionPartType.Move, newInputX, 0, nextAction)
					makeCommand(_MobActionPartType.Jump, -1, 0)
				elseif gapX < 0.12 then
					makeCommand(_MobActionPartType.Move, 0, 0, 10)
				else
					makeCommand(_MobActionPartType.Move, newInputX, 0, nextAction)
				end
				

				if (timelineIndex > 0) then
					ai:ControlCommands(timelines,timelineIndex,true)
				end
			end

			Unknown.Auto_Hunt_Func = function(self)
				-- if Unknown.is_someone_in_world_real()then return end
				-- if(Unknown._drop_time)then return end
				if(Unknown._hunt_time)then return end
				Unknown._hunt_time = true
				local player_pos = _UserService.LocalPlayer.TransformComponent.WorldPosition
				local output = {}
				local distanceTable = {}
				local box = BoxShape(player_pos:ToVector2(), Vector2(100.0, 100.0), 0) --> i think 0 still god cuzof size
				local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer) 
				local temp = {}
				local hit = simulator:OverlapAllFast(CollisionGroups.MapleMob, box, temp)
				local count = Unknown.filter_only_live_mobs(hit, temp, output)

				for _, mob in ipairs(output) do
					if(not isvalid(mob))then continue end
					local mob_pos = mob.Entity.TransformComponent.WorldPosition
					local InputX = 0.5
					local DirX = tonumber(_UserService.LocalPlayer.PlayerControllerComponent.LookDirectionX * InputX)
					local Target_Position = Vector3(mob_pos.x - DirX,mob_pos.y,0)
					local dist = Vector3.Distance(player_pos, Target_Position)
					table.insert(distanceTable, {mob = mob, distance = dist})
				end
				table.sort(distanceTable, function(a, b) return a.distance < b.distance end)
				if #distanceTable > 0 then
					local closest_mob = nil
					if(Unknown.hide_name or Unknown.Musi) then
						closest_mob = distanceTable[_GlobalRand32:RandomIntegerRange(1, #distanceTable)].mob
					else
						closest_mob = distanceTable[1].mob
					end
					while closest_mob.Entity.MobComponent.DeadType == -1 and (Unknown.Use_Normal or Unknown.Use_Skill) and not Unknown.Some_People() do
						local mob_pos = closest_mob.Entity.TransformComponent.WorldPosition:ToVector2()
						local InputX = Unknown.Use_Auto_Distance
						local DirX = tonumber(_UserService.LocalPlayer.PlayerControllerComponent.LookDirectionX * InputX)
						local closest_target = Vector2(mob_pos.x - DirX,mob_pos.y)
						pcall(function() Unknown.MovePosition(closest_target) end)
						wait(0.016)
						-- if(Unknown._drop_time) then break end
					end
				end
				if(Unknown.just_drop and not Unknown.Some_People()) then
					_TimerService:SetTimerOnce(Unknown.drop_func,0.5)
				end
				Unknown._hunt_time = false
			end
			
			Unknown.Hide_timer_func = function(self)
				if Unknown.Some_People()then
					if(Unknown.Use_Normal or Unknown.Use_Skill)then
						local map = _UserService.LocalPlayer.CurrentMap
						local boundLt, boundRb = map.MapComponent:GetBound()
						local maxY = boundRb.y + 2
						Unknown.MovePosition(Vector2(0,maxY))
					end
				end
			end
			
			Unknown.Play_func = function(self)
				if(Unknown.hide_name) then
					return
				end
				if(Unknown.Use_Pos)then
					if Unknown.Some_People()then
						if(Unknown.Use_Normal or Unknown.Use_Skill)then
							if(not Unknown.has_People) then
								_TimerService:ClearTimer(Unknown.Hunt_timer)
								_TimerService:ClearTimer(Unknown.Hit_timer)
								_TimerService:ClearTimer(Unknown.Move_timer)
								-- _TimerService:ClearTimer(Unknown.drop_timer_func)
								if(Unknown.Use_buff) then
									_TimerService:ClearTimer(Unknown.auto_buff_timer)
								end
								_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.move_position:ToVector2())
								Unknown.has_People = true
								wait(0.3)
								Unknown.Exigent_Func()
								_ChatMessageLogic:Add(_ChatMessageType.Creator, "[시스템] 유저가 발견되어 안전지대로 이동합니다.")
							end
						end
					else
						if(Unknown.Use_Normal or Unknown.Use_Skill)then
							if(Unknown.has_People)then
								_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.hunt_position:ToVector2())
								if(not Unknown.Use_Auto)then
									Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Aggro_Func, 0.1)
									Unknown.Move_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Move_func, 20,20)
								else
									Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Hunt_Func, 0.33)
								end
								Unknown.Attack_Time = _UtilLogic.ElapsedSeconds
								Unknown.Hit_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Attack_func, 0.01,0.15)
								if(Unknown.just_drop)then
									Unknown.Drop_Time = _UtilLogic.ElapsedSeconds
									Unknown.auto_drop_timer = _TimerService:SetTimerRepeat(Unknown.drop_timer_func, 3)
								end
								if(Unknown.Use_buff) then
									Unknown.auto_buff_timer = _TimerService:SetTimerRepeat(Unknown.buff_timer_func, 1)
								end
								Unknown.has_People = false
								_ChatMessageLogic:Add(_ChatMessageType.Creator, "[시스템] 다시 사냥을 시작합니다.")
							end
						end
					end
				elseif(Unknown.Use_Hide)then
					if Unknown.Some_People()then
						if(Unknown.Use_Normal or Unknown.Use_Skill)then
							if(not Unknown.has_People) then
								_TimerService:ClearTimer(Unknown.Hunt_timer)
								_TimerService:ClearTimer(Unknown.Hit_timer)
								_TimerService:ClearTimer(Unknown.Move_timer)
								-- _TimerService:ClearTimer(Unknown.drop_timer_func)
								if(Unknown.Use_buff) then
									_TimerService:ClearTimer(Unknown.auto_buff_timer)
								end
								Unknown.original_position = _UserService.LocalPlayer.TransformComponent.WorldPosition
								_TimerService:SetTimerOnce(Unknown.Exigent_Func)
								Unknown.HideTimer = _TimerService:SetTimerRepeat(Unknown.Hide_timer_func,0.016)
								Unknown.has_People = true
								_ChatMessageLogic:Add(_ChatMessageType.Creator, "[시스템] 유저가 발견되어 안전지대로 이동합니다.")
							end
						end
					else
						if(Unknown.Use_Normal or Unknown.Use_Skill)then
							if(Unknown.has_People)then
								_TimerService:ClearTimer(Unknown.HideTimer)
								_UserService.LocalPlayer.MovementComponent:SetWorldPosition(Unknown.original_position:ToVector2())
								if(not Unknown.Use_Auto)then
									Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Aggro_Func, 0.1)
									Unknown.Move_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Move_func, 20,20)
								else
									Unknown.Hunt_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Hunt_Func, 0.33)
								end
								Unknown.Attack_Time = _UtilLogic.ElapsedSeconds
								Unknown.Hit_timer = _TimerService:SetTimerRepeat(Unknown.Auto_Attack_func, 0.01,0.15)
								if(Unknown.just_drop)then
									Unknown.Drop_Time = _UtilLogic.ElapsedSeconds
									Unknown.auto_drop_timer = _TimerService:SetTimerRepeat(Unknown.drop_timer_func, 3)
								end
								if(Unknown.Use_buff) then
									Unknown.auto_buff_timer = _TimerService:SetTimerRepeat(Unknown.buff_timer_func, 1)
								end
								Unknown.has_People = false
								_ChatMessageLogic:Add(_ChatMessageType.Creator, "[시스템] 다시 사냥을 시작합니다.")
							end
						end
					end
				else
					if Unknown.Some_People() then
						if (Unknown.Use_Normal or Unknown.Use_Skill) and Unknown.Use_LogOut then
							_TimerService:ClearTimer(Unknown.Hunt_timer)
							_TimerService:ClearTimer(Unknown.Hit_timer)
							_TimerService:ClearTimer(Unknown.Move_timer)
							_TimerService:ClearTimer(Unknown.drop_timer_func)
							if(Unknown.Use_buff) then
								_TimerService:ClearTimer(Unknown.auto_buff_timer)
							end
							_ChatMessageLogic:Add(_ChatMessageType.Red, "[감지 시스템] 사람이 감지되어 로그아웃합니다.\n설정이 모두 초기화 됩니다.")
							_TimerService:SetTimerOnce(Unknown.Exigent_Func)
							_UserService.LocalPlayer.WsUserConsistencyComponent:Logout()
							_TimerService:ClearTimer(Unknown.Play_timer)
							return
						elseif (Unknown.Use_Normal or Unknown.Use_Skill) and Unknown.Use_Return then
							_TimerService:ClearTimer(Unknown.Hunt_timer)
							_TimerService:ClearTimer(Unknown.Hit_timer)
							_TimerService:ClearTimer(Unknown.Move_timer)
							_TimerService:ClearTimer(Unknown.drop_timer_func)
							if(Unknown.Use_buff) then
								_TimerService:ClearTimer(Unknown.auto_buff_timer)
							end
							_ChatMessageLogic:Add(_ChatMessageType.Red, "[감지 시스템] 사람이 감지되어 마을로 귀환했습니다.\n설정이 모두 초기화 됩니다.")
							_TimerService:SetTimerOnce(Unknown.Exigent_Func)
							_ItemConsumeLogic:TryConsumeFromFuncKey(2030000)
							return
						else
							_ChatMessageLogic:Add(_ChatMessageType.Red, "[감지 시스템] 사람이 감지되었습니다... 기능이 설정되지 않았습니다..")
							-- _TimerService:SetTimerOnce(Unknown.Exigent_Func)
						end
					end
				end
			end
			
			
			-- Unknown.drop_timer_func = function(self)
				-- local time = _UtilLogic.ElapsedSeconds
				-- if (time - Unknown.Drop_Time) > 10 and not Unknown._drop_time then
					-- Unknown._drop_time = true
					-- Unknown.Drop_Time = time
					-- if(Unknown.Use_Normal or Unknown.Use_Skill)then
					-- if(Unknown.Some_People()) then return end
					-- local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer)
					-- local shape = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100,100), 0)
					-- local tb = {}
					-- local count = simulator:OverlapAllFast(CollisionGroups.MapleDrop, shape, tb)
					-- if (count == 0) then
						-- Unknown._drop_time = false
						-- return
					-- end
					-- local tempMove_position = _UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2()
					-- for i,drop in pairs(tb) do
						-- local d = drop.Entity.DropComponent
						-- if (_ItemDropLogic:CheckDropOwner(d.OwnType, d.OwnId, d.CreateTime, _UserService.LocalPlayer, false) and isvalid(d.SpriteEntity)) then
							-- Unknown.MovePosition(d.Position:ToVector2())
							-- wait(0.2)
						-- end
					-- end
					-- Unknown.MovePosition(tempMove_position)
					-- Unknown._drop_time = false
					-- end
				-- elseif (time - Unknown.Drop_Time) > 5 and Unknown._drop_time then
					-- Unknown._drop_time = false
				-- end
			-- end			
			Unknown.drop_func = function(self)
				if(Unknown.Some_People()) then return end
				local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer)
				local shape = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100,100), 0)
				local tb = {}
				local count = simulator:OverlapAllFast(CollisionGroups.MapleDrop, shape, tb)
				if (count == 0) then
					return
				end
				local tempMove_position = _UserService.LocalPlayer.TransformComponent.WorldPosition
				for _,drop in pairs(tb) do
					local d = drop.Entity.DropComponent
					if (isvalid(d.SpriteEntity)) then
						pcall(function() Unknown.MovePosition(d.Position:ToVector2());_UserService.LocalPlayer.WsUserController:TryPick(d) end)
					end
				end
				_UserService.LocalPlayer.MovementComponent:SetWorldPosition(tempMove_position:ToVector2())
			end
			
			Unknown.drop_timer_func = function(self)
				if(Unknown.Some_People()) then return end
				local time = _UtilLogic.ElapsedSeconds
				if (time - Unknown.Drop_Time) >= 3 then
					local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer)
					local shape = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100,100), 0)
					local tb = {}
					local count = simulator:OverlapAllFast(CollisionGroups.MapleDrop, shape, tb)
					if (count == 0) then
						return
					end
					local tempMove_position = _UserService.LocalPlayer.TransformComponent.WorldPosition
					local index = 0
					for _,drop in pairs(tb) do
						local d = drop.Entity.DropComponent
						if (isvalid(d.SpriteEntity)) then
							pcall(function() Unknown.MovePosition(d.Position:ToVector2());_UserService.LocalPlayer.WsUserController:TryPick(d) end)
							index += 1
						end
					end
					if(index > 0)then
						_UserService.LocalPlayer.MovementComponent:SetWorldPosition(tempMove_position:ToVector2())
					end
				end
			end
			
			Unknown.Exigent_Func = function(self) -- (유저 출현)긴급할때 드랍템 먹는 함수
				local simulator = _CollisionService:GetSimulator(_UserService.LocalPlayer)
				local shape = BoxShape(_UserService.LocalPlayer.TransformComponent.WorldPosition:ToVector2(), Vector2(100,100), 0)
				local tb = {}
				local count = simulator:OverlapAllFast(CollisionGroups.MapleDrop, shape, tb)
				if (count == 0) then
					return
				end
				local tempMove_position = _UserService.LocalPlayer.TransformComponent.WorldPosition
				for _,drop in pairs(tb) do
					local d = drop.Entity.DropComponent
					if (isvalid(d.SpriteEntity)) then
						pcall(function() Unknown.MovePosition(d.Position:ToVector2());_UserService.LocalPlayer.WsUserController:TryPick(d) end)
					end
				end
				_UserService.LocalPlayer.MovementComponent:SetWorldPosition(tempMove_position:ToVector2())
			end	

			function SendKeyInput(key)
				local evt = KeyDownEvent()
				evt.key = key
				_InputService:SendEvent(evt)

				local evt2 = KeyUpEvent();
				evt2.key = key
				_InputService:SendEvent(evt2)
			end
			function SendKeyDown(key)
				local evt = KeyDownEvent()
				evt.key = key
				_InputService:SendEvent(evt)
			end
			
			Unknown.Attack_Func = function(self)
				if (Unknown.Use_Skill) then
					if not Unknown._has_skill then
						_PlayerActiveSkillLogic:DoActiveSkill(Unknown.Use_Skill_Id, false)
					end
				elseif (Unknown.Use_Normal) then
					local user = _UserService.LocalPlayer
					local shootAttack = _PlayerAttackLogic:CheckAvailableShootAttack(user, 0, 0)
					if (shootAttack) then
						_PlayerAttackLogic_Shoot:TryDoingShootAttack(user, 0, 0, 0)
					else
						_PlayerAttackLogic_Melee:TryDoingMeleeAttack(user, 0, 0, nil, 0)
					end
				end
			end
			
			Unknown.Auto_Attack_func = function(self)
				if Unknown.Some_People() then return end
				if Unknown.using_buff then return end
				if Unknown._drop_time then return end
				local time = _UtilLogic.ElapsedSeconds
				if (time - Unknown.Attack_Time) >= ((_UserService.LocalPlayer.CharacterActionComponent:GetWeaponAttackSpeed(false) + 10) / 16) then
					Unknown.Attack_Time = time
					_TimerService:SetTimerOnce(Unknown.Attack_Func)
				end	
			end
			
			Unknown.Auto_Move_func = function(self)
				if Unknown.Some_People() then 
					return
				end
				Unknown._isLeftMove = not Unknown._isLeftMove
				if(Unknown._isLeftMove)then
					_UserService.LocalPlayer.MovementComponent:SetWorldPosition((_UserService.LocalPlayer.TransformComponent.WorldPosition + Vector3(0.1,0.5,0)):ToVector2())
				else
					_UserService.LocalPlayer.MovementComponent:SetWorldPosition((_UserService.LocalPlayer.TransformComponent.WorldPosition - Vector3(0.1,-0.5,0)):ToVector2())
				end
			end


			Unknown.name_timer_func = function(self)
				if(Unknown.hide_name)then
					_UserService.LocalPlayer.NameTagComponent.Enable = false
					_UserService.LocalPlayer.TouchReceiveComponent.Enable = false
					-- _UserService.LocalPlayer.WsUser.CharacterName = ""
					-- _UserService.LocalPlayer.WsUser.CharacterId = ""
					_UserService.LocalPlayer.AvatarRendererComponent.Enable = false
					_UserService.LocalPlayer.MiniMapComponent.Enable = false
				end
			end
			
			Unknown.Buff_timer_func = function(self)
				if Unknown.Some_People() then return end
				if (Unknown.Use_buff) then
					local user = _UserService.LocalPlayer
					local cd = user.WsCharacterData
					local job = _Jobs:GetJobClass(cd.Job)
					if (job == 2) then
						if (Unknown.buff_ > 0) then Unknown.buff_ -= 1 end
						if(Unknown.buff_ < 5 and not Unknown.using_buff)then
							local SkillID = tonumber((cd.Job * 10000) + 1001)
							local slv = cd:GetSkillLevel(SkillID)
							Unknown.buff_ = slv * 10
							Unknown.using_buff = true
							wait(2)
							_PlayerActiveSkillLogic:DoActiveSkill(SkillID, false)
							wait(1)
							Unknown.using_buff = false
							return
						end
					elseif (cd.Job == 110) then
						if (Unknown.buff_ > 0) then Unknown.buff_ -= 1 end
						if(Unknown.buff_ < 5 and not Unknown.using_buff)then
							local SkillID = 1101006
							local slv = cd:GetSkillLevel(SkillID)
							Unknown.buff_ = slv * 10
							Unknown.using_buff = true
							wait(2)
							_PlayerActiveSkillLogic:DoActiveSkill(SkillID, false)
							wait(1)
							Unknown.using_buff = false
							return
						end
					end
				end
			end
			_ChatMessageLogic:Add(_ChatMessageType.Creator, "[Unknown] 정상적으로 로드되었습니다.")
		end
	end
	---------------- Unknown ----------------

self.ClientCommands = {
	["도움말"] = self.Help,
	["교환"] = self.Trade,
	["게임교환"] = self.Trade,
	["모두"] = self.ToAll,
	["파티"] = self.ToParty,
	["채널"] = self.ToChannel,
	["귓말"] = self.ToWhisper,
	["귓"] = self.ToWhisper,
	["찾기"] = self.Find,
	["파티만들기"] = self.CreateParty,
	["파티탈퇴"] = self.LeaveParty,
	["파티초대"] = self.InviteParty,
	["파티강퇴"] = self.KickParty,
	["펫"] = self.PetChat,

	------------------------------------------------- Unknown -------------------------------------------------
	["?"] = function(self)
		if(Unknown.Init)then
			local message = ("%s"):format(
			[[
			----------------- 명령어 -----------------
			[사냥]
				F1 => 스킬							F7  	=> 모드 변경							F9  	=> 	자동 줍기
				F2 => 평타							PageUp  => 잡화상점 텔포				F10 	=>	안전지대
				F3 => 세팅							PageDown=> 포탈 텔포					F11 	=>	안전지대 초기화
				F4 => 자동 버프					Delete 	=> 마우스박
			[기타]
				/자사								/리셋 {모든 기능 초기화}						/접속 {로그아웃}
				/귀환 {마을귀환} 			/채팅삭제 												/필터 {기타,화살,장비,남템}
				/공속								/위치 {위치시스템} 								/하이드
				/메소 [횟수] {50000x횟수 드랍}	/무시 {사람 있어도 작동} 		/줍기	
				/인벤토리 {귀환,필터} 					/거리조정 [숫자] {숫자만큼 몹몰이/자사 거리를 조정합니다.}
				세팅 기능은 다음과 같습니다.
				자동포션, 자동펫먹이, 확성제거, 노숨, 공속, 스탠스, 자동구매, 자동판매, 피굳
				자동판매 -> 상점에서 아이템팔때 확인창이 뜨지않습니다.
				자동구매 -> 상점에서 아이템살때 최대치로삽니다. (주의하세요)
			----------------------------------------]]
			)
			_ChatMessageLogic:Add(_ChatMessageType.Creator, message)
		end
	end,
	["채팅삭제"] = function(self)
		if(Unknown.Init)then
			_AppService:Get().ChatSystem.ChatLog:ClearChatLogs()
		end
	end,
	["메소"] = function(self,user,argc,args)
		if(Unknown.Init)then
			if(args[2] == "") then 
				_ChatMessageLogic:Add(_ChatMessageType.Creator, "/메소 [횟수]")
				return 
			end
			if((tonumber(args[2]) * 50000) > _UserService.LocalPlayer.WsCharacterData.Money ) then 
				local needMoney = (tonumber(args[2]) * 50000) - _UserService.LocalPlayer.WsCharacterData.Money
				_ChatMessageLogic:Add(_ChatMessageType.Creator, "금액이 부족합니다. " .. needMoney .. " 메소")
				return
			end
			for i=1,tonumber(args[2]) do
				_InventoryLogic:TryDropMoney( _UserService.LocalPlayer, 50000)
				wait(0.05)
			end
			_ChatMessageLogic:Add(_ChatMessageType.Creator, "드랍완료.")
		end
	end,
	
	["필터"] = function(self,user,argc,args)
		if(Unknown.Init)then
			local strings = nil
			if(args[2] == "화살") then
				Unknown.Use_Filter_Arrow = not Unknown.Use_Filter_Arrow
				strings = Unknown.Use_Filter_Arrow and "활성화" or "비활성화"
				local color = Unknown.Use_Filter_Arrow and _ChatMessageType.Yellow or _ChatMessageType.Red
				_ChatMessageLogic:Add(color, "[드랍 필터] 화살 필터 " .. strings .. " 되었습니다.")
			elseif(args[2] == "기타") then
				Unknown.Use_Filter_Etc = not Unknown.Use_Filter_Etc
				strings = Unknown.Use_Filter_Etc and "활성화" or "비활성화"
				local color = Unknown.Use_Filter_Etc and _ChatMessageType.Yellow or _ChatMessageType.Red
				_ChatMessageLogic:Add(color, "[드랍 필터] 기타 필터 " .. strings .. " 되었습니다.")		
			elseif(args[2] == "장비") then
				Unknown.Use_Filter_Equip = not Unknown.Use_Filter_Equip
				strings = Unknown.Use_Filter_Equip and "활성화" or "비활성화"
				local color = Unknown.Use_Filter_Equip and _ChatMessageType.Yellow or _ChatMessageType.Red
				_ChatMessageLogic:Add(color, "[드랍 필터] 장비 필터 " .. strings .. " 되었습니다.")
			elseif(args[2] == "남템") then
				Unknown.Use_Not_diffrent_User_Item = not Unknown.Use_Not_diffrent_User_Item
				local strings = Unknown.Use_Not_diffrent_User_Item and "설정" or "해제"
				local color = Unknown.Use_Not_diffrent_User_Item and _ChatMessageType.Yellow or _ChatMessageType.Red
				_ChatMessageLogic:Add(color, "[드랍 필터] 남템 필터 " .. strings .. " 되었습니다.")
			end
		end
	end,
	
	["위치"] = function(self)
		if(Unknown.Init)then
			if(Unknown.Use_Hide) then _ChatMessageLogic:Add(_ChatMessageType.Blue, "[감지 시스템] 이미 숨기가 설정 되어 있습니다.") return end
			Unknown.Use_Pos = not Unknown.Use_Pos
			local strings = Unknown.Use_Pos and "설정" or "설정해제"
			local color = Unknown.Use_Pos and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[좌표 시스템] 사용 " .. strings .. " 되었습니다.")
		end
	end,
	
	["자사"] = function(self)
		if(Unknown.Init)then
			Unknown.Use_Auto = not Unknown.Use_Auto
			local strings = Unknown.Use_Auto and "설정" or "설정해제"
			local color = Unknown.Use_Auto and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[자사] 사용" .. strings .. " 되었습니다.")
		end
	end,
	
	["거리조정"] = function(self,user,argc,args)
		if(Unknown.Init)then
			if(args[2] ~= nil)then
				Unknown.Use_Auto_Distance = tonumber(args[2])
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[공통] 거리가 "..Unknown.Use_Auto_Distance.."로 조정 되었습니다.")
			else
				_ChatMessageLogic:Add(_ChatMessageType.Yellow, "[공통] 거리는 숫자로 입력해주세요.")
			end
		end
	end,
	
	["접속"] = function(self)
		if(Unknown.Init)then
			if(Unknown.Use_Return) then _ChatMessageLogic:Add(_ChatMessageType.Blue, "[감지 시스템] 이미 귀환이 설정 되어 있습니다.") return end
			Unknown.Use_LogOut = not Unknown.Use_LogOut
			Unknown.ignore_people = not Unknown.ignore_people
			local strings = Unknown.Use_LogOut and "설정" or "설정해제"
			local color = Unknown.Use_LogOut and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[감지 시스템] 로그아웃이 " .. strings .. " 되었습니다.")
		end
	end,
	["숨기"] = function(self)
		if(Unknown.Init)then
			if(Unknown.Use_Pos) then _ChatMessageLogic:Add(_ChatMessageType.Blue, "[감지 시스템] 이미 위치가 설정 되어 있습니다.") return end
			Unknown.Use_Hide = not Unknown.Use_Hide
			local strings = Unknown.Use_Hide and "설정" or "설정해제"
			local color = Unknown.Use_Hide and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[감지 시스템] 숨기시스템이 " .. strings .. " 되었습니다.")
		end
	end,
	["logout"] = function(self)
		if(Unknown.Init)then
			if(Unknown.Use_Return) then _ChatMessageLogic:Add(_ChatMessageType.Yellow, "[Detection System] It is already set.") return end
			Unknown.Use_LogOut = not Unknown.Use_LogOut
			Unknown.ignore_people = not Unknown.ignore_people
			local strings = Unknown.Use_LogOut and "Set" or "Unset"
			local color = Unknown.Use_LogOut and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[Detection System] Logout " .. strings .. "ed.")
		end
	end,
	["공속"] = function(self,user,argc,args)
		if(Unknown.Init)then
			if args[2] == nil then
				Unknown.Use_attack_speed = not Unknown.Use_attack_speed
				local strings = Unknown.Use_attack_speed and "설정" or "설정해제"
				local color = Unknown.Use_attack_speed and _ChatMessageType.Yellow or _ChatMessageType.Red
				_ChatMessageLogic:Add(color, "[공속]" .. strings .. " 되었습니다.")
			else
				Unknown.Use_attack_speed_Value = tonumber(args[2])
				_ChatMessageLogic:Add(_ChatMessageType.Red, "[공속] 속도가 " .. args[2] .. "로 변경 되었습니다.")
			end
		end
	end,
	["귀환"] = function(self)
		if(Unknown.Init)then
			if(Unknown.Use_LogOut) then _ChatMessageLogic:Add(_ChatMessageType.Blue, "[감지 시스템] 이미 로그아웃이 설정 되어 있습니다.") return end
			Unknown.Use_Return = not Unknown.Use_Return
			Unknown.ignore_people = not Unknown.ignore_people
			local strings = Unknown.Use_Return and "설정" or "설정해제"
			local color = Unknown.Use_Return and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[감지 시스템] 귀환설정 " .. strings .. " 되었습니다.")
		end
	end,
	["return"] = function(self)
		if(Unknown.Init)then
			if(Unknown.Use_LogOut) then _ChatMessageLogic:Add(_ChatMessageType.Blue, "[Detection System] It is already set.") return end
			Unknown.Use_Return = not Unknown.Use_Return
			Unknown.ignore_people = not Unknown.ignore_people
			local strings = Unknown.Use_Return and "Set" or "Unset"
			local color = Unknown.Use_Return and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[Detection System] Return Home " .. strings .. "ed.")
		end
	end,
	["하이드"] = function(self)
		if(Unknown.Init)then
			Unknown.hide_name = not Unknown.hide_name
			_TimerService:ClearTimer(Unknown.name_timer)
			if(Unknown.hide_name)then
				Unknown.name_timer = _TimerService:SetTimerRepeat(Unknown.name_timer_func, 1)
			else
				_UserService.LocalPlayer.NameTagComponent.Enable = true
				_UserService.LocalPlayer.TouchReceiveComponent.Enable = true
				_UserService.LocalPlayer.AvatarRendererComponent.Enable = true
				_UserService.LocalPlayer.MiniMapComponent.Enable = true
			end
			local strings = Unknown.hide_name and "설정" or "설정해제"
			local color = Unknown.hide_name and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[하이드] " .. strings .. " 되었습니다.")
		end
	end,
	["줍기"] = function(self)
		if(Unknown.Init)then
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
		end
	end,	
	["템박템박"] = function(self)
		if(Unknown.Init)then
			Unknown.Use_TemBak = not Unknown.Use_TemBak
			local strings = Unknown.Use_TemBak and "설정" or "해제"
			local color = Unknown.Use_TemBak and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[템박] " .. strings .. " 되었습니다.")
		end
	end,
	["무시"] = function(self)
		if(Unknown.Init)then
			Unknown.Musi = not Unknown.Musi
			local strings = Unknown.Musi and "설정" or "해제"
			local color = Unknown.Musi and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[인원무시] " .. strings .. " 되었습니다.")
		end
	end,
	["마박"] = function(self)
		if(Unknown.Init)then
			Unknown.Teleport_Mouse = not Unknown.Teleport_Mouse
			local strings = Unknown.Teleport_Mouse and "설정" or "해제"
			local color = Unknown.Teleport_Mouse and _ChatMessageType.Yellow or _ChatMessageType.Red
			_ChatMessageLogic:Add(color, "[마우스박] " .. strings .. " 되었습니다.")
		end
	end,	
	["인벤토리"] = function(self,user,argc,args)
		if(Unknown.Init)then
			if(args[2] == "귀환")then
				Unknown.DetectInventory = not Unknown.DetectInventory
				local strings = Unknown.DetectInventory and "설정" or "해제"
				local color = Unknown.DetectInventory and _ChatMessageType.Yellow or _ChatMessageType.Red
				_ChatMessageLogic:Add(color, "[인벤토리] 기타창 인식 시스템 " .. strings .. " 되었습니다. [ 귀환 ]")
				return
			elseif(args[2] == "필터")then
				Unknown.DetectInventory_2 = not Unknown.DetectInventory_2
				local strings = Unknown.DetectInventory_2 and "설정" or "해제"
				local color = Unknown.DetectInventory_2 and _ChatMessageType.Yellow or _ChatMessageType.Red
				_ChatMessageLogic:Add(color, "[인벤토리] 기타창 인식 시스템 " .. strings .. " 되었습니다. [ 필터 ]")
				return
			end
		end
	end,
	["리셋"] = function(self)
		if(Unknown.Init)then
			Unknown.Reset_All_Variable()
			_ChatMessageLogic:Add(_ChatMessageType.Yellow, "모든 설정이 리셋되었습니다.")
		end
	end,
	
	["쿼터"] = function(self)
		local Temp = _UserService.LocalPlayer.TransformComponent.WorldPosition
		_UserService.LocalPlayer.RigidbodyComponent.QuaterViewAccelerationX = 3.5
		_UserService.LocalPlayer.RigidbodyComponent.QuaterViewAccelerationY = 2.3
		_UserService.LocalPlayer.RigidbodyComponent.IsQuaterViewMove = not _UserService.LocalPlayer.RigidbodyComponent.IsQuaterViewMove
		Unknown.MovePosition(Temp:ToVector2())
		local strings = _UserService.LocalPlayer.RigidbodyComponent.IsQuaterViewMove and "설정" or "해제"
		local color = _UserService.LocalPlayer.RigidbodyComponent.IsQuaterViewMove and _ChatMessageType.Yellow or _ChatMessageType.Red
		_ChatMessageLogic:Add(color, "[쿼터모드] " .. strings .. " 되었습니다.")
	end,
	["리로드"] = function(self)
		_TimerService:SetTimerOnce(Unknown.InitHack)
	end,
}
if (Environment:IsMakerPlay()) then
	self.DebugCommands = {
		["impact"] = _CommandLogic_Client_Debug.Impact
	}
end
end