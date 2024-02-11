local utils = {}

local keycodes = require('lib.keycodes')
local logger = hs.logger.new('Utils')

function utils.bind(mapping, actionName, pressFn, releaseFn)
   local spec = mapping[actionName]
   if spec then
      if spec.modal then
         spec.modal:bind(spec[1], spec[2], pressFn, releaseFn)
      else
         hs.hotkey.bind(spec[1], spec[2], pressFn, releaseFn)
      end
      if spec.alt then
         mapping = {}
         mapping[actionName] = spec.alt
         utils.bind(mapping, actionName, pressFn, releaseFn)
      end
   end
   return self
end

function utils.systemKeyStroke(mods, key)
   local keycode = keycodes[key:lower()]
   if not keycode then
      logger.e('Key code for "' .. key .. '" not found')
      return
   end

   local script = 'tell application "System Events" to key code ' .. tostring(keycode)
   if mods[1] then
      script = script .. ' using {'
      for i, mod in ipairs(mods) do
         if mod == 'shift' then
            script = script .. ' shift down '
         elseif mod == 'ctrl' then
            script = script .. ' control down '
         elseif mod == 'alt' then
            script = script .. ' option down '
         elseif mod == 'cmd' then
            script = script .. ' command down '
         end
         if mods[i + 1] then
            script = script .. ', '
         end
      end
      script = script .. '}'
   end
   hs.osascript.applescript(script)
end

function utils.startsWith(text, prefix)
   return text:lower():sub(1, #prefix) == prefix:lower()
end

function utils.toSet(obj)
   local set = {}
   for _, v in pairs(obj) do
      set[v] = true
   end
   return set
end

function utils.copy(source, keys)
   local copy = {}
   for _, k in ipairs(keys) do
      copy[k] = source[k]
   end
   return copy
end

function utils.merge(first, second)
   local all = {}
   for k, v in pairs(first) do
      all[k] = v
   end
   for k, v in pairs(second) do
      all[k] = v
   end
   return all
end

function utils.concatLists(first, second)
   local all = {}
   for _, v in ipairs(first) do
      table.insert(all, v)
   end
   for _, v in ipairs(second) do
      table.insert(all, v)
   end
   return all
end

function utils.nilToEmpty(text)
   if not text then
      return ''
   end
   return text
end

function utils.isEmpty(text)
   return utils.nilToEmpty(text) == ''
end

function utils.isNotEmpty(text)
   return not utils.isEmpty(text)
end

function utils.dump(obj)
   _dump(obj, 0)
end

function _dump(obj, level)
   local prefix = _repeat(' ', level)
   if type(obj) == 'table' then
      for k, v in pairs(obj) do
         if type(v) == 'table' then
            print(prefix .. k)
            _dump(v, level + 1)
         else
            print(prefix ..  k .. ' = ' .. tostring(v))
         end
      end
   else
      print(prefix .. tostring(obj))
   end
end

function _repeat(char, count)
   local text = ''
   for i = 1, count do
      text = text .. char
   end
   return text
end


return utils
