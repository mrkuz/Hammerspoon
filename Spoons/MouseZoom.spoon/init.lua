--- === MouseZoom ===
---
--- Zoom in/out with the mouse wheel.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'MouseZoom'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('MouseZoom')

obj.mods = { 'cmd' }

obj._hotkeyMapping = nil
obj._zoomEventtap = nil

local utils = require('lib.utils')

function obj:init()
   self._zoomEventtap = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel },
      function(event)
         local flags = event:getFlags()
         if flags and flags:containExactly(obj.mods) then
            local delta = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1)
            if delta < 0 then
               utils.systemKeyStroke({ 'cmd' }, 'plus')
            elseif delta > 0 then
               utils.systemKeyStroke({ 'cmd' }, 'minus')
            end
         end
   end)
   return self
end

function obj:start()
   self._zoomEventtap:start()
   return self
end

function obj:stop()
   self._zoomEventtap:stop()
   return
end

return obj
