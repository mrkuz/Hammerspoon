local mousePasteboard = {}
print("== Module 'mouse-pasteboard' loaded")

local mods = { "cmd" }
local pasteboardName = "secondary"

function mousePasteboard.init()
   -- Copy with left mouse button
   hs.eventtap.new({hs.eventtap.event.types.leftMouseUp},
      function(event)
         local flags = event:getFlags()
         if flags and flags:containExactly(mods) then
            copy()
         end
   end):start()

   -- Paste with middle mouse button
   hs.eventtap.new({hs.eventtap.event.types.otherMouseUp},
      function(event)
         local flags = event:getFlags()
         if flags and flags:containExactly(mods) then
            paste()
         end
   end):start()
end

function copy()
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

function paste()
   local content = hs.pasteboard.getContents(pasteboardName)
   hs.eventtap.keyStrokes(content)
end

return mousePasteboard
