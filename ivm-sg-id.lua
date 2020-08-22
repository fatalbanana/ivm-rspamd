local lua_maps = require 'lua_maps'
local rspamd_regexp = require 'rspamd_regexp'

local ivm_sendgrid_ids = lua_maps.map_add_from_ucl(
  'https://www.invaluement.com/spdata/sendgrid-id-dnsbl.txt',
  'set',
  'Invaluement Service Provider DNSBL: Sendgrid IDs'
)

rspamd_config.IVM_SENDGRID_ID = {
  callback = function(task)
    -- Workaround for missing original SMTP from, FIXME some time
    local tagged = task:get_symbol('TAGGED_FROM')
    if not tagged then return end
    local env_from = task:get_from('smtp')
    if not env_from then return end
    if env_from[1].domain ~= 'sendgrid.net' then return end
    if env_from[1].user ~= 'bounces' then return end
    local lp_re = rspamd_regexp.create_cached([[^(\d+)-]])
    local res = lp_re:search(tagged[1].options[1], true, true)
    if not res then return end
    if ivm_sendgrid_ids:get_key(res[1][2]) then return true end
  end,
  score = 6.0,
  description = 'Sendgrid ID listed on Invaluement blacklist',
}

rspamd_config:register_dependency('IVM_SENDGRID_ID', 'TAGGED_FROM')
