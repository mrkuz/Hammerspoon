local module = {}

function module.init()
   print("== Module 'safety-net' loaded")
   hs.hotkey.bind({ "cmd" }, "w", nil, function()
         local window = hs.window.focusedWindow()
         if window then
            local result = hs.dialog.blockAlert("Close window?", "", "Yes", "No")
            if result == "Yes" then
               window:close()
            end
         end
   end)

   hs.hotkey.bind({ "cmd", "ctrl" }, "w", nil, function()
         local window = hs.window.focusedWindow()
         if window then
            window:close()
         end
   end)
end

return module
