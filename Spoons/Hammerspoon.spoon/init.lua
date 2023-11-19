--- === Hammerspoon ===
---
--- Provides Hammerspoon related functions.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'Hammerspoon'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('Hammerspoon')

obj._hotkeyMapping = nil

local utils = require('lib.utils')

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping
   utils.bind(mapping, 'reloadConfig', function() self:_reloadConfig() end)
   return self
end

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return {
      {
         name = 'reloadConfig',
         text = 'Reload Hammerspoon config',
         actionFn = function() self:_reloadConfig() end
      }
   }
end

function obj:_reloadConfig()
   hs.console.clearConsole()
   hs.openConsole()
   hs.reload()
end

return obj
