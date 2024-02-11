-- -------------------------------------------------------------------------------
-- Map caps lock to F20 ==
-- see: https://developer.apple.com/library/archive/technotes/tn2450/_index.html#//apple_ref/doc/uid/DTS40017618-CH1-KEY_TABLE_USAGES)
-- -------------------------------------------------------------------------------

local codeCapsLock = '0x700000039'
local codeF20 = '0x70000006F'
hs.execute("hidutil property --set '{\"UserKeyMapping\":[{"
           .. "\"HIDKeyboardModifierMappingSrc\": " .. codeCapsLock .. ", "
           .. "\"HIDKeyboardModifierMappingDst\": " .. codeF20
           ..  "}]}'")

local hyper = hs.hotkey.modal.new()
hs.hotkey.bind({}, 'F20', function() hyper:enter() end, function() hyper:exit() end)

-- -------------------------------------------------------------------------------
-- Load Spoons
-- -------------------------------------------------------------------------------

hs.loadSpoon('SafetyNet'):start()

local commander = hs.loadSpoon('Commander')
local hammerspoon = hs.loadSpoon('Hammerspoon')
local locator = hs.loadSpoon('MouseLocator')
local windows = hs.loadSpoon('Windows')
local spaces = hs.loadSpoon('Spaces'):start()
local inputSources = hs.loadSpoon('InputSources'):start()
local secondaryPasteboard = hs.loadSpoon('SecondaryPasteboard'):start()
local mouseZoom = hs.loadSpoon('MouseZoom'):start()
local menuActions = hs.loadSpoon('MenuActions')
local shellActions = hs.loadSpoon("ShellActions")
local keyboardActions = hs.loadSpoon("KeyboardActions")
local appleScriptActions = hs.loadSpoon("AppleScriptActions")
local caffeine = hs.loadSpoon("Caffeine")

-- -------------------------------------------------------------------------------
-- Configure Commander
-- -------------------------------------------------------------------------------

commander:registerAction({ name = 'macos', text = 'macOS' })
commander:registerAction({ name = 'windows', text = 'Windows' })
commander:registerAction({ name = 'spaces', text = 'Spaces' })
commander:registerAction({ name = 'files', text = 'Files' })
commander:registerAction({ name = 'pasteboard', text = 'Pasteboard' })
commander:registerAction({ name = 'screenshots', text = 'Screenshots' })
commander:registerAction({ name = 'menu', text = 'Menu' })
commander:registerAction({ name = 'emacs', text = 'Emacs' })

commander:registerSpoon(shellActions)
commander:registerSpoon(appleScriptActions)
commander:registerSpoon(inputSources)
commander:registerSpoon(caffeine)
commander:registerSpoon(locator)
commander:registerSpoon(windows, 'windows')
commander:registerSpoon(spaces, 'spaces')
commander:registerSpoon(secondaryPasteboard, 'pasteboard')
commander:registerSpoon(menuActions, 'menu')
commander:registerSpoon(keyboardActions)
commander:registerSpoon(hammerspoon)

-- -------------------------------------------------------------------------------
-- Set up hotkeys
-- -------------------------------------------------------------------------------

commander:bindHotkeys({
      show = { {}, 'space', modal = hyper }
})
locator:bindHotkeys({
      toggle = { { 'hyper' }, 'w', modal = hyper }
})
windows:bindHotkeys({
      tileLeft = { { 'ctrl', 'alt' }, 'left' , alt = { { 'ctrl', 'alt' }, 'pad4' } },
      tileRight = { { 'ctrl', 'alt' }, 'right', alt = { { 'ctrl', 'alt' }, 'pad6' } },
      tileTop = { { 'ctrl', 'alt' }, 'pad8' },
      tileBottom = { { 'ctrl', 'alt' }, 'pad2' },
      tileTopLeft = { { 'ctrl', 'alt' }, 'pad7' },
      tileBottomLeft = { { 'ctrl', 'alt' }, 'pad1' },
      tileTopRight = { { 'ctrl', 'alt' }, 'pad9' },
      tileBottomRight = { { 'ctrl', 'alt' }, 'pad3' },
      maximize = { { 'ctrl', 'alt' }, 'up' },
      restore = { { 'ctrl', 'alt' }, 'down' },
      forceClose = { { 'ctrl', 'cmd' }, 'w' },
      minimizeAll = { { 'hyper', 'cmd' }, 'm', modal = hyper },
      hideAll = { { 'hyper', 'cmd' }, 'h', modal = hyper }
})
hammerspoon:bindHotkeys({
      reloadConfig = { { 'hyper' }, 'r', modal = hyper }
})

-- -------------------------------------------------------------------------------
-- Function keys
-- -------------------------------------------------------------------------------

