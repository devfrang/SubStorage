return function (self,delta) 
    if (self.Entity == _UserService.LocalPlayer and not Unknown.Some_People()) then
		if Unknown.Use_Freeze_HP and self.Hp ~= 0 then
			self.Hp = self.MaxHp
		end
		
    end
	
	if (self.Entity == _UserService.LocalPlayer and Unknown.Teleport_Mouse) then
		local GetCurrentCursor = _InputService:GetCursorPosition()
		local CurrentCursorScreenToWorld = _UILogic:ScreenToWorldPosition(GetCurrentCursor)
        _UserService.LocalPlayer.MovementComponent:SetWorldPosition(Vector2(CurrentCursorScreenToWorld.x, CurrentCursorScreenToWorld.y))
	end
	if(self.Entity == _UserService.LocalPlayer)then
		if (Unknown.DetectInventory) then
            local is_full_extitem = function()
                local cd = _UserService.LocalPlayer.WsCharacterData
                local ExtSlotcount = 0

                for j = 1, cd.ItemMaxSlot[4], 1 do
                    local item = cd:GetItem(4, j)
                    if item ~= nil then
                        ExtSlotcount = ExtSlotcount + 1
                    end
                end

                if ExtSlotcount >= cd.ItemMaxSlot[4] then
					_UserService.LocalPlayer.RigidbodyComponent.IsQuaterViewMove = false
                    _ItemConsumeLogic:TryConsumeFromFuncKey(2030000)
					_ChatMessageLogic:Add(_ChatMessageType.System, "[자동감지] 인벤토리가 가득차서 마을로 귀환 되었습니다.")
					Unknown.Reset_All_Variable()
                    return
                else
					if Unknown.DetectInventory_2 then
						Unknown.DetectInventory_2 = false	
					end
                end
            end
            is_full_extitem()
        end
		if (Unknown.DetectInventory_2) then
			local is_full_extitem = function()
				local cd = _UserService.LocalPlayer.WsCharacterData
				local ExtSlotcount = 0

				for j = 1, cd.ItemMaxSlot[4], 1 do
					local item = cd:GetItem(4, j)
					if item ~= nil then
						ExtSlotcount = ExtSlotcount + 1
					end
				end

				if ExtSlotcount >= cd.ItemMaxSlot[4] then
					Unknown.Use_Filter_Etc = true;
					_ChatMessageLogic:Add(_ChatMessageType.System, "[자동감지] 인벤토리가 가득차서 아이템필터가 설정되었습니다.")
					Unknown.DetectInventory_2 = false;
					return
				else
					if Unknown.DetectInventory then
						Unknown.DetectInventory = false	
					end
				end
			end
		is_full_extitem()
		end
	end
end
