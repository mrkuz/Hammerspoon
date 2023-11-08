local module = {}

local mods = { "cmd" }
local pasteboardName = "secondary"

function module.init()
   print("== Module 'mouse-pasteboard' loaded")
   -- Copy with left mouse button
   hs.eventtap.new({hs.eventtap.event.types.leftMouseUp},
      function(event)
         local flags = event:getFlags()
         if flags and flags:containExactly(mods) then
            _copy()
         end
   end):start()

   -- Paste with middle mouse button
   hs.eventtap.new({hs.eventtap.event.types.otherMouseUp},
      function(event)
         local flags = event:getFlags()
         if flags and flags:containExactly(mods) then
            _paste()
         end
   end):start()
end

function _copy()
   local primaryPasteboardBackup = hs.pasteboard.getContents()
   -- Send CMD + C
   hs.osascript.applescript('tell application "System Events" to key code 8 using command down')
   hs.timer.doAfter(
      -- Wait a short time so the content is available in the primary pasteboard
      0.1,
      function()
         local content = hs.pasteboard.getContents()
         hs.pasteboard.setContents(primaryPasteboardBackup)
         hs.pasteboard.setContents(content, pasteboardName)
   end)
end

function _paste()
   local content = hs.pasteboard.getContents(pasteboardName)
   hs.eventtap.keyStrokes(content)
end

return module
