local module = {}

function _init()
   print("== Module 'utils' loaded")
end

function module.isNotEmpty(text)
   return not module.isEmpty(text)
end

function module.isEmpty(text)
   return text == nil or text == ''
end

function module.concat(first, second)
   local all = {}
   for k, v in pairs(first) do
      table.insert(all, v)
   end
   for k, v in pairs(second) do
      table.insert(all, v)
   end
   return all
end

function module.dump(obj)
   _dump(obj, 0)
end

function _dump(obj, level)
   local prefix = _prefix(' ', level)
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

function _prefix(char, count)
   local prefix = ''
   for i = 1, count do
         prefix = prefix .. char
   end
   return prefix
end

_init()
return module
