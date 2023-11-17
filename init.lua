-- Ordering is important, as it can break things (but no idea why)
require('modules.shortcuts')
require('modules.select-menu')
require('modules.spaces')

local emacsSocket = '/var/folders/tm/s0rmv44130v_l7p3jynpdkm00000gn/T/emacs501/default'
local hyper = require('modules.hyperkey').modal

local commander = hs.loadSpoon('Commander'):bindHotkeys({
      show = { {}, 'x', modal = hyper }
})

hs.loadSpoon('SafetyNet')

local hammerspoon = hs.loadSpoon('Hammerspoon'):bindHotkeys({
      reloadConfig = { { 'hyper' }, 'r', modal = hyper }
})
commander:registerSpoon(hammerspoon)

local locator = hs.loadSpoon('MouseLocator'):bindHotkeys({
      toggle = { { 'hyper' }, 'w', modal = hyper }
})
commander:registerSpoon(locator)

local windows = hs.loadSpoon('Windows'):bindHotkeys({
      forceClose = { { 'ctrl', 'cmd' }, 'w' },
      minimizeAll = { { 'hyper', 'cmd' }, 'm', modal = hyper },
      hideAll = { { 'hyper', 'cmd' }, 'h', modal = hyper }
})
commander:registerSpoon(windows)

local inputSources = hs.loadSpoon('InputSources')
commander:registerSpoon(inputSources)
inputSources:start()

local secondaryPasteboard = hs.loadSpoon('SecondaryPasteboard')
commander:registerSpoon(secondaryPasteboard)
secondaryPasteboard:start()

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
