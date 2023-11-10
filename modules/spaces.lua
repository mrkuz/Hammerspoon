local module = {}

function module.init()
   print("== Module 'spaces' loaded")
   for i = 1, 9 do
      hs.hotkey.bind({ "ctrl", "shift" }, tostring(i), nil, function()
            _moveFocusedWindowTo(i)
      end)
   end

   hs.hotkey.bind({ "ctrl", "shift" }, "left", nil, function()
         local index = _focusedSpaceIndex()
         _moveFocusedWindowTo(index - 1)
   end)

   hs.hotkey.bind({ "ctrl", "shift" }, "right", nil, function()
         local index = _focusedSpaceIndex()
         _moveFocusedWindowTo(index + 1)
   end)
end

function _focusedSpaceIndex()
   local spaces = hs.spaces.spacesForScreen()
   local current = hs.spaces.focusedSpace()
   for k, v in pairs(spaces) do
      if v == current then
         return k
      end
   end
end

function _moveFocusedWindowTo(index)
   local spaces = hs.spaces.spacesForScreen()
   local window = hs.window.focusedWindow()
   if window and spaces[index] then
      hs.spaces.moveWindowToSpace(window, spaces[index])
      hs.eventtap.event.newKeyEvent({"ctrl"}, tostring(index), true):post()
      hs.eventtap.event.newKeyEvent({"ctrl"}, tostring(index), false):post()
      hs.timer.doAfter(0.5, function() window:focus() end)
   end
end

return module
