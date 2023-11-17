--- === Windows ===
---
--- Provides windows related functions.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'Windows'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('Windows')

-- Variables
obj._hotkeyMapping = nil

local utils = require('lib.utils')

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping
   utils.bind(mapping, 'forceClose', function() self:_forceCloseWindow() end)
   utils.bind(mapping, 'minimizeAll', function() self:_minimizeAllWindows() end)
   utils.bind(mapping, 'hideAll', function() self:_hideAllWindows() end)
   return self
end

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return {
      {
         name = 'minimizeAll',
         text = 'Minimize all windows',
         actionFn = function() self:_minimizeAllWindows() end
      },
      {
         name = 'hideAll',
         text = 'Hide all windows',
         actionFn = function() self:_hideAllWindows() end
      },
      {
         name = 'forceClose',
         text = 'Force close focused window',
         actionFn = function() self:_forceCloseWindow() end
      }
   }
end

function obj:_forceCloseWindow()
   local window = hs.window.focusedWindow()
   if window then
      window:close()
   end
end

function obj:_minimizeAllWindows()
   self:_forAllWindows(function (window) window:minimize() end)
end

function obj:_hideAllWindows()
   self:_forAllWindows(function (window) window:application():hide() end)
end

function obj:_forAllWindows(callback)
   local currentSpace = hs.spaces.focusedSpace()
   for _, v in ipairs(hs.spaces.windowsForSpace(currentSpace)) do
      local window = hs.window.get(v)
      if window and window:isStandard() and window:isVisible() then
         callback(window)
      end
   end
end

return obj
