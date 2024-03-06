return function (self,fadeInAnimation) 
local mob = self.Entity
local template = _MobTemplateMan:GetMobTemplate(self.MobTemplateID)

local function activateMobTrigger()
	local enabledBodyAttack
	if (template.BodyAttack and not template.NotAttack) then
		enabledBodyAttack = true
	else
		enabledBodyAttack = false
	end
	self:SetBodyAttackEnabled(enabledBodyAttack)
	self:UpdateTriggerBoxByState(self.Entity.StateComponent.CurrentStateName)
	self:ClearFadeInTweener()
	mob.SpriteRendererComponent.Color.a = 1
end


-- mob.MobAIComponent.Target = _UserService.LocalPlayer
mob.TriggerComponent.Enable = true
activateMobTrigger()
_UpdateComponentLogic:InsertUpdateVisible(mob)

end