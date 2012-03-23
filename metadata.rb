maintainer        "Erik Hollensbe"
maintainer_email  "erik+chef@hollensbe.org"
license           "Apache 2.0"
description       "Provides methods to handle dynamic DNS updates"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"

recipe "dynamic_dns::install_nsupdate", 
  "Installs dnsutils + a script to pull the IP from jsonip.com and send updates to a DNS server."

%w{ debian ubuntu }.each do |os|
  supports os
end
