local module = {}

local hyper = require('modules.hyperkey').modal
local utils = require('modules.utils')

function _init()
   print("== Module 'select-menu' loaded")
   local chooser = hs.chooser.new(function(selection)
         if selection then
            hs.application.frontmostApplication():selectMenuItem(selection.path)
         end
   end)
   chooser:choices(function()
         local app = hs.application.frontmostApplication()
         local menuItems = app:getMenuItems()
         return _processMenuBar(menuItems)
   end)
   chooser:searchSubText(true)

   hyper:bind({}, "space", nil, function() _showChooser(chooser) end)
end

function _showChooser(chooser)
   chooser:query("")
   chooser:refreshChoicesCallback()
   chooser:show()
end

function _processMenuBar(menuBar)
   local processed = {}
   for k, v in pairs(menuBar) do
      _processMenuItem(processed, v, { v.AXTitle }, '')
   end
   return processed
end

function _processMenuItem(processed, item, path, parents)
   if (item.AXRole == "AXMenuBarItem" or item.AXRole == "AXMenuItem") and item.AXEnabled and utils.isNotEmpty(item.AXTitle) then
      if item.AXChildren then
         for k, v in pairs(item.AXChildren[1]) do
            _processMenuItem(processed, v, utils.concat(path, { v.AXTitle }), parents .. item.AXTitle .. " ▶ ")
         end
      else
         table.insert(processed, {
            path = path,
            text = _pretty(item),
            subText = parents .. item.AXTitle
         })
      end
   end
end

function _pretty(item)
   local glyph = hs.application.menuGlyphs[item.AXMenuItemCmdGlyph] or ''
   local charOrGlyph = item.AXMenuItemCmdChar:gsub("[\n\r]", " ") .. glyph
   if item.AXMenuItemCmdModifiers and utils.isNotEmpty(charOrGlyph) then
      local mods = ''
      local modsTable = {}
      for k, v in pairs(item.AXMenuItemCmdModifiers) do
         modsTable[v] = k
      end
      if modsTable["shift"] then
         mods = mods .. '⇧ '
      end
      if modsTable["ctrl"] then
         mods = mods .. '⌃ '
      end
      if modsTable["alt"] then
         mods = mods .. '⌥ '
      end
      if modsTable["cmd"] then
         mods = mods .. '⌘ '
      end
      return item.AXTitle .. " • " .. mods .. charOrGlyph
   end

   return item.AXTitle
end

_init()
return module
