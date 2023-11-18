--- === Commander ===
---
--- Extensible launcher.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'Commander'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('Commander')

obj._chooser = nil
obj._actions = {}
obj._spoons = {}
obj._actionFunctions = nil
obj._choices = nil

local utils = require('lib.utils')
local fzy = require('lib.fzy')

function obj:init()
   self._chooser = hs.chooser.new(function(selection)
         if selection then
            self._actionFunctions[selection.uuid]()
         end
   end)

   self._chooser:queryChangedCallback(function(query)
         if utils.isEmpty(query) then
            self._chooser:choices(self._choices)
            return
         end
         self:_filterChoices(query)
   end)

   return self
end

function obj:bindHotkeys(mapping)
   utils.bind(mapping, 'show', function() self:_show() end)
   return self
end

function obj:registerAction(action)
   table.insert(self._actions, action)
   return self
end

function obj:registerSpoon(spoon)
   table.insert(self._spoons, spoon)
   return self
end

function obj:_buildChoices()
   self._actionFunctions = {}
   self._choices = {}
   for _, action in ipairs(self._actions) do
      local choice = self:_newChoice(action)
      table.insert(self._choices, choice)
      self._actionFunctions[choice.uuid] = action.actionFn
   end
   for _, spoon in ipairs(self._spoons) do
      local actions = spoon:actions()
      local hotkeyMapping = nil
      if spoon.hotkeyMapping then
         hotkeyMapping = spoon:hotkeyMapping()
      end
      if not hotkeyMapping then
         hotkeyMapping = {}
      end

      for _, action in ipairs(actions) do
         local choice = self:_newChoice(action, hotkeyMapping[action.name])
         table.insert(self._choices, choice)
         self._actionFunctions[choice.uuid] = action.actionFn
      end
   end
end

function obj:_filterChoices(query)
   local choices = {}
   for _, choice in ipairs(self._choices) do
      choice.score = fzy.score(query, choice.origText)
      if choice.score > -math.huge then
         table.insert(choices, choice)
      end
   end

   table.sort(choices, function(a, b) return a.score > b.score end)
   self._chooser:choices(choices)
end

function obj:_show()
   self._chooser:query('')
   self:_buildChoices()
   self._chooser:choices(self._choices)
   self._chooser:show()
   return self
end

function obj:_newChoice(action, spec)
   local choice = {}
   choice.uuid = hs.host.uuid()
   choice.origText = action.text
   choice.subText = action.subText
   if spec then
      choice.text = action.text .. self:_prettySpec(spec)
   else
      choice.text = action.text
   end
   if utils.isNotEmpty(action.extraText) then
      choice.text = choice.text .. '   ·   ' .. action.extraText
   end
   return choice
end

function obj:_pretty(spoon, action)
   local text = action.text
   if utils.isNotEmpty(action.extraText) then
      text = text .. '   ·   ' .. action.extraText
   end
   return text
end

function obj:_prettySpec(spec)
   local text = ''
   local set = utils.toSet(spec[1])
   if set['hyper'] then
      text = text .. '✦ '
   end
   if set['shift'] then
      text = text .. '⇧ '
   end
   if set['ctrl'] then
      text = text .. '⌃ '
   end
   if set['alt'] then
      text = text .. '⌥ '
   end
   if set['cmd'] then
      text = text .. '⌘ '
   end
   if utils.isNotEmpty(spec[2]) then
      text = text .. spec[2]:upper()
   end

   if utils.isNotEmpty(text) then
      return '   ·   ' .. text
   end
   return ''
end

return obj
