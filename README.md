## Rspamd rules for Invaluement Service Provider DNSBL

#### What is Invaluement Service Provider DNSBL?

See [here](https://www.invaluement.com/serviceproviderdnsbl/) for more information.

#### What are the supported Rspamd versions?

The latest stable and development versions.

#### How to use this?

Copy `ivm-*.lua` files somewhere and execute those in your configuration, see `rspamd.local.lua` for an example. Each file activates a different list.

`ivm-sg-id.lua`: Matches ID in bounce+&lt;ID&gt;-blah@sendgrid.net
`ivm-sg-domains.lua`: Matches envelope sender for Sendgrid senders

#### Can't you just use multimap+regex/something else?

Yes, I suppose you can. Let's think about that later. PRs welcome.
