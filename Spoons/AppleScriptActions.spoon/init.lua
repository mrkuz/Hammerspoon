--- === AppleScriptActions ===
---
--- Adds custom AppleScript to Commander.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'AppleScriptActions'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('AppleScriptActions')

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
   action.actionFn = function() hs.osascript.applescript(spec.script) end
   if not action.name then
      action.name = hs.host.uuid()
   end
   table.insert(self._actions, action)

   if spec[1] and spec[2] then
      local hotkey = utils.copy(spec, { 1, 2, 'modal' })
      self._hotkeyMapping[action.name] = hotkey
      utils.bind(self._hotkeyMapping, action.name, action.actionFn)
   end
   return self
end

return obj
