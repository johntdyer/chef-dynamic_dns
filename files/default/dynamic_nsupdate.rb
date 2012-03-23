#!/usr/bin/env ruby

require 'yaml'
require 'resolv'
require 'json'
require 'open-uri'

DNS_INFO = YAML.load_file(ENV["TEST"] ? "dns_info.yaml" : "/etc/dns_info.yaml")

unless jsonip_service = DNS_INFO['jsonip_service'] 
  raise ArgumentError, "jsonip_service not provided in /etc/dns_info.yaml!"
end

unless hostname = DNS_INFO["hostname"]
  raise ArgumentError, "hostname not provided in /etc/dns_info.yaml!"
end

ip = JSON.load(open(jsonip_service).read)["ip"] rescue nil
resolved_ip = Resolv.getaddress(hostname) rescue nil

unless ip
  raise "Could not determine IP from remote service"
end

if resolved_ip.nil? or ip != resolved_ip
  puts "Updating #{hostname} to be ip '#{ip}' (previously '#{resolved_ip}')"

  IO.popen("nsupdate -y #{DNS_INFO["key"]}:#{DNS_INFO["secret"]} -v", 'r+') do |f|
    f << <<-EOF
      server #{DNS_INFO["server"]}
      zone #{DNS_INFO["key"]}
      update delete #{hostname} A
      update add #{hostname} 60 A #{ip}
      show
      send
    EOF

    f.close_write
    puts f.read
  end
end
