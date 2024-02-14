--[[
  smol shulker contents viewer script that took waaaaaay too long to release
  originally used mouse coordinates to locate currently hovered inv slots
  thank onix for the better api via inventory.modify
  though it isn't perfect and you might get the shulker window showing when it
  isn't supposed to (if the shulker was the last slot you hovered)
  though I have no idea if there's an easy way to fix that
  anyway, enjoy

  -- Tom16 (aka. Jerry)
]]

renderEverywhere = true

local settings = {
  client.settings.addInfo("Tint the background of the contents hover to the dye colour of the viewed shulker box."),
  colouredShulkers = client.settings.addNamelessBool("Coloured Shulkers", true),

  client.settings.addAir(2),

  client.settings.addInfo("Assign a button to toggle between views (Full View and condensed Item Count view)."),
  ---@diagnostic disable-next-line: undefined-global
  toggleView = client.settings.addNamelessKeybind("Toggle View", KeyCodes.Shift),
  defaultView = client.settings.addNamelessEnum("Default View", 2, { { 1, "Item Count" }, { 2, "Full View" } }),
  client.settings.addAir(2),

  client.settings.addInfo("This only applies to the condensed Item Count view."),
  countView = client.settings.addNamelessEnum("Count Format", 1, { { 1, "Total Items" }, { 2, "Total Stacks (Rounded Up)" }, { 3, "Total Stacks (Rounded Down)" } }),
  client.settings.addInfo("Total Items: 2 stacks and 23 will show '151'."),
  client.settings.addInfo("Total Stacks (Rounded Up): 2 stacks and 23 will show '3s'."),
  client.settings.addInfo("Total Stacks (Rounded Down): 2 stacks and 23 will show '2s'."),
  client.settings.addAir(5),
}

MX, MY = gui.mousex, gui.mousey
local toggleView = false

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
