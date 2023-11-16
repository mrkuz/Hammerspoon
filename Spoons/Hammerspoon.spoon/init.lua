--- === Hammerspoon ===
---
--- Provides Hammerspoon related functions.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Hammerspoon"
obj.version = "latest"
obj.author = "Markus Opitz <markus@bitsandbobs.net>"
obj.homepage = "https://github.com/mrkuz/hammerspoon"
obj.license = "MIT - https://opensource.org/license/mit/"

obj.logger = hs.logger.new("Hammerspoon")

local utils = require('lib.utils')

function obj:init() return self end
function obj:start() return self end
function obj:stop() return self end

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping

   local spec = mapping.reloadConfig
   if spec then
      spec.pressFn = function() self:_reloadConfig() end
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
         name = "reloadConfig",
         text = "Reload Hammerspoon config",
         subText = "",
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
