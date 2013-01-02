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
  end

  def deploy
    git.update(:repository => "ssh://scm.dev.box.net/box/www/conversion",
               :directory => "/box/lib/conversion_new", :branch => "publish")

    on :convert do
      shell.run("cd /box/lib/conversion_new &&
                 bundle install --deployment --quiet --without test deploy &&
                 echo \"Bundle installed\"")
    end
  end
end

conversion = Conversion.new
conversion.deploy
conversion.close
