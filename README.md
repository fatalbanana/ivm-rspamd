## Rspamd rules for Invaluement Service Provider DNSBL

#### What is Invaluement Service Provider DNSBL?

See [here](https://www.invaluement.com/serviceproviderdnsbl/) for more information.

#### Can't you just use multimap+regex/something else?

*Yes*, you can find example configuration on [this page](https://rspamd.com/doc/configuration/selectors.html).

#### What are the supported Rspamd versions?

The latest stable and development versions.

#### How to use this?

Copy `ivm-*.lua` files somewhere and execute those in your configuration, see `rspamd.local.lua` for an example.
