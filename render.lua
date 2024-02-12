---@diagnostic disable: undefined-global

-- Thanks onix for the tinting stuff
local colourMult = { r = 1, g = 1, b = 1, a = 1 }
local function setColour(r, g, b, a) gfx.color(r * colourMult.r, g * colourMult.g, b * colourMult.b, (a or 255) * colourMult.a) end
local function setTint(r, g, b, a) colourMult = { r = (r or 255) / 255, g = (g or 255) / 255, b = (b or 255) / 255, a = (a or 255) / 255 } end

local COLOURS = {
  white = "e4e9e9",
  light_gray = "8b8282",
  gray = "3e4246",
  black = "1f1f23",
  brown = "724728",
  red = "9a2422",
  orange = "f4730f",
  yellow = "fcc724",
  lime = "71bc18",
  green = "546d1c",
  cyan = "168691",
  light_blue = "3ab3da",
  blue = "33359b",
  purple = "7426a9",
  magenta = "b93eae",
  pink = "f38aa9",

  undyed = "ffffff"
}

local function renderBackground(x, y, w, h)
  setColour(0xc6, 0xc6, 0xc6)
  gfx.rect(x, y, w, h)

  setColour(0xff, 0xff, 0xff)
  gfx.rect(x, MY() - h - 12, w, 2)
  gfx.rect(x, MY() - h - 12, 2, h)

  setColour(0x55, 0x55, 0x55, 128)
  gfx.rect(x + w - 2, y, 2, h)
  gfx.rect(x, y + h - 2, w, 2)

  setColour(0, 0, 0)
  gfx.drawRect(x - 1, MY() - h - 13, w + 2, h + 2, 1)
end

local function itemCountText(count, slotX, slotY)
  if count == 1 then return end
  local countText = tostring(count)

  if settings.countView.value == 2 then
    countText = tostring((count + 63) // 64) .. "s"
  elseif settings.countView.value == 3 then
    local stacks = count // 64
    countText = stacks == 0 and tostring(count) or (tostring(stacks) .. "s")
  end

  -- Autocomplete typo xd (minecrafttia??? too much t)
  ---@diagnostic disable-next-line: undefined-field
  local textScale = gui.font().isMinecraftia and 1 or 1.2

  local tW, tH = gui.font().width(countText, textScale), gui.font().height * textScale
  gfx.color(255, 255, 255)
  gfx.text(slotX + 17 - tW, slotY + 17 - tH, countText, textScale)
end

local function drawSlot(slotX, slotY)
  setColour(0x8b, 0x8b, 0x8b)
  gfx.rect(slotX, slotY, 16, 16)

  setColour(0x37, 0x37, 0x37)
  gfx.rect(slotX - 1, slotY - 1, 1, 18)
  gfx.rect(slotX - 1, slotY - 1, 18, 1)

  setColour(0xff, 0xff, 0xff)
  gfx.rect(slotX - 1, slotY + 16, 18, 1)
  gfx.rect(slotX + 16, slotY - 1, 1, 18)
end

local function renderItemCounts(shulker, bgW, bgH, renderLeft)
  local i = 0

  for _, itemCount in ipairs(shulker.itemCounts) do
    local slotX = (MX() + 16) + 18 * (i % 9)
    local slotY = (MY() - bgH - 7) + 18 * (i // 9)

    if renderLeft then slotX = slotX - bgW - 22 end

    drawSlot(slotX, slotY)

    local item = getItem(itemCount[1])
    item.count = itemCount[2]

    ---@diagnostic disable-next-line: param-type-mismatch
    gfx.item(slotX, slotY, item)

    itemCountText(itemCount[2], slotX, slotY)

    i = i + 1
  end
end

local function renderItemSlots(shulker, bgW, bgH, renderLeft)
  for i = 0, 26 do
    local slotX = (MX() + 16) + 18 * (i % 9)
    local slotY = (MY() - bgH - 7) + 18 * (i // 9)

    if renderLeft then slotX = slotX - bgW - 22 end

    drawSlot(slotX, slotY)

    if not shulker.items[i] then goto cont end

    local item = itemFromNbt(shulker.items[i])

    ---@diagnostic disable-next-line: param-type-mismatch
    gfx.item(slotX, slotY, item, 1, true)

    ::cont::
  end
end

return function(shulker, counts)
  local bgW = (counts and (#shulker.itemCounts < 9 and #shulker.itemCounts or 9) or 9) * 18 + 8
  local bgH = (counts and #shulker.itemCounts // 9 + 1 or 3) * 18 + 8

  local bgX, bgY = MX() + 11, MY() - bgH - 12

  local renderLeft = bgX + bgW > gui.width()
  if renderLeft then bgX = MX() - bgW - 11 end

  if shulker.colour and settings.colouredShulkers.value then
    local hex = tonumber(COLOURS[shulker.colour], 16)
    local r, g, b = (hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff

    setTint(r, g, b)
  else
    setTint(255, 255, 255)
  end

  renderBackground(bgX, bgY, bgW, bgH)

  if counts then
    renderItemCounts(shulker, bgW, bgH, renderLeft)
  else
    renderItemSlots(shulker, bgW, bgH, renderLeft)
  end
end
