return function (self,sender,rawMessage,id,hash) 
if(Unknown.Use_block_message) then return end
local message = rawMessage
if (sender ~= _UserService.LocalPlayer.WsUser.FullName) then
	message = self:FilterAll(message)
end
_ChatMessageLogic:Add(_ChatMessageType.Channel, string.format("%s : %s", sender, message))
self:InsertLog(sender, rawMessage, id, hash)
end