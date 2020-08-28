local lua_maps = require 'lua_maps'
local rspamd_regexp = require 'rspamd_regexp'

local ivm_sendgrid_ids = lua_maps.map_add_from_ucl(
  'https://www.invaluement.com/spdata/sendgrid-id-dnsbl.txt',
  'set',
  'Invaluement Service Provider DNSBL: Sendgrid IDs'
)

local ivm_sendgrid_envfromdomains = lua_maps.map_add_from_ucl(
  'https://www.invaluement.com/spdata/sendgrid-envelopefromdomain-dnsbl.txt',
  'set',
  'Invaluement Service Provider DNSBL: Sendgrid envelope domains'
)

local cb_id = rspamd_config:register_symbol({
  name = 'IVM_SENDGRID',
  callback = function(task)
    local sg_hdr = task:get_header('X-SG-EID')
    if not sg_hdr then return end
    local env_from = task:get_from('smtp')
    if not env_from then return end
    if ivm_sendgrid_envfromdomains:get_key(env_from[1].domain) then
      task:insert_result('IVM_SENDGRID_DOMAIN', 1.0)
    end
    -- Workaround for missing original SMTP from, FIXME some time
    local tagged = task:get_symbol('TAGGED_FROM')
    if not tagged then return end
    local lp_re = rspamd_regexp.create_cached([[^(\d+)-]])
    local res = lp_re:search(tagged[1].options[1], true, true)
    if not res then return end
    if ivm_sendgrid_ids:get_key(res[1][2]) then
      task:insert_result('IVM_SENDGRID_ID', 1.0)
    end
  end,
  description = 'Invaluement Service Provider DNSBL: Sendgrid',
  type = 'callback',
})

rspamd_config:register_symbol({
  name = 'IVM_SENDGRID_DOMAIN',
  parent = cb_id,
  group = 'ivmspdnsbl',
  score = 6.0,
  type = 'virtual',
})

rspamd_config:register_symbol({
  name = 'IVM_SENDGRID_ID',
  parent = cb_id,
  group = 'ivmspdnsbl',
  score = 6.0,
  type = 'virtual',
})

rspamd_config:register_dependency('IVM_SENDGRID', 'TAGGED_FROM')
