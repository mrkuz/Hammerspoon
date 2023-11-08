local module = {}

function module.init(modal)
   print("== Module 'hammerspoon' loaded")
   modal:bind({}, "r", nil, _reloadConfig)
end

function _reloadConfig()
   hs.console.clearConsole()
   hs.openConsole()
   print("== Reloading config")
   hs.reload()
end

return module
