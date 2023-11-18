
-- Ordering is important, as it can break things (but no idea why)
require('modules.shortcuts')
require('modules.select-menu')

local emacsSocket = '/var/folders/tm/s0rmv44130v_l7p3jynpdkm00000gn/T/emacs501/default'
local hyper = require('modules.hyperkey').modal

local commander = hs.loadSpoon('Commander'):bindHotkeys({
      show = { {}, 'x', modal = hyper }
})

hs.loadSpoon('SafetyNet'):start()

local hammerspoon = hs.loadSpoon('Hammerspoon'):bindHotkeys({
      reloadConfig = { { 'hyper' }, 'r', modal = hyper }
})
local locator = hs.loadSpoon('MouseLocator'):bindHotkeys({
      toggle = { { 'hyper' }, 'w', modal = hyper }
})
local windows = hs.loadSpoon('Windows'):bindHotkeys({
      forceClose = { { 'ctrl', 'cmd' }, 'w' },
      minimizeAll = { { 'hyper', 'cmd' }, 'm', modal = hyper },
      hideAll = { { 'hyper', 'cmd' }, 'h', modal = hyper }
                                                   })
local spaces = hs.loadSpoon('Spaces'):start()

local inputSources = hs.loadSpoon('InputSources')
inputSources:start()

local secondaryPasteboard = hs.loadSpoon('SecondaryPasteboard')
secondaryPasteboard:start()

commander:registerAction({ name = "windows", text = "Windows" })
commander:registerAction({ name = "spaces", text = "Spaces" })
commander:registerAction({ name = "pasteboard", text = "Pasteboard" })

commander:registerSpoon(inputSources)
commander:registerSpoon(locator)
commander:registerSpoon(windows, "windows")
commander:registerSpoon(spaces, "spaces")
commander:registerSpoon(secondaryPasteboard, "pasteboard")
commander:registerSpoon(hammerspoon)

hyper:bind({}, 'e', nil, function()
      hs.execute('emacsclient --socket-name ' .. emacsSocket .. ' -n -c', true)
end)

hyper:bind({}, 'h', nil, function()
      hs.execute('open $HOME', true)
end)

hyper:bind({}, 'j', nil, function()
      hs.execute("emacsclient --socket-name " .. emacsSocket .. " -n -c -F '((name . \\\"org-protocol-capture\\\"))' 'org-protocol://capture?template=j'", true)
end)

hyper:bind({}, 't', nil, function()
      hs.execute('open -n /Users/markus/Applications/Home\\ Manager\\ Apps/kitty.app', true)
end)
