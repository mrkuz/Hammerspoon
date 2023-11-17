--- === NAME ===
---
--- DESCRIPTION.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'NAME'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('NAME')

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

   local spec = mapping.ACTION_NAME
   if spec then
      spec.pressFn = function() self:_PRESS_FN() end
      spec.releaseFn = function() self:_RELEASE_FN() end
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
         name = 'ACTION_NAME',
         text = 'COMMANDER_TEXT',
         subText = '',
         actionFn = function() self:_ACTION_FN() end
      }
   }
end

function obj:_PRESS_FN()
end

function obj:_RELEASE_FN()
end

function obj:_ACTION_FN()
end

return obj
