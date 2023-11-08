local modal = require('modules.hyperkey').init().modal

require('modules.hammerspoon').init(modal)
require('modules.shortcuts').init(modal)
require('modules.mouse-pasteboard').init()
require('modules.toggle-input-sources').init()

local emacsSocket = "/var/folders/tm/s0rmv44130v_l7p3jynpdkm00000gn/T/emacs501/default"

modal:bind({}, "e", nil, function()
      hs.execute("emacsclient --socket-name " .. emacsSocket .. " -n -c", true)
end)

modal:bind({}, "j", nil, function()
      hs.execute("emacsclient --socket-name " .. emacsSocket .. " -n -c -F '((name . \\\"org-protocol-capture\\\"))' 'org-protocol://capture?template=j'", true)
end)

modal:bind({}, "t", nil, function()
      hs.execute("open -n /Users/markus/Applications/Home\\ Manager\\ Apps/kitty.app", true)
end)
