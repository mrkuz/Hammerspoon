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
local fzy = require('lib.fzy')

function obj:init()
   self._chooser = hs.chooser.new(function(selection)
         if selection then
            self._actions[selection.uuid]()
         end
   end)

   self._chooser:queryChangedCallback(function(query)
         if utils.isEmpty(query) then
            self._chooser:choices(self._choices)
            return
         end
         self:_filterChoices(query)
   end)

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

function obj:_buildChoices()
   self._actions = {}
   self._choices = {}
   for _, spoon in ipairs(self._spoons) do
      local actions = spoon:actions()
      for _, action in ipairs(actions) do
         local choice = {
            uuid = hs.host.uuid(),
            text = self:_pretty(spoon, action),
            origText = action.text,
            subText = action.subText
         }
         table.insert(self._choices, choice)
         self._actions[choice.uuid] = action.actionFn
      end
   end
end

function obj:_filterChoices(query)
   local choices = {}
   for _, choice in ipairs(self._choices) do
      choice.score = fzy.score(query, choice.origText)
      if choice.score > 0 then
         table.insert(choices, choice)
      end
   end

   table.sort(choices, function(a, b) return a.score > b.score end)
   self._chooser:choices(choices)
end

function obj:_show()
   self._chooser:query("")
   self:_buildChoices()
   self._chooser:choices(self._choices)
   self._chooser:show()
   return self
end

function obj:_pretty(spoon, action)
   local hotkeyMapping = spoon:hotkeyMapping()
   if hotkeyMapping then
      local spec = hotkeyMapping[action.name]
      if spec then
         return action.text .. self:_prettySpec(spec)
      end
   end
   return action.text
end

function obj:_prettySpec(spec)
   local text = ''
   local set = utils.toSet(spec[1])
   if set["hyper"] then
      text = text .. '✦ '
   end
   if set["shift"] then
      text = text .. '⇧ '
   end
   if set["ctrl"] then
      text = text .. '⌃ '
   end
   if set["alt"] then
      text = text .. '⌥ '
   end
   if set["cmd"] then
      text = text .. '⌘ '
   end
   if utils.isNotEmpty(spec[2]) then
      text = text .. spec[2]:upper()
   end

   if utils.isNotEmpty(text) then
      return "   ·   " .. text
   end
   return ''
end

return obj
