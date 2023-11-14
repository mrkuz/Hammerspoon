--- === MouseLocator ===
---
--- Simple spoon for locating the mouse pointer.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MouseLocator"
obj.version = "latest"
obj.author = "Markus Opitz <markus@bitsandbobs.net>"
obj.homepage = "https://github.com/mrkuz/hammerspoon"
obj.license = "MIT - https://opensource.org/license/mit/"

obj.logger = hs.logger.new("MouseLocator")

obj.radius = 40
obj.width = 10
obj.color = { red = 1, blue = 0, green = 0, alpha = 1 }

function obj:init()
   self._circle = hs.drawing.circle(hs.geometry.rect(0, 0, obj.radius * 2, obj.radius * 2))
   self._circle:setStrokeWidth(obj.width)
   self._circle:setStrokeColor(obj.color)
   self._circle:setFill(false)

   self._timer = hs.timer.new(0.05, function() self:_updatePosition() end)
   return self
end

function obj:start() return self end
function obj:stop() return self end

function obj:bindHotkeys(mapping)
   local spec = mapping.toggle
   if spec.modal then
      spec.modal:bind(spec[1], spec[2],
                  function() self:_start() end,
                  function() self:_stop() end)
   else
      hs.hotkey.bind(spec[1], spec[2],
                  function() self:_start() end,
                  function() self:_stop() end)
   end
   return self
end

function obj:_start()
   self:_updatePosition()
   self._circle:show()
   self._timer:start()
end

function obj:_stop()
   self._timer:stop()
   self._circle:hide()
end

function obj:_updatePosition()
   local pos = hs.mouse.absolutePosition()
   self._circle:setTopLeft({ x = pos.x - obj.radius, y = pos.y - obj.radius })
end

return obj
