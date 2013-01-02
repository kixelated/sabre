module Deploy::Shell
  def run!(command, options = Hash.new, &block)
    directory = options[:directory]

    if directory
      command = "cd #{ directory } && #{ command }"
    end

    command
  end
end
