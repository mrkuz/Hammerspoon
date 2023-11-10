local module = {}

local key = "F20"

function _init(mods)
   print("== Module 'hyperkey' loaded")
   local modal = hs.hotkey.modal.new()
   -- Map caps lock to F20 (see: https://developer.apple.com/library/archive/technotes/tn2450/_index.html#//apple_ref/doc/uid/DTS40017618-CH1-KEY_TABLE_USAGES)
   local status = hs.execute("hidutil property --set '{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\": 0x700000039, \"HIDKeyboardModifierMappingDst\": 0x70000006F}]}'")
   if not status then
      print("== Remapping caps lock failed")
   end

   hs.hotkey.bind({}, key,
      function() modal:enter() end,
      function() modal:exit() end)

   module.modal = modal
end

_init()
return module
