require "bundler/setup"

require "deploy"
require "deploy/git"
require "deploy/bundler"
require "deploy/release"

Deploy.start do
  on "convert-lcurley-sl6.dev.box.net", "convert-sl6.dev.box.net" do
    git.update(:repository => "ssh://scm.dev.box.net/box/www/conversion",
               :directory => "/box/lib/conversion_new/shared", :branch => "publish")

    release.make("/box/lib/conversion_new", :base => "/box/lib/conversion_new/shared") do |dir|
      bundler.install(:directory => dir, :without => [ :test, :deploy ])
    end
  end
end
