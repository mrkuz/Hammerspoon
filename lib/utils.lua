local utils = {}

function utils.bindSpec(spec)
   if spec.modal then
      spec.modal:bind(spec[1], spec[2], spec.pressFn, spec.releaseFn)
   else
      hs.hotkey.bind(spec[1], spec[2], spec.pressFn, spec.releaseFn)
   end
   return self
end

function utils.toSet(obj)
   local set = {}
   for _, v in pairs(obj) do
      set[v] = true
   end
   return set
end

function utils.isNotEmpty(text)
   return not utils.isEmpty(text)
end

function utils.isEmpty(text)
   return text == nil or text == ''
end

function utils.dump(obj)
   _dump(obj, 0)
end

function _dump(obj, level)
   local prefix = _repeat(' ', level)
   if type(obj) == "table" then
      for k, v in pairs(obj) do
         if type(v) == "table" then
            print(prefix .. k)
            _dump(v, level + 1)
         else
            print(prefix ..  k .. " = " .. tostring(v))
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
