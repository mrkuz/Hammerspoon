local module = {}

local hyper = require('modules.hyperkey').modal

function _init()
   print("== Module 'hammerspoon' loaded")
   hyper:bind({}, "r", nil, _reloadConfig)
end

function _reloadConfig()
   hs.console.clearConsole()
   hs.openConsole()
   print("== Reloading config")
   hs.reload()
end

_init()
return module
