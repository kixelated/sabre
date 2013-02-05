require 'sabre/command'

class Sabre::Bundler < Sabre::Command
  def install(options)
    directory = options[:directory]
    without = options[:without]

    cd directory
    run "bundle install --deployment --quiet --without #{ without.join(" ") }"
    echo "Bundle installed"
  end
end
