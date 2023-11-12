local CRAFTINGBOOK_OPEN = true

-- TODO: implement for other screens
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
  "horse_screen",  -- Breaks on donkeys/llamas with less than max storage capacity
  "brewing_stand_screen",
  "smithing_table_screen",
  "grindstone_screen",
  "stonecutter_screen"
}

local function mid() return gui.width() / 2, gui.height() / 2 end

local function coords(slot)
  local midX, midY = mid()
  local midXDiff = 0

  if not screenIs(table.unpack(SUPPORTED_SCREENS)) then
    -- Off the screen lol
    return -18, -18, 18, 18
  end

  -- Where the inventory slots start (Can change depending on
  -- screen and whether the crafting book is open)
  if
    (CRAFTINGBOOK_OPEN and screenIs("inventory_screen", "crafting_screen"))
    or screenIs("loom_screen", "stonecutter_screen")
  then
    midXDiff = 6
  elseif screenIs("trade_screen") then
    midXDiff = 11
  else
    midXDiff = 81
  end

  if slot < 1 then return -18, -18, 18, 18 end

  -- The player's 36 inventory slots, which are visible on
  -- pretty much every screen
  if slot <= 36 then
    if screenIs("large_chest_screen", "cartography_screen", "beacon_screen") then
      if slot <= 9 then
        return (midX - 81) + 18 * (slot - 1), midY + 87, 18, 18
      end

      return (midX - 81) + 18 * ((slot - 10) % 9), (midY + 30) + 18 * ((slot - 10) // 9), 18, 18
    end

    if screenIs("hopper_screen") then
      if slot <= 9 then
        return (midX - 81) + 18 * (slot - 1), midY + 43.5, 18, 18
      end

      return (midX - 81) + 18 * ((slot - 10) % 9), (midY - 13.5) + 18 * ((slot - 10) // 9), 18, 18
    end

    if slot <= 9 then
      return (midX - midXDiff) + 18 * (slot - 1), midY + 60, 18, 18
    end

    return (midX - midXDiff) + 18 * ((slot - 10) % 9), (midY + 3) + 18 * ((slot - 10) // 9), 18, 18
  end

  -- Conditions for all screens
  if screenIs("inventory_screen") then
    -- Arbitrary slot numbering choices, will
    -- probably change this later on

    if slot <= 40 then
      -- Armour
      return (midX - midXDiff), (midY - 75) + 18 * -(37 - slot) - 1, 18, 18
    elseif slot == 41 then
      -- Offhand
      return (midX - midXDiff) + 18 * 4, (midY - 21) - 1, 18, 18
    elseif slot <= 45 then
      -- 2x2 crafting grid
      return (midX - midXDiff) + 18 * (slot % 2 == 0 and 5 or 6) - 1 - 1, (midY - 64) + 18 * (slot < 44 and 0 or 1) - 1, 18, 18
    elseif slot == 46 then
      -- 2x2 crafting output
      return (midX - midXDiff) + 18 * 8 + 1, (midY - 56) - 1, 18, 18
    end
  end

  if screenIs("crafting_screen") then
    if slot < 46 then
      -- 3x3 crafting grid
      return (midX - midXDiff) + 18 * (-(37 - slot) % 3) + 22, (midY - 67) + 18 * (-(37 - slot) // 3), 18, 18
    elseif slot == 46 then
      -- 3x3 crafting output
      return (midX - midXDiff) + 116, midY - 53, 26, 26
    end
  end

  -- Small chest-like screens
  if screenIs(
    "small_chest_screen",
    "shulker_box_screen",
    "ender_chest_screen",
    "barrel_screen"
  ) then
    -- 27 item slots (36 + 27 = 63)
    if slot > 63 then return -18, -18, 18, 18 end

    return (midX - midXDiff) + 18 * ((slot - 10) % 9), (midY - 116) + 18 * ((slot - 10) // 9), 18, 18
  end

  if screenIs("large_chest_screen") then
    -- 54 item slots (36 + 54 = 90)
    if slot > 90 then return -18, -18, 18, 18 end

    return (midX - midXDiff) + 18 * ((slot - 10) % 9), (midY - 143) + 18 * ((slot - 10) // 9), 18, 18
  end

  if screenIs("furnace_screen", "blast_furnace_screen", "smoker_screen") then
    -- 37 = input, 38 = fuel, 39 = output
    if slot > 39 then return -18, -18, 18, 18 end

    if slot == 37 then
      return midX - 38, midY - 68, 18, 18
    elseif slot == 38 then
      return midX - 38, midY - 30, 18, 18
    else
      return midX + 20, midY - 53, 26, 26
    end
  end

  if screenIs("dropper_screen", "dispenser_screen") then
    -- 9 item slots (36 + 9 = 45)
    if slot > 45 then return -18, -18, 18, 18 end

    return (midX - 49) + 18 * (-(37 - slot) % 3) + 22, (midY - 67) + 18 * (-(37 - slot) // 3), 18, 18
  end

  if screenIs("hopper_screen") then
    -- 5 item slots (36 + 5 = 41)
    if slot > 41 then return -18, -18, 18, 18 end

    return (midX - 45) + 18 * -(37 - slot), midY - 48.5, 18, 18
  end

  if screenIs("anvil_screen") then
    -- 37 = tool, 38 = material, 39 = output
    if slot > 39 then return -18, -18, 18, 18 end

    if slot == 37 then
      return midX - 63, midY - 37, 18, 18
    elseif slot == 38 then
      return midX - 9.5, midY - 37, 18, 18
    else
      return midX + 45.5, midY - 37, 18, 18
    end
  end

  -- TODO: The amount and positioning of slots
  -- depends on a donkey's or llama's strength
  if screenIs("horse_screen") then
    if slot <= 51 then
      local s = -(36 - slot)
      return (midX - 81) + 18 * 4 + 18 * ((s - 1) % 5), (midY - 65) + 18 * ((s - 1) // 5), 18, 18
    end
  end
end

local function slotItem(slot)
  if slot <= 0 then return nil end
  if not screenIs(table.unpack(SUPPORTED_SCREENS)) then return nil end

  if slot <= 36 then return player.inventory().at(slot) end

  if screenIs("inventory_screen") then
    if slot <= 40 then
      local armour = { [37] = "helmet", [38] = "chestplate", [39] = "leggings", [40] = "boots" }
      return player.inventory().armor()[armour[slot]]
    elseif slot == 41 then
      return player.inventory().offhand()
    elseif slot <= 46 then
      local grid = { [42] = 29, [43] = 30, [44] = 31, [45] = 32, [46] = 51 }
      return player.inventory().ui(grid[slot])
    end
  end

  if screenIs("crafting_screen") then
    if slot <= 46 then
      local grid = {
        [37] = 33, [38] = 34, [39] = 35,
        [40] = 36, [41] = 37, [42] = 38,
        [43] = 39, [44] = 40, [45] = 41, [46] = 51
      }
      return player.inventory().ui(grid[slot])
    end
  end

  if screenIs(
    "small_chest_screen",
    "shulker_box_screen",
    "ender_chest_screen",
    "barrel_screen",
    "large_chest_screen",
    "dropper_screen",
    "dispenser_screen",
    "hopper_screen",
    "horse_screen"
  ) then
    if slot <= 90 then
      return player.inventory().screen("container_items", -(36 - slot))
    end
  end

  if screenIs("furnace_screen", "blast_furnace_screen", "smoker_screen") then
    if slot <= 39 then
      return nil --TODO?
    end
  end

  if screenIs("anvil_screen") then
    -- 39 is anvil output, idk how to get that with ui()
    if slot <= 38 then
      return player.inventory().ui(-(36 - slot))
    end
  end
end

local craftingBook = {
  toggle = function () CRAFTINGBOOK_OPEN = not CRAFTINGBOOK_OPEN end,
  position = function ()
    local mdx, mdy = mid()
    return mdx + (CRAFTINGBOOK_OPEN and 98 or -3), mdy - 102, 26, 18
  end,
}

return {
  coords = coords,
  getSlot = slotItem,
  craftingBook = craftingBook,
  SUPPORTED_SCREENS = SUPPORTED_SCREENS,
}
