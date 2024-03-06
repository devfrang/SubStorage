return function (self,input) 
if (not input) then
	self.Loading.Enable = false
	self.Entity.Enable = false
	_UtilDlgLogic:Show("채널 목록을 불러오지 못했습니다.\n나중에 다시 시도하세요.")
	return
end

self.BtOk:SetInteractible(false)

---@type table<ChannelEntry>
local channels = input

---- test
--local c = #channels
--for a=1,500 do
--    for i=1,c do
--        table.insert(channels, channels[i])
--    end
--end

self:EnsureChannelButtonsForDemand(#channels)
self:DisableUnnecessaryChannelButtons(#channels)

---@type table<Entity>
local channelButtons = self.ChannelButtons

for i=1,#channels do
	local entry = channelButtons[i]
	local channel = channels[i]
	local chnComp = entry.ChannelElementComponent
	chnComp:SetCurrentChannel(false)
	chnComp:SetChannelName(string.format("CH.%s", channel.ChannelName))
	chnComp:ChangePopularity(channel.Pop)
	if (not chnComp.IsCurrentChannel) then
		chnComp.ChannelIndex = i
	else
		chnComp.ChannelIndex = -1
	end
	self.Channels[i] = channel
end
self.Selected = 0

local line = (#channels + 5) // 6
if (line > 10) then
	line = 10
end
local height = 134 + 74 + 40 * line + 5 * (line - 1)
self.Entity.UITransformComponent.RectSize.y = height
self.Loading.Enable = false
end