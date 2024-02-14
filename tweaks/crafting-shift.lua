---@diagnostic disable: undefined-global

-- Shiftclick items into the crafting grid when in a crafting table

---@param inv ModyfiableInventory
local function onTick(inv)
  if not Settings.craftingShift.value then return end
  if not inv then return end

  if
    inv.lastHoverSlotName == "crafting_input_items" or not KeyStates.shift or
    gui.screen() ~= "crafting_screen" or not KeyStates.lmb or
    inv.at(inv.lastHoverSlotName, inv.lastHoverSlotValue) == nil
  then return end

  for i = 1, 9 do
    local cItem = inv.at("crafting_input_items", i)
    if cItem ~= nil then goto cont end

    inv.sendFlyingItem(inv.lastHoverSlotName, inv.lastHoverSlotValue, "crafting_input_items", i)
    inv.takeAll(inv.lastHoverSlotName, inv.lastHoverSlotValue)
    inv.placeAll("crafting_input_items", i)

    ::cont::
  end
end

return {
  onTick = onTick,
}
