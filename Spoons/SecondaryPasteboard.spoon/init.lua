--- === SecondaryPasteboard ===
---
--- Adds secondary pasteboard which can be utilized by mouse.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'SecondaryPasteboard'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('SecondaryPasteboard')

obj.mods = { 'cmd' }

obj._hotkeyMapping = nil
obj._content = nil
obj._copyEventtap = nil
obj._pasteEventtap = nil
obj._copyWatcher = nil
obj._capture = false
obj._skip = false
obj._backup = nil

local utils = require('lib.utils')

function obj:init()
   -- Copy with left mouse button
   self._copyEventtap = hs.eventtap.new({ hs.eventtap.event.types.leftMouseUp },
      function(event)
         local flags = event:getFlags()
         if flags and flags:containExactly(obj.mods) then
            self:_copy()
         end
   end)

   -- Paste with middle mouse button
   self._pasteEventtap = hs.eventtap.new({ hs.eventtap.event.types.otherMouseUp },
      function(event)
         local flags = event:getFlags()
         if flags and flags:containExactly(obj.mods) then
            self:_paste()
         end
   end)

   self._copyWatcher = hs.pasteboard.watcher.new(
      function(content)
         if content then
            if self._skip then
               self._skip = false
            elseif self._capture then
               self._capture = false
               self._content = content
               hs.pasteboard.setContents(self._backup)
            else
               self._backup = content
            end
         end
   end)

   return self
end

function obj:start()
   self._copyEventtap:start()
   self._pasteEventtap:start()
   return self
end

function obj:stop()
   self._copyEventtap:stop()
   self._pasteEventtap:stop()
   return
end

function obj:actions()
   local actions = {}
   table.insert(
      actions,
      {
         name = 'copy',
         text = 'Copy to secondary pasteboard',
         extraText = '⌘ LMB',
         actionFn = function() self:_copy() end
      }
   )
   if self._content then
      table.insert(
         actions,
         {
            name = 'paste',
            text = 'Paste from secondary pasteboard',
            extraText = '⌘ MMB',
            actionFn = function() self:_paste() end
         }
      )
   end
   return actions
end

function obj:_copy()
   self._capture = true
   utils.systemKeyStroke({ 'cmd' }, 'c')
end

function obj:_paste()
   if self._content then
      self._skip = true
      hs.pasteboard.setContents(self._content)
      utils.systemKeyStroke({ 'cmd' }, 'v')
      hs.pasteboard.setContents(self._backup)
   end
end

return obj
