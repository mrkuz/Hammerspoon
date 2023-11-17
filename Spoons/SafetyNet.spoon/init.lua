--- === SafetyNet ===
---
--- Ask for confirmation when invoking risky keyboard shortcuts.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'SafetyNet'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('SafetyNet')

local utils = require('lib.utils')

function obj:init()
   hs.hotkey.bind({ 'cmd' }, 'w', function()
         local window = hs.window.focusedWindow()
         if window then
            local result = hs.dialog.blockAlert('Close window?', '', 'Yes', 'No')
            if result == 'Yes' then
               window:close()
            end
         end
   end)
   return self
end

return obj
