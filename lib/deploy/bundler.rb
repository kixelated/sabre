require "deploy/base"

class Deploy::Bundler < Deploy::Base
  def install_command(options)
    directory = options[:directory]
    without = options[:without]

    "cd #{ directory } &&
     bundle install --deployment --quiet --without #{ without.join(" ") } &&
     echo \"Bundle installed\""
  end
end
