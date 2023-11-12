local module = {}

local hyper = require('modules.hyperkey').modal
local utils = require('modules.utils')

local radius = 40

function _init()
   print("== Module 'locate-mouse' loaded")

   local circle = hs.drawing.circle(hs.geometry.rect(0, 0, radius * 2, radius * 2))
   circle:setStrokeColor({ red = 1, blue = 0, green = 0, alpha = 1 })
   circle:setFill(false)
   circle:setStrokeWidth(10)

   local timer = hs.timer.new(0.05, function() circle:setTopLeft(_calculatePosition()) end)

   hyper:bind({}, "w",
      function()
         circle:setTopLeft(_calculatePosition())
         circle:show()
         timer:start()
      end,
      function()
         timer:stop()
         circle:hide()
   end)
end

function _calculatePosition()
   local pos = hs.mouse.absolutePosition()
   return { x = pos.x - radius, y = pos.y - radius }
end

_init()
return module
