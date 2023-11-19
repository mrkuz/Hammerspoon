--- === CheatSheet ===
---
--- Show a cheat sheet for common keyboard shortcuts.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'CheatSheet'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('CheatSheet')

obj.width = 1400
obj.height = 920
obj.content = [[
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: -apple-system, sans-serif;
    }
    h2 {
      text-align: center;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    table tr:nth-child(odd) td {
      background-color: #f4f4f4;
    }
    td {
      border: 1px solid black;
      padding: 4px
    }
    .col-1 {
      width: 140px;
    }
  </style>
</head>
<body>
  <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; margin: 20px; gap: 30px;">
    <div>
      <h2>MacOS</h2>
      <table>
        <col class="col-1" />
        <tr><td>⌘ Space</td><td>Spotlight</td>
        <tr><td>⌘ Space (hold)</td><td>Siri</td>
        <tr><td>⌃ ↑</td><td>Mission Control</td></tr>
        <tr><td>⌃ ↓</td><td>App Exposé</td></tr>
        <tr><td>F4</td><td>Launchpad</td>
        <tr><td>F5</td><td>Notification Center</td>
        <tr><td>⌃ ⌘ Q</td><td>Lock screen</td></tr>
        <tr><td>⇧ ⌘ Q</td><td>Log out</td></tr>
      </table>
    </div>
    <div>
      <h2>Window management</h2>
      <table>
        <col class="col-1" />
        <tr><td>⌘ Tab</td><td>Cycle through windows</td></tr>
        <tr><td>⌘ H</td><td>Hide windows of the current app</td></tr>
        <tr><td>⌥ ⌘ H</td><td>Hide windows of other apps</td></tr>
        <tr><td>⌘ M</td><td>Minimize window</td></tr>
        <tr><td>⌘ W</td><td>Close window</td></tr>
        <tr><td>⌥ ⌘ W</td><td>Close windows of the current app</td></tr>
      </table>
    </div>
    <div>
      <h2>Window positioning</h2>
      <table>
        <col class="col-1" />
        <tr><td>⌃ ⌥ ↑</td><td>Maximize window</td></tr>
        <tr><td>⌃ ⌥ ←</td><td>Tile window to the left</td></tr>
        <tr><td>⌃ ⌥ →</td><td>Tile window to the right</td></tr>
        <tr><td>⌃ ⌥ ↓</td><td>Restore size and position</td></tr>
      </table>
    </div>
    <div>
      <h2>Screenshots</h2>
      <table>
        <col class="col-1" />
        <tr><td>⇧ ⌘ 3</td><td>Screenshot</td></tr>
        <tr><td>⇧ ⌘ 4</td><td>Screenshot of area</td></tr>
        <tr><td>⇧ ⌘ 4 Space</td><td>Screenshot of window</td></tr>
      </table>
    </div>
    <div>
      <h2>Miscellaneous</h2>
      <table>
        <col class="col-1" />
        <tr><td>✦ E</td><td>Launch Emacs</td></tr>
        <tr><td>✦ H</td><td>Open home directory</td></tr>
        <tr><td>✦ J</td><td>Capture journal entry</td></tr>
        <tr><td>✦ T</td><td>Launch Terminal</td></tr>
        <tr><td>✦ /</td><td>Display shortcuts</td></tr>
      </table>
    </div>
  </div>
</body>
</html>
]]

obj._hotkeyMapping = nil
obj._webview = nil

local utils = require('lib.utils')

function obj:init()
   self._webview = hs.webview.new({})
   self._webview:windowTitle('Shortcuts')
   self._webview:windowStyle({'titled', 'closable'})
   self._webview:shadow(true)
   self._webview:alpha(0.9)
   self._webview:allowNewWindows(false)
   self._webview:bringToFront(true)
   self._webview:html(obj.content)
end

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping
   utils.bind(mapping, 'toggle', function() self:_toggle() end)
   return self
end

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return {
      {
         name = 'show',
         text = 'Show cheat sheet',
         actionFn = function() self:_show() end
      }
   }
end

function obj:_toggle()
   if self._webview:isVisible() then
      self._webview:hide()
   else
      self:_show()
   end
end

function obj:_show()
   local screen = hs.screen.mainScreen()
   local frame = screen:fullFrame()
   self._webview:frame({
         x = frame.w / 2 - obj.width / 2,
         y = frame.h / 2 - obj.height / 2,
         w = obj.width,
         h = obj.height,
   })

   self._webview:show()
end

return obj
