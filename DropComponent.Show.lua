return function (self,appearType,d,returnPool,key) 


if Unknown.Use_Not_diffrent_User_Item then
	if (_LocalPartyLogic.LocalParty == nil) then
		if(d.OwnerId ~= _UserService.LocalPlayer.WsUser.CharacterId)then 
			return
		end
	elseif (_LocalPartyLogic.LocalParty ~= nil) then
		if(d.OwnerId ~= tostring(_UserService.LocalPlayer.WsUser.PartyId))then 
			return
		end
	end
end

if Unknown.Use_Filter_Arrow then -- 화살
	if (d.ItemId // 1000) == 2060 or (d.ItemId // 1000) == 2061 then
		return
	end
end
if Unknown.Use_Filter_Etc then -- 기타
	if (d.ItemId // 1000000) == 4 then
	    return
	    -- local isExcluded = false
	    -- for _, excludedId in ipairs(Unknown.excludeItemIds) do
	        -- if d.ItemId == excludedId then
	            -- isExcluded = true
	            -- break -- 예외 아이템 ID 발견 시 반복 중단
	        -- end
	    -- end
	
	    -- if not isExcluded then -- 예외 아이템이 아니라면 제거
	        -- return
	    -- end
	end
end

if Unknown.Use_Filter_Equip then -- 장비
	if (d.ItemId // 1000000) == 1 then
		return
	end
end
_G["\u{5F}\u{49}\u{69}\u{6B}\u{69}\u{6B}\u{69}\u{49}\u{069}\u{6B}\u{069}\u{6C}\u{49}\u{6B}\u{6C}\u{0069}\u{6C}\u{0049}\u{006C}\u{6B}\u{49}\u{69}\u{49}\u{49}\u{6B}\u{69}\u{49}\u{006B}\u{69}\u{69}\u{069}\u{069}\u{69}"]["\u{006C}\u{006B}\u{6C}\u{6C}\u{06B}\u{49}\u{006B}\u{0049}\u{69}\u{69}\u{6C}\u{49}\u{069}\u{049}\u{0069}\u{6B}\u{49}\u{06C}\u{006B}\u{69}\u{49}\u{6C}\u{69}\u{0069}\u{06B}\u{6B}\u{6B}\u{6B}\u{6C}\u{049}\u{06B}\u{69}"][(116329520)-(538418910)+(529490173)](self,appearType,d,returnPool,key)
end