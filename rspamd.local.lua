local rspamd_util = require 'rspamd_util'

local ivm_file =  '/etc/rspamd/ivm-sg.lua'

if rspamd_util.file_exists(f) then
  dofile(f)
end
