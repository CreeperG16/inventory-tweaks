---@diagnostic disable: undefined-global

local function shulkerItem(item)
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

  return {
    items = items,
    itemCounts = sortedCounts,
    colour = item.name:gsub("_shulker_box", "")
  }
end

return function ()
  local shulkerBoxes = {}
  for i = 1, 90 do
    shulkerBoxes[i] = shulkerItem(inventory.getSlot(i))
  end

  return shulkerBoxes
end
