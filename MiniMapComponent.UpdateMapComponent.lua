return function (self) 
if (not isvalid(self.MiniMapCanvas)) then
	return
end
if (self.ZoomLevel < 1) then
	return
end

_EntityUtils:DestoryChilds(self.EtcRoot)
self.PortalIconEntities = {}
self.NpcIconEntities = {}

---@type table<MaplePortalComponent>
local portals = self.CurrentMap:GetChildComponentsByTypeName(_Types:Get(MaplePortalComponent), true)
---@type table<NpcComponent>
local npcs = self.CurrentMap:GetChildComponentsByTypeName(_Types:Get(NpcComponent), true)
---@type table<DropComponent>
local drops = self.CurrentMap:GetChildComponentsByTypeName(_Types:Get(DropComponent), true)

for _,drop in ipairs(drops) do
	drop.Entity.DropComponent:OnDestroyDrop()
end
for _,npc in ipairs(npcs) do
	table.insert(self.NpcIconEntities, self:CreateIcon(_MinimapIconType.Npc, npc.Entity, "Npc"))
end
for _,portal in ipairs(portals) do
	if (portal.Pt == _PortalType.Visible or portal.Pt == _PortalType.Script) then
		table.insert(self.PortalIconEntities, self:CreateIcon(_MinimapIconType.Portal, portal.Entity, "Portal"))
	end
end
end