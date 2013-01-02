require "bundler/setup"

require "deploy"
require "deploy/git"

class Conversion < Deploy::Session
  include Deploy::Git

  def initialize
    server "convert-lcurley-sl6.dev.box.net"
    server "convert-sl6.dev.box.net"
  end

  def deploy
    git_update(:repository => "ssh://scm.dev.box.net/box/www/conversion",
                :directory => "/box/lib/conversion_new", :branch => "publish")


    run("bundle install --deployment --quiet --without test deploy",
        :directory => "/box/lib/conversion_new")
  end
end

Conversion.new.deploy
