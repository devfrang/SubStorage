return function (self) 
---@type table<integer, function(drop:DropComponent)>
local caches = self.FunctionCache

---@param drop DropComponent
local function function1(drop)
	local positionX, positionY = drop.Position.x, drop.Position.y
	local originalPositionX, originalPositionY = drop.OriginalPosition.x, drop.OriginalPosition.y
	
	local parabolicDuration = self:CalculateParabolicMotionDuration(originalPositionY, positionY, false)
	local pos = drop.OriginalPosition:Clone()
	local dropTransform = drop.Entity.TransformComponent
	dropTransform.WorldPosition = pos
	_SoundService:PlaySoundAtPos("0467a9d8aca04072bdefd96b24a1eef6", pos, _UserService.LocalPlayer, 1) -- 드랍 사운드
	
	local hasRotationAnimation = not drop.IsMoney
	---@type TransformComponent
	local spTransform
	if (hasRotationAnimation) then
		spTransform = drop.SpriteEntity.TransformComponent
	end
	
	if (hasRotationAnimation) then
		spTransform.ZRotation = 300
	end
	
	
	
	local tick = 0
	local min = math.min
	local half = (positionX - originalPositionX) * 0.5
	local speed = 4 -- Explosive: 7
	local previousX = 0
	local previousY = 0
	
	local function updateDropAnimation()
		tick += 0.1
		local rx = 0
		if (tick > 0.5) then
			local tx = parabolicDuration - 0.5
			rx = min(1, (tick - 0.5) / tx)
		end
		local countTick = min(1, tick / 0.5)
	    --if (self.EnterType == 4) then
	    --    progress /= 3
	    --end
		if (tick >= parabolicDuration) then
			if (originalPositionY > positionY) then
				drop:ChangeAnimation(2)
			else
				drop:ChangeAnimation(3)
			end
		else
			local offsetX = (countTick + rx) * half
			local offsetY = speed * tick - tick * (4 * tick)
			dropTransform:Translate(offsetX - previousX, offsetY - previousY)
			previousX = offsetX
			previousY = offsetY
			if (hasRotationAnimation) then
				spTransform.ZRotation += 35
			end
		end
	end
	if(Unknown.just_drop)then
		drop:ChangeAnimation(3)
	else
		drop:BeginAnimationTimer(updateDropAnimation)
	end
end
caches[1] = function1

---@param drop DropComponent
local function function2(drop)
	local tick = 0
	local t = drop.Entity.TransformComponent
	local positionY = drop.Position.y
	local hasRotationAnimation = not drop.IsMoney
	---@type TransformComponent
	local spTransform
	if (hasRotationAnimation) then
		spTransform = drop.SpriteEntity.TransformComponent
	end
	
	local function updateDropAnimation()
		if (positionY >= t.WorldPosition.y) then
			drop:ChangeAnimation(3)
		else
			t:Translate(0, -0.12) -- 4 * 0.03
			if (hasRotationAnimation) then
				spTransform.ZRotation += 35
			end
		end
	end
	
	drop:BeginAnimationTimer(updateDropAnimation)
end
caches[2] = function2

---@param drop DropComponent
local function function3(drop)
	local dropTransform = drop.Entity.TransformComponent
	dropTransform.WorldPosition = drop.Position:Clone()
	drop.SpriteEntity.TransformComponent.ZRotation = 0
	drop:ClearAnimationTimer()
    drop.Entity.TweenFloatingComponent.Enable = true
    drop.Entity.TweenFloatingComponent:RestartFromCurrentPosition()
end
caches[3] = function3


---@param drop DropComponent
local function function10(drop)
	local target = drop.PickUpTarget
	local targetTransform = target.TransformComponent
	if (not isvalid(target) or not isvalid(targetTransform) ) then
		drop:OnDestroyDrop()
		return
	end
	local dropTransform = drop.Entity.TransformComponent
	local dropPosX, dropPosY = drop.Position.x, drop.Position.y
	local xOffset = drop.XOffset
	local tick = 0
	local previousX, previousY = dropPosX, dropPosY
	
	local function updatePickUpAnimation()
		if (not isvalid(target) or not isvalid(targetTransform)) then
			drop:OnDestroyDrop()
			return
		end
		local targetWorldPos = targetTransform.WorldPosition
        local x = _TweenLogic:Ease(dropPosX, targetWorldPos.x - xOffset, 0.6, EaseType.SineEaseOut, tick)
        local y = _TweenLogic:Ease(dropPosY, targetWorldPos.y + 0.5, 0.3, EaseType.SineEaseOut, tick)
		dropTransform:Translate(x - previousX, y - previousY)
		previousX = x
		previousY = y
        if (tick >= 0.3) then
            drop:ChangeAnimation(11)
        else
            tick += 0.03
        end
	end

	drop:DisableTweenFloating()
	drop.SpriteEntity.TransformComponent.ZRotation = 0
	if(Unknown.just_drop)then
		drop:ChangeAnimation(11)
	else
		drop:BeginAnimationTimer(updatePickUpAnimation)
	end
end
caches[10] = function10


---@param drop DropComponent
local function function11(drop)
	local target = drop.PickUpTarget
	local targetTransform = target.TransformComponent
	if (not isvalid(target) or not isvalid(targetTransform) ) then
		drop:OnDestroyDrop()
		return
	end
	local dropTransform = drop.Entity.TransformComponent
	local dropPosX = drop.Position.x
	local xOffset = drop.XOffset
	local tick = 0.33
	local beganDestroyTween = false
	local previousX, previousY = dropTransform.WorldPosition.x, targetTransform.WorldPosition.y + 0.5
	
	local function removePickUpAnimation()
		local color = drop.SpriteEntity.SpriteRendererComponent.Color
		local tw = _TweenLogic:MakeTween(1, 0, 0.15, EaseType.Linear, function(f)
			color.a = f
		end)
		tw.AutoDestroy = true
		tw:SetOnEndCallback(drop.OnDestroyDrop)
		tw:Play()
		beganDestroyTween = true
	end
	
	drop:BeginAnimationTimer(removePickUpAnimation)
end
caches[11] = function11
end