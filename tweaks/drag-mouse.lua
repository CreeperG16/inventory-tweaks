---@diagnostic disable: undefined-global

-- Drag your mouse over multiple slots while holding shift
-- to automatically move items from all slots into container

-- bug - when you shiftclick from creative menu, it gives two stacks

local lastSlot = {"", 0}

---@param inv ModyfiableInventory
local function onTick(inv)
  if not Settings.dragMouse.value then return end
  if not inv then return end
  if not KeyStates.shift or not KeyStates.lmb then return end

  if lastSlot[1] == inv.lastHoverSlotName and lastSlot[2] == inv.lastHoverSlotValue then return end

  lastSlot = { inv.lastHoverSlotName, inv.lastHoverSlotValue }

  inv.autoPlace(inv.lastHoverSlotName, inv.lastHoverSlotValue)
end

return {
  onTick = onTick,
}
