require "deploy/base"

require "colored"

class Deploy::Shell < Deploy::Base
  def run(command)
    command.gsub!(/\s+/, " ")

    puts session.servers.join(", ").green
    puts command.bold

    channel = session.exec(command) do |ch, stream, data|
      puts "[#{ ch[:host] } : #{ stream }]".cyan + " #{ data }"
    end
    channel.wait

    failures = []
    channel.each do |ch|
      failures << ch[:host] if ch[:exit_status] != 0
    end

    raise "Error on #{ failures.join(", ") }" unless failures.empty?

    channel
  end
end
