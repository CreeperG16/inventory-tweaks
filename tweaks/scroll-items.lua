---@diagnostic disable: undefined-global

-- Use your scroll wheel to move a few items from a slot at a time
-- TODO: scroll the other way to pull them back
-- for that I can't use autoplace, need to move items manually

local scroll = {
  hasScrolled = false,
  down = true,
}

---@param inv ModyfiableInventory
local function onTick(inv)
  if not Settings.scrollItems.value then return end
  if not inv then return end

  if
    scroll.hasScrolled and scroll.down and
    inv.at(inv.lastHoverSlotName, inv.lastHoverSlotValue) ~= nil
  then
    inv.autoPlace(inv.lastHoverSlotName, inv.lastHoverSlotValue, 1)
  end

  scroll.hasScrolled = false
end

local function onMouse(btn, down)
  if btn ~= 4 then return end

  scroll.hasScrolled = true
  scroll.down = down
end

return {
  onTick = onTick,
  onMouse = onMouse,
}
