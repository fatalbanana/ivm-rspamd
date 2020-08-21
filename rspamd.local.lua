local rspamd_util = require 'rspamd_util'

local ivm_files = {
  '/etc/rspamd/ivm-sg-domains.lua',
  '/etc/rspamd/ivm-sg-id.lua',
}

for _, f in ipairs(ivm_files) do
  if rspamd_util.file_exists(f) then
    dofile(f)
  end
end
