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

   local spec = mapping.forceClose
   if spec then
      spec.pressFn = function() self:_forceCloseWindow() end
      utils.bindSpec(spec)
   end
   spec = mapping.minimizeAll
   if spec then
      spec.pressFn = function() self:_minimizeAllWindows() end
      utils.bindSpec(spec)
   end
   spec = mapping.hideAll
   if spec then
      spec.pressFn = function() self:_hideAllWindows() end
      utils.bindSpec(spec)
   end

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
         subText = '',
         actionFn = function() self:_minimizeAllWindows() end
      },
      {
         name = 'hideAll',
         text = 'Show desktop (hide all windows)',
         subText = '',
         actionFn = function() self:_hideAllWindows() end
      },
      {
         name = 'forceClose',
         text = 'Force close focused window',
         subText = '',
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