hyper:bind({}, '1', function() hs.eventtap.keyStroke({}, 'F1') end)
hyper:bind({}, '2', function() hs.eventtap.keyStroke({}, 'F2') end)
hyper:bind({}, '3', function() hs.eventtap.keyStroke({}, 'F3') end)
hyper:bind({}, '4', function() hs.eventtap.keyStroke({}, 'F4') end)
hyper:bind({}, '5', function() hs.eventtap.keyStroke({}, 'F5') end)
hyper:bind({}, '6', function() hs.eventtap.keyStroke({}, 'F6') end)
hyper:bind({}, '7', function() hs.eventtap.keyStroke({}, 'F7') end)
hyper:bind({}, '8', function() hs.eventtap.keyStroke({}, 'F8') end)
hyper:bind({}, '9', function() hs.eventtap.keyStroke({}, 'F9') end)
hyper:bind({}, '0', function() hs.eventtap.keyStroke({}, 'F10') end)
hyper:bind({}, '-', function() hs.eventtap.keyStroke({}, 'F11') end)
hyper:bind({}, '=', function() hs.eventtap.keyStroke({}, 'F12') end)

-- -------------------------------------------------------------------------------
-- Configure some custom actions
-- -------------------------------------------------------------------------------

local emacsSocket = '/var/folders/tm/s0rmv44130v_l7p3jynpdkm00000gn/T/emacs501/default'

shellActions:registerAction({
      { 'hyper' }, 'e', modal = hyper,
      text = 'New Emacs client', parent = 'emacs',
      command = 'emacsclient --socket-name ' .. emacsSocket .. ' -n -c'
})
shellActions:registerAction({
      { 'hyper' }, 'j', modal = hyper,
      text = 'Capture journal entry', parent = 'emacs',
      command = "emacsclient --socket-name " .. emacsSocket .. " -n -c -F '((name . \\\"org-protocol-capture\\\"))' 'org-protocol://capture?template=j'"
})
shellActions:registerAction({
      { 'hyper' }, 'h', modal = hyper,
      text = 'Open home directory', parent = 'files',
      command = 'open $HOME'
})
shellActions:registerAction({
      { 'hyper' }, 't', modal = hyper,
      text = 'New terminal',
      command = 'open -n /Users/markus/Applications/Home\\ Manager\\ Apps/kitty.app'
})

appleScriptActions:registerAction({
      text = 'Shut down', parent = 'macos',
      script = 'tell application "System Events" to shut down'
})

appleScriptActions:registerAction({
      text = 'Restart', parent = 'macos',
      script = 'tell application "System Events" to restart'
})

-- -------------------------------------------------------------------------------
-- Add actions for existing keyboard shortcuts
-- -------------------------------------------------------------------------------

keyboardActions:registerAction({ {}, 'F16', system = true, text = 'Toggle "Do not Disturb"',})

keyboardActions:registerAction({ { 'cmd' }, 'space', text = 'Spotlight', parent = 'macos' })
keyboardActions:registerAction({ {}, 'F3', system = true, text = 'Mission Control', parent = 'macos' })
keyboardActions:registerAction({ {}, 'F4', system = true, text = 'Launchpad', parent = 'macos' })
keyboardActions:registerAction({ {}, 'F5', system = true, text = 'Notification Center', parent = 'macos' })
keyboardActions:registerAction({ { 'ctrl' }, 'down', system = true, text = 'App Exposé', parent = 'macos' })
keyboardActions:registerAction({ { 'ctrl', 'cmd' }, 'q', text = 'Lock screen', parent = 'macos' })
keyboardActions:registerAction({ { 'shift', 'cmd' }, 'q', text = 'Log out', parent = 'macos' })

keyboardActions:registerAction({ { 'cmd' }, 'h', text = 'Hide windows of current app', parent = 'windows' })
keyboardActions:registerAction({ { 'alt', 'cmd' }, 'h', text = 'Hide windows of other apps', parent = 'windows' })
keyboardActions:registerAction({ { 'cmd' }, 'm', text = 'Minimize window', parent = 'windows' })
keyboardActions:registerAction({ { 'cmd' }, 'w', text = 'Close window', parent = 'windows' })
keyboardActions:registerAction({ { 'alt', 'cmd' }, 'w', text = 'Close windows of current app', parent = 'windows' })

keyboardActions:registerAction({ { 'shift', 'cmd' }, '3', text = 'Screenshot', parent = 'screenshots' })
keyboardActions:registerAction({ { 'shift', 'cmd' }, '4', text = 'Screenshot of area', parent = 'screenshots' })

appleScriptActions:registerAction(
   {
      text = 'Hey Siri!', extraText = '⌘ SPC (hold)', parent = 'macos',
      script = [[
           tell application "System Events"
             key down {command}
             key down 49
             delay 0.5
             key up 49
             key up {command}
           end tell
         ]]
   }
)

commander:registerAction(
   {
      text = 'Screenshot of window', extraText = '⇧ ⌘ 4 SPC', parent = 'screenshots',
      actionFn = function()
         hs.eventtap.keyStroke({ 'shift', 'cmd' }, '4')
         hs.eventtap.keyStroke({}, 'space')
      end
   }
)
