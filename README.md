dynamic_dns: control DNS management without external services
--------------------------------------------------------------------------------

Basically this has one recipe at this point, which installs a script which gets
set in cron.

This script:

* Consults with a jsonip (or alike, server-side will be a part of this
  eventually) service to get the external IP of the host.
* Sends an nsupdate to a DNS server and updates an A record with that IP
  address.

This is a slightly modified version of the script blogged about
[here](http://erik.hollensbe.org/blog/2012/03/03/rsync-the-swiss-army-chainsaw-of-backup-utilities/).

Recipe Information
--------------------------------------------------------------------------------

The recipe is called `dynamic_dns::install_nsupdate` and it takes several attributes:

* `dns/hostname`: the hostname to update with any IP address change.
* `dns/server`: the DNS server's address.
* `dns/secret`: the secret key used by nsupdate to authenticate with the DNS server.
* `dns/zone`: the zone to update on the DNS server.
* `dns/jsonip_service`: the json IP service url (default: `http://jsonip.com`)

Unless specified there are **no defaults** for any of these keys and the recipe
will `raise ArgumentError` for any missing keys before trying to do anything.
Trust me, this is in your best interest. :)

Future plans are to implement recipe tooling for the nginx/unicorn/rack side of
this, but as of this writing this does not exist.

Constraints
--------------------------------------------------------------------------------

Currently this recipe only supports ubuntu and debian -- likely due to package
name differences. Happy to accept pull requests for other systems.

Contributing
--------------------------------------------------------------------------------

* Fork the project
* Make your edits
* Be sure to not change anything in metadata.rb without prior permission.
* Send a pull request.

Author
--------------------------------------------------------------------------------

Erik Hollensbe <erik+chef@hollensbe.org>
