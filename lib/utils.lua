local utils = {}

function utils.bindSpec(spec)
   if spec.modal then
      spec.modal:bind(spec[1], spec[2], spec.pressFn, spec.releaseFn)
   else
      hs.hotkey.bind(spec[1], spec[2], spec.pressFn, spec.releaseFn)
   end
   return self
end

return utils
