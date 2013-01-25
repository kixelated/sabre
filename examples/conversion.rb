require "bundler/setup"

require "deploy"
require "deploy/git"
require "deploy/release"

conversion = Deploy::Command.new do
  release.make("/box/lib/conversion_test") do
    git.update(:repository => "ssh://scm.dev.box.net/box/www/conversion",
               :directory => "$RELEASE",
               :branch => "publish")
  end
end

puts conversion
