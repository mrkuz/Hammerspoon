--- === NAME ===
---
--- Adds application menu to commander.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'MenuActions'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('MenuActions')

obj._actions = nil
obj._hotkeyMapping = nil

local utils = require('lib.utils')

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   self:_buildActions()
   return self._actions
end

function obj:_buildActions()
   self._actions = {}
   self._hotkeyMapping = {}
   local menuBar = hs.application.frontmostApplication():getMenuItems()
   self:_processMenuBar(menuBar)
end

function obj:_processMenuBar(menuBar)
   for _, v in ipairs(menuBar) do
      self:_processMenuItem(v, { v.AXTitle }, '')
   end
end

function obj:_processMenuItem(item, path, parents)
   if (item.AXRole == 'AXMenuBarItem' or item.AXRole == 'AXMenuItem') and item.AXEnabled and utils.isNotEmpty(item.AXTitle) then
      if item.AXChildren then
         for _, v in ipairs(item.AXChildren[1]) do
            self:_processMenuItem(v, utils.concatLists(path, { v.AXTitle }), parents .. item.AXTitle .. ' ▶ ')
         end
      else
         local uuid = hs.host.uuid()
         table.insert(
            self._actions,
            {
               name = uuid,
               text = item.AXTitle,
               subText = parents .. item.AXTitle,
               actionFn = function() hs.application.frontmostApplication():selectMenuItem(path) end
            }
         )

         local glyph = hs.application.menuGlyphs[item.AXMenuItemCmdGlyph] or ''
         local charOrGlyph = item.AXMenuItemCmdChar:gsub('[\n\r]', ' ') .. glyph
         local mods = item.AXMenuItemCmdModifiers
         if mods and utils.isNotEmpty(charOrGlyph) then
            self._hotkeyMapping[uuid] = { mods, charOrGlyph }
         end
      end
   end
end

return obj
