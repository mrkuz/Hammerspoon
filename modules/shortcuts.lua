local module = {}

local width = 800
local height = 400
local htmlContent = [[
<!DOCTYPE html>
<html>

<!--
⇧ Shift
⌃ Control
⌘ Command
⌥ Option
✦ Hyper
-->

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
      width: 100px;
    }
  </style>
</head>
<body>
  <div style="display: grid; grid-template-columns: 1fr 1fr; margin: 10px; gap: 10px;">
    <div>
      <h2>MacOS</h2>
      <table>
        <col class="col-1" />
        <tr><td>⌃ ⌘ Q</td><td>Lock screen</td></tr>
        <tr><td>⇧ ⌘ Q</td><td>Log out</td>
        </tr>
      </table>
    </div>
    <div>
      <h2>Miscellaneous</h2>
      <table>
        <col class="col-1" />
        <tr><td>✦ E</td><td>Launch Emacs</td></tr>
        <tr><td>✦ J</td><td>Capture journal entry</td></tr>
        <tr><td>✦ R</td><td>Reload Hammerspoon config</td></tr>
        <tr><td>✦ T</td><td>Launch Terminal</td></tr>
      </table>
    </div>
  </div>
</body>
</html>
]]

function module.init(modal)
   print("== Module 'shortcuts' loaded")

   local webview = hs.webview.new({})
   webview:windowTitle("Shortcuts")
   webview:windowStyle("titled")
   webview:shadow(true)
   webview:alpha(0.9)
   webview:allowNewWindows(false)
   webview:bringToFront(true)
   webview:html(htmlContent)

   modal:bind({}, "h", nil, function() _toggle(webview) end)
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

return module
