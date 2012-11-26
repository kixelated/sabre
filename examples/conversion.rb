require "bundler/setup"

require "voke"

# core deploy libraries
require "deploy"
require "deploy/git"
require "deploy/ssh"

# optional helpers
require "deploy/default"
require "deploy/server"

class Conversion
  include Voke

  include Deploy
  include Deploy::Default
  include Deploy::Server

  # dev
  server "convert-sl6.dev.box.net", :dev
  #server "staging-convert-sl6.dev.box.net", :dev
  server "convert-lcurley-sl6.dev.box.net", :dev

  # live
  server "convert1000.ve.box.net", :live
  server "publish.sv2.box.net", :live, :mirror

  # default options
  default :role, :dev

  default :hosts do |options|
    servers(options[:role].to_sym)
  end

  default :mirrors do |options|
    servers(options[:role].to_sym, :mirror)
  end

  def deploy(options = Hash.new)
    update(options)
    bundler(options)
    restart(options)
  end

  def update(options = Hash.new)
    options = defaults(options)
    hosts, mirrors = options[:hosts], options[:mirrors]

    unless mirrors.empty?
      Git.update(:source_host => "scm.dev.box.net", :source_dir => "/box/www/conversion",
                 :target_host => mirrors, :target_dir => "/box/www/conversion",
                 :branch => "publish")
    else
      mirrors = "scm.dev.box.net"
    end

    Git.update(:source_host => mirrors, :source_dir => "/box/www/conversion",
               :target_host => hosts, :target_dir => "/box/lib/conversion_new",
               :branch => "publish")
  end

  def bundler(options = Hash.new)
    options = defaults(options)
    hosts = options[:hosts]

    SSH.run(hosts, "cd /box/lib/conversion_new && " +
                   "bundle install --deployment --quiet --without test deploy")
  end

  def restart(options = Hash.new)
    options = defaults(options)
    hosts = options[:hosts]

    #SSH.run(hosts, "monit_manager restart")
  end
end

Conversion.new.voke(*ARGV)
