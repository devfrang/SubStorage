return function (self,magic) 
local speed
-- if(Unknown.Use_attack_speed)then
	-- return Unknown.Use_attack_speed_Value
-- end

if (magic) then
	speed = 6
else
	speed = self.CurrentWeaponAttackSpeed
end
speed += self.Entity.PlayerTemporaryStat:GetValue(_CTS.Booster)
if (speed < 2) then
	return 2
end
if (speed > 10) then
	return 10
end
return speed
end