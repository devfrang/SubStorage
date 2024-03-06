return function (self,type,message) 
--log(string.format("[%d] %s", type, message))
local colorTable = self.ColorTable[type]
if (not colorTable) then
	return
end
self.ChatLog:AddChatLog(colorTable[1], colorTable[2], nil, nil, message)
end