--- === InputSources ===
---
--- Switch input sources by pressing both shift keys.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'InputSources'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('InputSources')

-- Variables
obj._hotkeyMapping = nil
obj._eventtap = nil

local utils = require('lib.utils')

function obj:init()
   self._eventtap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged },
      function(event)
         local rawFlags = event:rawFlags() & 0xdffffeff
         -- Switch if both shift keys are pressed
         if rawFlags == 131078 then
            self:_switchInputSource()
         end
   end)
   return self
end

function obj:start()
   self._eventtap:start()
   return self
end

function obj:stop()
   self._eventtap:stop()
   return self
end

function obj:actions()
   return {
      {
         name = 'switchIputSource',
         text = 'Switch to next input source',
         extraText = '⇧ ⇧',
         subText = hs.keycodes.currentLayout() .. ' → ' .. self:_nextInputSource(),
         actionFn = function() self:_switchInputSource() end
      }
   }
end

function obj:_switchInputSource()
   local next = self:_nextInputSource()
   hs.keycodes.setLayout(next)
end

function obj:_nextInputSource()
   local layouts = hs.keycodes.layouts()
   local current = hs.keycodes.currentLayout()
   for index, layout in ipairs(layouts) do
      if layout == current then
         if layouts[index + 1] then
            return layouts[index + 1]
         else
            return layouts[1]
         end
      end
   end
end

return obj
