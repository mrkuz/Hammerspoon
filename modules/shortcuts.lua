local module = {}

local hyper = require('modules.hyperkey').modal
local width = 900
local height = 800
local htmlContent = [[
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
  <div style="display: grid; grid-template-columns: 1fr 1fr; margin: 20px; gap: 30px;">
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
        <tr><td>⇧ ⌘ Q</td><td>Log out</td>
        <tr><td>⇧ ⌘ /</td><td>Open Help menu</td>
        </tr>
      </table>
    </div>
    <div>
      <h2>Spaces</h2>
      <table>
        <col class="col-1" />
        <tr><td>⌃ ←</td><td>Switch to the previous space</td></tr>
        <tr><td>⇧ ⌃ ←</td><td>Move window to the previous space</td></tr>
        <tr><td>⌃ →</td><td>Switch to the next space</td></tr>
        <tr><td>⇧ ⌃ →</td><td>Move window to the next space</td></tr>
        <tr><td>⌃ 1..9</td><td>Switch to space 1..9</td></tr>
        <tr><td>⇧ ⌃ 1..9</td><td>Move window to space 1..9</td></tr>
        </tr>
      </table>
    </div>
    <div>
      <h2>Windows</h2>
      <table>
        <col class="col-1" />
        <tr><td>⌘ Tab</td><td>Cycle through windows</td></tr>
        <tr><td>⌘ H</td><td>Hide windows of the current app</td></tr>
        <tr><td>⌥ ⌘ H</td><td>Hide windows of other apps</td></tr>
        <tr><td>⌘ M</td><td>Minimize window</td></tr>
        <tr><td>⌘ W</td><td>Close window</td></tr>
        <tr><td>⌃ ⌘ W</td><td>Force close window</td></tr>
        <tr><td>⌥ ⌘ W</td><td>Close windows of the current app</td></tr>
        <tr><td>⌃ ⌥ ↑</td><td>Maximize window</td></tr>
        <tr><td>⌃ ⌥ ←</td><td>Tile window to the left</td></tr>
        <tr><td>⌃ ⌥ →</td><td>Tile window to the right</td></tr>
        <tr><td>⌃ ⌥ ↓</td><td>Restore size and position</td></tr>
        </tr>
      </table>
    </div>
    <div>
      <h2>Miscellaneous</h2>
      <table>
        <col class="col-1" />
        <tr><td>✦ E</td><td>Launch Emacs</td></tr>
        <tr><td>✦ H</td><td>Open home directory</td></tr>
        <tr><td>✦ J</td><td>Capture journal entry</td></tr>
        <tr><td>✦ M</td><td>Select menu item</td></tr>
        <tr><td>✦ R</td><td>Reload Hammerspoon config</td></tr>
        <tr><td>✦ T</td><td>Launch Terminal</td></tr>
        <tr><td>✦ /</td><td>Display shortcuts</td></tr>
        <tr><td>⇧ ⇧</td><td>Select next input source</td>
        <tr><td>✦ Left Mouse</td><td>Copy selected text</td></tr>
        <tr><td>✦ Middle Mouse</td><td>Paste copied text</td></tr>
      </table>
    </div>
  </div>
</body>
</html>
]]

function _init(modal)
   print("== Module 'shortcuts' loaded")

   local webview = hs.webview.new({})
   webview:windowTitle("Shortcuts")
   webview:windowStyle({"titled", "closable"})
   webview:shadow(true)
   webview:alpha(0.9)
   webview:allowNewWindows(false)
   webview:bringToFront(true)
   webview:html(htmlContent)

   hyper:bind({}, "/", nil, function() _toggle(webview) end)
end

function _toggle(webview)
   if webview:isVisible() then
      webview:hide()
   else
      local screen = hs.screen.mainScreen()
      local frame = screen:fullFrame()
      webview:frame({
            x = frame.w / 2 - width / 2,
            y = frame.h / 2 - height / 2,
            w = width,
            h = height,
      })

      webview:show()
   end
end

_init()
return module
