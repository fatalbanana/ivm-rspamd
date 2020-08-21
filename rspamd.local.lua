local rspamd_util = require 'rspamd_util'

-- For now we can't work if this rule is enabled :`(
rspamd_config:add_condition('EMAIL_PLUS_ALIASES', function() return false end)

local ivm_files = {
  '/etc/rspamd/ivm-sg-id.lua',
}

for _, f in ipairs(ivm_files) do
  if rspamd_util.file_exists(f) then
    dofile(f)
  end
end
