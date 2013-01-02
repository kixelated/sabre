require "deploy/base"

class Deploy::Shell < Deploy::Base
  def run(*args, &block)
    command = run!(*args, &block)

    puts session.servers.join(", ")
    #session.exec(command)
    puts command
  end

  def run!(command, options = Hash.new, &block)
    directory = options[:directory]

    if directory
      command = "cd #{ directory } && #{ command }"
    end

    command
  end
end
