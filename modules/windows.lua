local module = {}

local hyper = require('modules.hyperkey').modal

function _init()
   print("== Module 'windows' loaded")
   hyper:bind({ "cmd" }, "m", nil, function()
         _forAllWindows(function (window)
               window:minimize()
         end)
   end)
   hyper:bind({ "cmd" }, "h", nil, function()
         _forAllWindows(function (window)
               window:application():hide()
         end)
   end)
end

function _forAllWindows(callback)
   local currentSpace = hs.spaces.focusedSpace()
   for k, v in pairs(hs.spaces.windowsForSpace(currentSpace)) do
      local window = hs.window.get(v)
      if window and window:isStandard() and window:isVisible() then
         callback(window)
      end
   end
end

_init()
return module
