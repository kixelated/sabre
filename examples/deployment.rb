require "bundler/setup"
require "sabre"

deployment = Sabre::Command.new do
  git.update(repository: "https://github.com/qpingu/sabre.git",
             directory: "test_deploy/shared")

  release.create("test_deploy") do
    cp("test_deploy/shared", "$RELEASE")
  end
end

puts deployment
