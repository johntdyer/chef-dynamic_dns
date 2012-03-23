%w[dns/hostname dns/zone dns/server dns/secret].each do |path|
  unless (path.split('/').inject(node) { |x,y| x[y] } rescue nil)
    raise ArgumentError, "metadata #{path} must be provided for this recipe to work; there is no default."
  end
end

package "dnsutils"

template "/etc/dns_info.yaml" do
  source "dns_info.yaml.erb"
  owner "root"
  group "root"
  mode 00600
end

cookbook_file "/root/dynamic_nsupdate.rb" do
  source "dynamic_nsupdate.rb"
  owner "root"
  group "root"
  mode 00700
end

cron "run nsupdate" do
  minute 0
  hour 0
  command "/root/dynamic_nsupdate.rb"
end
