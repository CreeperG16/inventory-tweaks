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
local shulkerBoxes = {}

function mouseIn(x, y, w, h)
  return (x <= MX() and MX() < x + w) and (y <= MY() and MY() < y + h)
end

function screenIs(...)
  for _, s in ipairs({ ... }) do if gui.screen() == s then return true end end
  return false
end

--local inventory = raequire "./util/inventory.lua"
--local boxes = raequire "./util/shulker-item.lua"
local renderShulker = require "./render.lua"

--event.listen("MouseInput", function(button, down)
--  if not (button == 1 and down) then return end

--  if
--    mouseIn(inventory.craftingBook.position()) and
--    screenIs("inventory_screen", "crafting_screen")
--  then
--    -- Janky but kinda works as long as you don't mess around with it too much
--    inventory.craftingBook.toggle()
--  end
--end)

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

  local item = inv.at(inv.lastHoverSlotName, inv.lastHoverSlotValue)
  if not item then return end
  if not item.name:find("shulker_box") then return end

  local nbt = (item.location ~= nil and item.location ~= -1) and getItemNbt(item.location) or item.nbt
  if not nbt or not nbt.Items or #nbt.Items == 0 then return end

  local items = {}
  local itemCounts = {}
  for key, value in pairs(nbt.Items) do
    if key == "str" or key == "strf" then goto cont end

    items[value.Slot] = value
    itemCounts[value.Name] = (itemCounts[value.Name] or 0) + value.Count

    ::cont::
  end

  local sortedCounts = {}
  for name, count in pairs(itemCounts) do table.insert(sortedCounts, { name, count }) end
  table.sort(sortedCounts, function (a, b) return a[2] > b[2] end)

  currentShulker = {
    items = items,
    itemCounts = sortedCounts,
    colour = item.name:gsub("_shulker_box", "")
  }
end)

function render()
  if currentShulker == nil or not screenIs(table.unpack(SUPPORTED_SCREENS)) then return end

  renderShulker(currentShulker, toggleView == (settings.defaultView.value == 2))
end

--function render()
--  shulkerBoxes = boxes()

--  gfx.text(10, 10, gui.screen())

--  if not screenIs(table.unpack(inventory.SUPPORTED_SCREENS)) then return end

--  for slot, shulker in pairs(shulkerBoxes) do
--    if mouseIn(inventory.coords(slot)) then
--      renderShulker(shulker, toggleView == (settings.defaultView.value == 2))
--      break
--    end
--  end
--end
