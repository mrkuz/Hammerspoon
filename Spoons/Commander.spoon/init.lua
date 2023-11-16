--- === Commander ===
---
--- Extensible launcher.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Commander"
obj.version = "latest"
obj.author = "Markus Opitz <markus@bitsandbobs.net>"
obj.homepage = "https://github.com/mrkuz/hammerspoon"
obj.license = "MIT - https://opensource.org/license/mit/"

obj.logger = hs.logger.new("Commander")

local utils = require('lib.utils')

function obj:init()
   self._chooser = hs.chooser.new(function(selection)
         if selection then
            self._actions[selection.uuid]()
         end
   end)

   self._chooser:choices(function()
         self._actions = {}
         local choices = {}
         for _, spoon in ipairs(self._spoons) do
            local actions = spoon:actions()
            for _, action in ipairs(actions) do
               local choice = {
                  uuid = hs.host.uuid(),
                  text = action.text,
                  subText = action.subText
               }
               table.insert(choices, choice)
               self._actions[choice.uuid] = action.actionFn
            end
         end
         return choices
   end)
   self._chooser:searchSubText(true)
   self._spoons = {}
   return self
end

function obj:start() return self end
function obj:stop() return self end

function obj:bindHotkeys(mapping)
   local spec = mapping.show
   spec.pressFn = function() self:_show() end
   utils.bindSpec(spec)
   return self
end

function obj:register(spoon)
   table.insert(self._spoons, spoon)
   return self
end

function obj:_show()
   self._chooser:query("")
   self._chooser:refreshChoicesCallback()
   self._chooser:show()
   return self
end

return obj
