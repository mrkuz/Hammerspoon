local module = {}

function _init()
   print("== Module 'toggle-input-sources' loaded")
   hs.eventtap.new({hs.eventtap.event.types.flagsChanged},
   function(event)
      local rawFlags = event:rawFlags() & 0xdffffeff
      -- Switch if both shift keys are pressed
      if rawFlags == 131078 then
         local layouts = hs.keycodes.layouts()
         local current = hs.keycodes.currentLayout()
         for index, layout in pairs(layouts) do
            if layout == current then
               if layouts[index + 1] then
                  hs.keycodes.setLayout(layouts[index + 1])
               else
                  hs.keycodes.setLayout(layouts[1])
               end
            end
         end
      end
   end):start()
end

_init()
return module
