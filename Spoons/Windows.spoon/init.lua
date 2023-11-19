--- === Windows ===
---
--- Provides windows related functions.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'Windows'
obj.version = 'latest'
obj.author = 'Markus Opitz <markus@bitsandbobs.net>'
obj.homepage = 'https://github.com/mrkuz/hammerspoon'
obj.license = 'MIT - https://opensource.org/license/mit/'

obj.logger = hs.logger.new('Windows')

-- Variables
obj._hotkeyMapping = nil
obj._store = {}

local utils = require('lib.utils')

function obj:bindHotkeys(mapping)
   self._hotkeyMapping = mapping
   utils.bind(mapping, 'forceClose', function() self:_forceCloseWindow() end)
   utils.bind(mapping, 'minimizeAll', function() self:_minimizeAllWindows() end)
   utils.bind(mapping, 'hideAll', function() self:_hideAllWindows() end)
   utils.bind(mapping, 'maximize', function() self:_maximizeWindow() end)
   utils.bind(mapping, 'restore', function() self:_restoreWindow() end)
   utils.bind(mapping, 'tileLeft', function() self:_tileWindowToLeft() end)
   utils.bind(mapping, 'tileRight', function() self:_tileWindowToRight() end)
   return self
end

function obj:hotkeyMapping()
   return self._hotkeyMapping;
end

function obj:actions()
   return {
      {
         name = 'minimizeAll',
         text = 'Minimize all windows',
         actionFn = function() self:_minimizeAllWindows() end
      },
      {
         name = 'hideAll',
         text = 'Hide all windows',
         actionFn = function() self:_hideAllWindows() end
      },
      {
         name = 'forceClose',
         text = 'Force close focused window',
         actionFn = function() self:_forceCloseWindow() end
      },
      {
         name = 'maximize',
         text = 'Maximize window',
         actionFn = function() self:_maximizeWindow() end
      },
      {
         name = 'restore',
         text = 'Restore window size and position',
         actionFn = function() self:_restoreWindow() end
      },
      {
         name = 'tileLeft',
         text = 'Tile window to left',
         actionFn = function() self:_tileWindowToLeft() end
      },
      {
         name = 'tileRight',
         text = 'Tile window to right',
         actionFn = function() self:_tileWindowToRight() end
      }
   }
end

function obj:_forceCloseWindow()
   local window = hs.window.focusedWindow()
   if window then
      window:close()
   end
end

function obj:_minimizeAllWindows()
   self:_forAllWindows(function (window) window:minimize() end)
end

function obj:_hideAllWindows()
   self:_forAllWindows(function (window) window:application():hide() end)
end

function obj:_forAllWindows(callback)
   local currentSpace = hs.spaces.focusedSpace()
   for _, v in ipairs(hs.spaces.windowsForSpace(currentSpace)) do
      local window = hs.window.get(v)
      if window and window:isStandard() and window:isVisible() then
         callback(window)
      end
   end
end

function obj:_maximizeWindow()
   local window = hs.window.focusedWindow()
   self._store[window:id()] = window:frame()
   hs.window.focusedWindow():maximize()
end

function obj:_restoreWindow()
   local window = hs.window.focusedWindow()
   local id = window:id()
   if id and self._store[id] then
      local frame = self._store[id]
      window:setFrame(frame)
   end
end

function obj:_tileWindowToLeft()
   local window = hs.window.focusedWindow()
   local screen = window:screen():frame()

   local frame = {
      x = 0,
      y = 0,
      w = screen.w / 2,
      h = screen.h,
   }
   self._store[window:id()] = window:frame()
   window:setFrame(frame)
end

function obj:_tileWindowToRight()
   local window = hs.window.focusedWindow()
   local screen = window:screen():frame()

   local frame = {
      x = screen.x + (screen.w / 2),
      y = screen.y,
      w = screen.w / 2,
      h = screen.h,
   }
   self._store[window:id()] = window:frame()
   window:setFrame(frame)
end

return obj
