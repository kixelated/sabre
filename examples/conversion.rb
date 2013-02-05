require "bundler/setup"
require "deploy"

conversion = Deploy::Command.new do
  git.update(repository: "ssh://scm.dev.box.net/box/www/conversion",
             directory: "/box/lib/conversion/shared",
             branch: "publish")

  release.create("/box/lib/conversion") do
    cp("/box/lib/conversion/shared", "$RELEASE")
  end
end

puts conversion
