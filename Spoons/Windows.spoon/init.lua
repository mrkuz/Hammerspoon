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

function obj:init()
   return self
end

function obj:configure(config)
   return self
end

function obj:start()
   return self
end

function obj:stop()
   return self
end

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping

   local spec = mapping.forceClose
   if spec then
      spec.pressFn = function() self:_forceCloseFocusedWindow() end
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
         name = 'forceClose',
         text = 'Force close focused window',
         subText = '',
         actionFn = function() self:_forceCloseFocusedWindow() end
      }
   }
end

function obj:_forceCloseFocusedWindow()
   local window = hs.window.focusedWindow()
   if window then
      window:close()
   end
end

return obj
