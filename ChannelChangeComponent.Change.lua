return function (self) 
if (self.Selected == 0) then
	return
end
---@type ChannelEntry
local channel = self.Channels[self.Selected]
if (not channel) then
	return
end
local player = _UserService.LocalPlayer
if (player.CharacterActionComponent:CheckAlert()) then
	return
end

local t = "채널 변경시 적용 중인 버프가 유지되지 않습니다."

local ts = player.PlayerTemporaryStat
if (ts:GetValue(_CTS.ExpBuff) > 0) then
	_UtilDlgLogic:Show(string.format("%s\n\n경험치 증가량 버프가 활성화 중일때는 채널을 변경할 수 없습니다.", t))
	return
end

if (channel.Pop == 3) then
	_UtilDlgLogic:Show("해당 채널은 수용 가능한 최대 인원을 초과하여 접속할 수 없습니다.")
	return
end
log("Trying to change world to ", channel.WorldId)
_ChannelChangeLogic:ChangeChannelTo(player, channel.WorldId, player.WsUser.CharacterId)
self.Entity.Enable = false
end