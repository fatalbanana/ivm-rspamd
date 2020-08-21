local lua_maps = require 'lua_maps'

local ivm_sendgrid_envfromdomains = lua_maps.map_add_from_ucl(
  'https://www.invaluement.com/spdata/sendgrid-envelopefromdomain-dnsbl.txt',
  'set',
  'Invaluement Service Provider DNSBL: Sendgrid envelope domains'
)

rspamd_config.IVM_SENDGRID_DOMAIN = {
  callback = function(task)
    local sg_hdr = task:get_header('X-SG-EID')
    if not sg_hdr then return end
    local env_from = task:get_from('smtp')
    if not env_from then return end
    if ivm_sendgrid_envfromdomains:get_key(env_from[1].domain) then return true end
  end,
  score = 6.0,
  description = 'Sendgrid envelope domain listed on Invaluement blacklist',
}
