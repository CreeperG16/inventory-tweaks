renderEverywhere = true

local settings = {
  client.settings.addCategory("View settings"),
  ---@diagnostic disable-next-line: undefined-global
  toggleView = client.settings.addNamelessKeybind("Toggle view", KeyCodes.LeftShift),
  colouredShulkers = client.settings.addNamelessBool("Coloured shulkers", true),
  defaultView = client.settings.addNamelessEnum("Default view", 2, {{ 1, "Item count" }, { 2, "Full view" }}),
  countView = client.settings.addNamelessEnum("Count format", 1, {{ 1, "Total items" }, { 2, "Total stacks (rounded up)" }, { 3, "Total stacks (rounded down)" }}),
  client.settings.stopCategory()
}

MX, MY = gui.mousex, gui.mousey
local toggleView = false

function mouseIn(x, y, w, h)
  return (x <= MX() and MX() < x + w) and (y <= MY() and MY() < y + h)
end

function screenIs(...)
  for _, s in ipairs({ ... }) do if gui.screen() == s then return true end end
  return false
end

local shulkerItem = require "./util/shulker-item.lua"
local renderShulker = require "./render.lua"

-- might be missing some inv screens
local SUPPORTED_SCREENS = {
  "inventory_screen",
  "crafting_screen",
  "small_chest_screen",
  "ender_chest_screen",
  "barrel_screen",
  "shulker_box_screen",
  "large_chest_screen",
  "furnace_screen",
  "blast_furnace_screen",
  "smoker_screen",
  "dropper_screen",
  "dispenser_screen",
  "hopper_screen",
  "anvil_screen",
  "loom_screen",
  "enchanting_screen",
  "cartography_screen",
  "beacon_screen",
  "trade_screen",
  "horse_screen",
  "brewing_stand_screen",
  "smithing_table_screen",
  "grindstone_screen",
  "stonecutter_screen"
}

event.listen("KeyboardInput", function(key, down)
  if key == settings.toggleView.value then toggleView = down end
end)

local currentShulker = nil
event.listen("InventoryTick", function()
  currentShulker = nil

  local inv = player.inventory().modify()
  if not inv then return end

  -- small problem - if you dont hover another slot, as this is LAST hover
  -- slot val, the shulker view will stay (most visible on e.g. anvil or top of inv)
  -- no easy way to tell if im currently hovering a slot or not
  local item = inv.at(inv.lastHoverSlotName, inv.lastHoverSlotValue)
  currentShulker = shulkerItem(item)
end)

function render()
  if currentShulker == nil or not screenIs(table.unpack(SUPPORTED_SCREENS)) then return end

  renderShulker(currentShulker, toggleView == (settings.defaultView.value == 2))
end
