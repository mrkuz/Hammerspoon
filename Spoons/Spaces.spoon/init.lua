--- === Spaces ===
---
--- Provides functions related to spaces.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'Spaces'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('Spaces')

obj.mods = { "ctrl", "shift" }
obj.spaces = 9

obj._hotkeyMapping = {
   switchToRight = { { 'ctrl' }, 'right' },
   switchToLeft = { { 'ctrl' } , 'left' },
   moveWindowRight = { obj.mods, 'right' },
   moveWindowLeft = { obj.mods, 'left' },
}

local utils = require('lib.utils')

function obj:init()
   self._actions = {
      {
         name = 'switchToRight',
         text = 'Switch to next space',
         actionFn = function() self:_switchToRight() end
      },
      {
         name = 'switchToLeft',
         text = 'Switch to previous space',
         actionFn = function() self:_switchToLeft() end
      },
      {
         name = 'switchToX',
         text = 'Switch to space'
      },
      {
         name = 'moveWindowRight',
         text = 'Move window to next space',
         actionFn = function() self:_moveFocusedWindowRight() end
      },
      {
         name = 'moveWindowLeft',
         text = 'Move window to previous space',
         actionFn = function() self:_moveFocusedWindowLeft() end
      },
      {
         name = 'moveWindowToX',
         text = 'Move window to space'
      }
   }
end

function obj:start()
   for i = 1, obj.spaces do
      local index = tostring(i)
      hs.hotkey.bind(obj.mods, index, nil, function() self:_moveFocusedWindowTo(i) end)
      table.insert(
         self._actions,
            {
               parent = 'switchToX',
               name = 'switchTo' .. index,
               text = 'Switch to space ' .. index,
               actionFn = function() self:_switchTo(i) end
            }
      )
      table.insert(
         self._actions,
            {
               parent = 'moveWindowToX',
               name = 'moveWindowTo' .. index,
               text = 'Move window to space ' .. index,
               actionFn = function() self:_moveFocusedWindowTo(i) end
            }
      )
      self._hotkeyMapping['switchTo' .. index] = { { 'ctrl' }, index }
      self._hotkeyMapping['moveWindowTo' .. index] = { obj.mods, index }
   end

   hs.hotkey.bind(obj.mods, 'left', nil, function() self:_moveFocusedWindowLeft() end)
   hs.hotkey.bind(obj.mods, 'right', nil, function() self:_moveFocusedWindowRight() end)
   return self
end

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return self._actions
end

function obj:_currentSpaceIndex()
   local spaces = hs.spaces.spacesForScreen()
   local current = hs.spaces.focusedSpace()
   for k, v in ipairs(spaces) do
      if v == current then
         return k
      end
   end
end

function obj:_moveFocusedWindowLeft()
   local index = self:_currentSpaceIndex()
   self:_moveFocusedWindowTo(index - 1)
end

function obj:_moveFocusedWindowRight()
   local index = self:_currentSpaceIndex()
   self:_moveFocusedWindowTo(index + 1)
end

function obj:_moveFocusedWindowTo(index)
   local spaces = hs.spaces.spacesForScreen()
   local window = hs.window.focusedWindow()
   if window and spaces[index] then
      hs.spaces.moveWindowToSpace(window, spaces[index])
      self:_switchTo(index)
      hs.timer.doAfter(0.5, function() window:focus() end)
   end
end

function obj:_switchToLeft()
   local index = self:_currentSpaceIndex()
   self:_switchTo(index - 1)
end

function obj:_switchToRight()
   local index = self:_currentSpaceIndex()
   self:_switchTo(index + 1)
end

function obj:_switchTo(index)
   hs.eventtap.keyStroke({ 'ctrl' }, tostring(index))
end

return obj
