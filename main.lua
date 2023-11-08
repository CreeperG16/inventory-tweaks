renderEverywhere = true

local settings = {
  client.settings.addCategory("View settings"),
  ---@diagnostic disable-next-line: undefined-global
  toggleView = client.settings.addNamelessKeybind("Toggle view", KeyCodes.LeftAlt),
  colouredShulkers = client.settings.addNamelessBool("Coloured shulkers", true),
  defaultView = client.settings.addNamelessEnum("Default view", 1, {{1, "Item count"}, {2, "Full view"}}),
  countView = client.settings.addNamelessEnum("Count format", 1, {{1, "Total items"}, {2, "Total stacks (rounded up)"}, {3, "Total stacks (rounded down)"}}),
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

local shulkerItem = require "./util/shulker-item.lua"
local renderShulker = require "./render.lua"

event.listen("MouseInput", function(button, down)
  if not (button == 1 and down) then return end

  if
    mouseIn(inventory.craftingBook.position()) and
    screenIs("inventory_screen", "crafting_screen")
  then
    -- Janky but kinda works as long as you don't mess around with it too much
    inventory.craftingBook.toggle()
  end
end)

event.listen("KeyboardInput", function(key, down)
  if key == settings.toggleView.value then toggleView = down end
end)

function render()
  shulkerBoxes = shulkerItem()

  gfx.text(10, 10, gui.screen())

  -- TODO: implement for other screens
  if not screenIs(
    "inventory_screen",
    "crafting_screen",
    "small_chest_screen",
    "ender_chest_screen",
    "barrel_screen",
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
    "horse_screen", -- Breaks on donkeys/llamas with less than max storage capacity
    "brewing_stand_screen",
    "smithing_table_screen",
    "grindstone_screen",
    "stonecutter_screen"
  ) then return end

  for slot, shulker in pairs(shulkerBoxes) do
    if mouseIn(inventory.coords(slot)) then
      renderShulker(shulker, toggleView == (settings.defaultView.value == 2))
      break
    end
  end
end
