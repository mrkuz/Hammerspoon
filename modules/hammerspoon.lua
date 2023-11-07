local hammerspoon = {}
print("== Module 'hammerspoon' loaded")

function hammerspoon.init(modal)
   modal:bind({}, "r", nil, reloadConfig)
end

function reloadConfig()
   hs.console.clearConsole()
   hs.openConsole()
   print("== Reloading config")
   hs.reload()
end

return hammerspoon
