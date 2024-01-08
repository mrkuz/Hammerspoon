--- === Caffeine ===
---
--- Prevents display from turning off when inactive.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'Caffeine'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('Caffeine')

-- Variables
obj._hotkeyMapping = nil
obj._enabled = nil
obj._menubar = nil

local utils = require('lib.utils')

function obj:init()
   self._enabled = hs.caffeinate.get('displayIdle')
   self._menubar = hs.menubar.new(true, 'Caffeine')
   self:_updateMenubar()
   return self
end

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping
   utils.bind(mapping, 'toggle', function() self:_toggle() end)
   return self
end

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return {
      {
         name = 'toggle',
         text = 'Prevent display sleep',
         subText = self:_getSubText(),
         actionFn = function() self:_toggle() end
      }
   }
end

function obj:_toggle()
   self._enabled = not self._enabled
   self:_updateMenubar()
   hs.caffeinate.set('displayIdle', self._enabled, true)
end

function obj:_updateMenubar()
   if self._enabled then
      self._menubar:setTitle('☕')
   else
      self._menubar:setTitle('')
   end
end

function obj:_getSubText()
   if self._enabled then
      return 'Status: on'
   else
      return 'Status: off'
   end
end

return obj
