require "bundler/setup"

require "voke"
require "deploy"
require "deploy/git"

class AppConf
  include Voke
  include Deploy

  def push(options = Hash.new)
    hosts = options[:hosts] || default_hosts

    puts "\t-- Updating conf on #{ hosts } --"
    Git.update(:source_host => "app-conf.sv2.box.net", :source_dir => "/box/www/application",
               :target_host => hosts, :target_dir => "/box/etc/application",
               :branch => "master")
  end

  private
  def default_hosts
    [ "convert1000", "content1000", "upload1000" ]
  end
end

Conversion.new.voke(*ARGV)
