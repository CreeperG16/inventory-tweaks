---@diagnostic disable: undefined-global

-- Drag your mouse over multiple slots while holding your drop key
-- to drop them all

local lastSlot = { "", 0 }

---@param inv ModyfiableInventory
local function onTick(inv)
  if not Settings.dragDrop.value then return end
  if not inv then return end
  if not KeyStates.drop then return end
  if Settings.requireRightClickForDragDrop.value and not KeyStates.rmb then return end

  if lastSlot[1] == inv.lastHoverSlotName and lastSlot[2] == inv.lastHoverSlotValue then return end

  lastSlot = { inv.lastHoverSlotName, inv.lastHoverSlotValue }

  inv.dropAll(inv.lastHoverSlotName, inv.lastHoverSlotValue)
end

return {
  onTick = onTick,
}
