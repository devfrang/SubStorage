return function (self,sender,rawMessage,channel,id,hash) 
if(Unknown.Use_block_message) then return end
local message = _Slangs:EscapeNonPrintable(rawMessage)
if (sender ~= _UserService.LocalPlayer.WsUser.FullName) then
	message = self:FilterSlangs(message)
end
_ChatMessageLogic:AddSpeakerChannel(_ChatMessageType.SpeakerWorldInstance, sender, string.format("%s　　　: %s", sender, message), channel)
self:InsertLog(sender, rawMessage, id, hash)
end