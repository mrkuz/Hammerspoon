--- === MouseLocator ===
---
--- Locating the mouse pointer.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'MouseLocator'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('MouseLocator')

obj.radius = 40
obj.width = 10
obj.color = { red = 1, blue = 0, green = 0, alpha = 1 }

obj._hotkeyMapping = nil
obj._circle = nil
obj._timer = nil

local utils = require('lib.utils')

function obj:init()
   self._circle = hs.drawing.circle(hs.geometry.rect(0, 0, obj.radius * 2, obj.radius * 2))
   self._circle:setStrokeWidth(obj.width)
   self._circle:setStrokeColor(obj.color)
   self._circle:setFill(false)

   self._timer = hs.timer.new(0.05, function() self:_updatePosition() end)
   return self
end

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping
   utils.bind(mapping, 'toggle', function() self:_start() end, function() self:_stop() end)
   return self
end

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return {
      {
         name = 'toggle',
         text = 'Where is my mouse?',
         subText = self:_getSubText(),
         actionFn = function() self:_toggle() end
      }
   }
end

function obj:_start()
   if not self._timer:running() then
      self:_updatePosition()
      self._circle:show()
      self._timer:start()
   end
end

function obj:_stop()
   if self._timer:running() then
      self._timer:stop()
      self._circle:hide()
   end
end

function obj:_toggle()
   if self._timer:running() then
      self:_stop()
   else
      self:_start()
   end
end

function obj:_updatePosition()
   local pos = hs.mouse.absolutePosition()
   self._circle:setTopLeft({ x = pos.x - obj.radius, y = pos.y - obj.radius })
end

function obj:_getSubText()
   if self._timer:running() then
      return 'Status: on'
   else
      return 'Status: off'
   end
end

return obj
