local rspamd_regexp = require 'rspamd_regexp'

local ivm_sendgrid_ids = rspamd_config:add_map({
  description = 'Invaluement Service Provider DNSBL: Sendgrid IDs',
  type = 'set',
  url = 'https://www.invaluement.com/spdata/sendgrid-id-dnsbl.txt',
})

rspamd_config.IVM_SENDGRID_ID = {
  callback = function(task)
    local env_from = task:get_from('smtp')
    if not env_from then return end
    if env_from[1].domain ~= 'sendgrid.net' then return end
    local lp_re = rspamd_regexp.create_cached([[^bounces\+(\d+)-]])
    local res = lp_re:search(env_from[1].user, true, true)
    if not res then return end
    if ivm_sendgrid_ids:get_key(res[1][2]) then return true end
  end,
  score = 6.0,
  description = 'Sendgrid ID listed on Invaluement blacklist',
}
