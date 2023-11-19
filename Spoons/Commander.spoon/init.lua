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
obj._hotkeyMapping = {}
obj._spoons = {}
obj._parentMapping = {}
obj._actionMapping = nil
obj._choices = nil

local utils = require('lib.utils')
local fzy = require('lib.fzy')

function obj:init()
   self._chooser = hs.chooser.new(function(selection)
         if selection then
            local action = self._actionMapping[selection.uuid]
            if action.actionFn then
               action.actionFn()
            else
               self:_show(action.name)
            end
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

function obj:registerAction(spec)
   local action = utils.copy(spec, { 'name', 'text', 'subText', 'extraText', 'parent', 'actionFn' } )
   if not action.name then
      action.name = hs.host.uuid()
   end
   table.insert(self._actions, action)
   if spec[1] and spec[2] and action.actionFn then
      local hotkey = utils.copy(spec, { 1, 2, 'modal' })
      self._hotkeyMapping[action.name] = hotkey
      utils.bind(self._hotkeyMapping, action.name, action.actionFn)
   end
   return self
end

function obj:registerSpoon(spoon, parent)
   table.insert(self._spoons, spoon)
   self._parentMapping[spoon.name] = parent
   return self
end

function obj:_buildChoices(parent)
   self._actionMapping = {}
   self._choices = {}
   for _, action in ipairs(self._actions) do
      if action.parent == parent then
         local choice = self:_newChoice(action, self._hotkeyMapping[action.name])
         table.insert(self._choices, choice)
         self._actionMapping[choice.uuid] = action
      end
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
         local match = false
         if action.parent then
            match = action.parent == parent
         else
            match = self._parentMapping[spoon.name] == parent
         end
         if match then
            local choice = self:_newChoice(action, hotkeyMapping[action.name])
            table.insert(self._choices, choice)
            self._actionMapping[choice.uuid] = action
         end
      end
   end
end

function obj:_filterChoices(query)
   local choices = {}
   for _, choice in ipairs(self._choices) do
      choice.score = fzy.score(query, choice.origText)
      if choice.score == math.huge then
         -- Workaround for bug in fzy
         if utils.startsWith(choice.origText, query) then
            table.insert(choices, choice)
         end
      elseif choice.score > -math.huge then
         table.insert(choices, choice)
      end
   end

   table.sort(choices, function(a, b) return a.score > b.score end)
   self._chooser:choices(choices)
end

function obj:_show(parent)
   self._chooser:choices({})
   self._chooser:query('')
   self:_buildChoices(parent)
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
   if not action.actionFn then
      choice.text = choice.text .. ' … '
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
   local mods = utils.toSet(spec[1])
   if mods['hyper'] then
      text = text .. '✦ '
   end
   if mods['shift'] then
      text = text .. '⇧ '
   end
   if mods['ctrl'] then
      text = text .. '⌃ '
   end
   if mods['alt'] then
      text = text .. '⌥ '
   end
   if mods['cmd'] then
      text = text .. '⌘ '
   end

   local key = spec[2]
   if utils.isNotEmpty(key) then
      if key == 'left' then
         text = text .. '←'
      elseif key == 'right' then
         text = text .. '→'
      elseif key == 'up' then
         text = text .. '↑'
      elseif key == 'down' then
         text = text .. '↓'
      elseif key == 'space' then
         text = text .. 'SPC'
      else
         text = text .. key:upper()
      end
   end

   if utils.isNotEmpty(text) then
      return '   ·   ' .. text
   end
   return ''
end

return obj
