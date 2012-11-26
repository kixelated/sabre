require "bundler/setup"

require "voke"
require "deploy"
require "deploy/git"

class AppConf
  include Voke
  include Deploy

  def deploy(options = Hash.new)
    update(options)
  end

  def update(options = Hash.new)
    hosts = options[:hosts] || default_hosts
    mirrors = options[:mirrors] || default_mirrors

    puts "\t-- Mirroring code on #{ mirrors } --"
    Git.update(:source_host => "scm.dev.box.net", :source_dir => "/box/www/current",
               :target_host => mirrors, :target_dir => "/box/www/current",
               :branch => "master")

    puts "\t-- Updating code on #{ hosts } --"
    Git.update(:source_host => mirrors, :source_dir => "/box/www/current",
               :target_host => hosts, :target_dir => "/box/www/current",
               :branch => "master")
  end

  private
  def default_mirrors
    [ "mirror1.ve.box.net", "mirror2.sv2.box.net" ]
  end

  def default_hosts
    [ "convert1000.ve.box.net", "content1000.ve.box.net", "upload1000.ve.box.net" ]
  end
end

Conversion.new.voke(*ARGV)
