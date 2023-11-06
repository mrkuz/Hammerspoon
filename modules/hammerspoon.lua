local hammerspoon = {}
print("== Module 'hammerspoon' loaded")

function hammerspoon.init(mods)
   hs.hotkey.bind(mods, "r", reloadConfig)
end

function reloadConfig()
   hs.console.clearConsole()
   print("== Reloading config")
   hs.reload()
end

return hammerspoon
