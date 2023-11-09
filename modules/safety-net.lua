local module = {}

function module.init()
   print("== Module 'safety-net' loaded")
   hs.hotkey.bind({ "cmd" }, "w", function()
         local window = hs.window.focusedWindow()
         if window then
            local result = hs.dialog.blockAlert("Close window?", "", "Yes", "No")
            if result == "Yes" then
               window:close()
            end
         end
   end, nil)

   hs.hotkey.bind({ "cmd", "ctrl" }, "w", function()
         local window = hs.window.focusedWindow()
         if window then
            window:close()
         end
   end, nil)
end

return module
