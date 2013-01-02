require "bundler/setup"

require "deploy"
require "deploy/git"

class Conversion < Deploy::Base
  def initialize(session = nil)
    super

    group :convert do
      server "convert-lcurley-sl6.dev.box.net"
      server "convert-sl6.dev.box.net"
    end

    group :mirror do
      server "publish.sv2.box.net"
    end
  end

  def deploy
    git.update(:repository => "ssh://scm.dev.box.net/box/www/conversion",
               :directory => "/box/lib/conversion_new", :branch => "publish")

    on :convert do
      shell.run("bundle install --deployment --quiet --without test deploy",
                :directory => "/box/lib/conversion_new")
    end
  end
end

Conversion.new.deploy
