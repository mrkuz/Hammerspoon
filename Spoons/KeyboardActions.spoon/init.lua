--- === ShellActions ===
---
--- Adds custom shell commands to Commander.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'ShellActions'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('ShellActions')

obj._actions = {}
obj._hotkeyMapping = {}

local utils = require('lib.utils')

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return self._actions;
end

function obj:registerAction(spec)
   local action = utils.copy(spec, { 'name', 'text', 'subText', 'extraText', 'parent' } )
   if spec.system then
      action.actionFn = function() utils.systemKeyStroke(spec[1], spec[2]) end
   else
      action.actionFn = function() hs.eventtap.keyStroke(spec[1], spec[2]) end
   end

   if not action.name then
      action.name = hs.host.uuid()
   end
   table.insert(self._actions, action)
   self._hotkeyMapping[action.name] = utils.copy(spec, { 1, 2 })
   return self
end

return obj

