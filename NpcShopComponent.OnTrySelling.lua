return function (self) 
local selectedSell = self.SelectedSellShopItem
if (selectedSell == nil) then
	return
end
local entry = selectedSell.NpcShopItemEntryComponent

local user = _UserService.LocalPlayer
local cd = user.WsCharacterData
local realItem = cd:GetItem(entry.LinkedSellTI, entry.LinkedSellPos)
if (realItem == nil or realItem.ItemId ~= entry.LinkedSellItemId) then
	_UtilDlgLogic:Show("알 수 없는 오류가 발생하여 상점 작업을 수행할 수 없습니다.")
	self:CloseShop()
	return
end
if (user.WsUser.ExclusiveAction) then
	return
end
	if(Unknown.Use_auto_sell) then
		user.WsUser.ExclusiveAction = true
		_NpcShopLogic:OnSellItem(user, entry.LinkedSellTI, entry.LinkedSellPos, realItem.ItemId, realItem.Number)
		return
	end
if (_Items:IsTreatSingly(entry.LinkedSellItemId)) then
	_UtilDlgLogic:YesNo("정말로 파시겠습니까?", function()
		user.WsUser.ExclusiveAction = true
		_NpcShopLogic:OnSellItem(user, entry.LinkedSellTI, entry.LinkedSellPos, realItem.ItemId, 1)
	end, nil)
else
	_UtilDlgLogic:Input("몇 개를 파시겠습니까?", true, tostring(realItem.Number), function(val)
		local num = math.tointeger(tonumber(val))
		if (num == nil or num <= 0) then
			_UtilDlgLogic:Show("1 이상의 숫자만 가능합니다.")
			return true
		end
		if (num > realItem.Number) then
			_UtilDlgLogic:Show(string.format("%d 이하의 숫자만 가능합니다", realItem.Number))
			return true
		end
		user.WsUser.ExclusiveAction = true
		_NpcShopLogic:OnSellItem(user, entry.LinkedSellTI, entry.LinkedSellPos, realItem.ItemId, num)
	end, nil)
end
end