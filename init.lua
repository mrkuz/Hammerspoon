require('modules.hammerspoon')
-- Ordering is important, as it can break things (but no idea why)
require('modules.shortcuts')
require('modules.mouse-pasteboard')
require('modules.safety-net')
require('modules.select-menu')
require('modules.spaces')
require('modules.toggle-input-sources')
require('modules.windows')

local emacsSocket = "/var/folders/tm/s0rmv44130v_l7p3jynpdkm00000gn/T/emacs501/default"
local hyper = require('modules.hyperkey').modal

hs.loadSpoon("MouseLocator"):bindHotkeys({
      toggle = { {}, "m", modal = hyper }
})

hyper:bind({}, "e", nil, function()
      hs.execute("emacsclient --socket-name " .. emacsSocket .. " -n -c", true)
end)

hyper:bind({}, "h", nil, function()
      hs.execute("open $HOME", true)
end)

hyper:bind({}, "j", nil, function()
      hs.execute("emacsclient --socket-name " .. emacsSocket .. " -n -c -F '((name . \\\"org-protocol-capture\\\"))' 'org-protocol://capture?template=j'", true)
end)

hyper:bind({}, "t", nil, function()
      hs.execute("open -n /Users/markus/Applications/Home\\ Manager\\ Apps/kitty.app", true)
end)
