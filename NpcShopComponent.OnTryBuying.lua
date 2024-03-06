return function (self) 
local selectedBuy = self.SelectedBuyShopItem
if (selectedBuy == nil) then
	return
end
local entry = selectedBuy.NpcShopItemEntryComponent
local user = _UserService.LocalPlayer
local cd = user.WsCharacterData

---@type NpcShopItem
local shopItem = entry.LinkedNpcShopItem
if (shopItem.Price == 0) then
	return
end
if (user.WsUser.ExclusiveAction) then
	return
end

	if(Unknown.Use_auto_buy) then
		local maxBuyable = _NpcShopLogic:GetMaxBuyable(shopItem.Stock, cd:GetSlotMax(shopItem.ItemId))
		local totalPrice = maxBuyable * shopItem.Price
		if (totalPrice <= 0 or totalPrice > cd.Money) then
			_UtilDlgLogic:Show("메소가 부족합니다.")
			return true
		end
		user.WsUser.ExclusiveAction = true
		_NpcShopLogic:OnBuyItem(user, entry.LinkedNpcShopItemIndex, shopItem.ItemId, maxBuyable)
		return true
	end
if (_Items:IsTreatSingly(shopItem.ItemId)) then
	_UtilDlgLogic:YesNo("정말로 사시겠습니까?", function()
		local totalPrice = shopItem.Price
		if (totalPrice <= 0 or totalPrice > cd.Money) then
			_UtilDlgLogic:Show("메소가 부족합니다.")
			return true
		end
		user.WsUser.ExclusiveAction = true
		_NpcShopLogic:OnBuyItem(user, entry.LinkedNpcShopItemIndex, shopItem.ItemId, 1)
	end, nil)
else
	_UtilDlgLogic:Input("몇 개를 사시겠습니까?", true, "1", function(val)
		log("Trying buy number: ", val)
		local num = math.tointeger(tonumber(val))
		if (num == nil or num <= 0) then
			_UtilDlgLogic:Show("1 이상의 숫자만 가능합니다.")
			return true
		end
		local maxBuyable = _NpcShopLogic:GetMaxBuyable(shopItem.Stock, cd:GetSlotMax(shopItem.ItemId))
		if (num > maxBuyable) then
			_UtilDlgLogic:Show(string.format("%d 이하의 숫자만 가능합니다", maxBuyable))
			return true
		end
		local totalPrice = num * shopItem.Price
		if (totalPrice <= 0 or totalPrice > cd.Money) then
			_UtilDlgLogic:Show("메소가 부족합니다.")
			return true
		end
		user.WsUser.ExclusiveAction = true
		_NpcShopLogic:OnBuyItem(user, entry.LinkedNpcShopItemIndex, shopItem.ItemId, num)
	end, nil)
end
end