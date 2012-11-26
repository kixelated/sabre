require 'net/ssh'

require 'colored'
require 'peach'
require 'thread'

module Deploy
  class SSH
    class << self
      CONNECTING = Mutex.new

      def connection(host, options = Hash.new)
        return @session[host] if @session and @session[host]

        ssh_options = Net::SSH.configuration_for(host).merge(options)
        ssh_options[:config] = false

        user = ssh_options[:user] || ENV['USER'] || ENV['USERNAME']
        methods = [ %w(publickey hostbased), %w(password keyboard-interactive) ]

        session = nil

        CONNECTING.synchronize do
          begin
            ssh_options[:auth_methods] = methods.shift
            ssh_options[:password] = @password if @password

            session = Net::SSH.start(host, user, ssh_options)
          rescue Net::SSH::AuthenticationFailed
            raise if methods.empty?

            unless @password
              @password = HighLine.new.ask("Password: ") { |q| q.echo = false }
            end

            retry
          end
        end

        @session ||= Hash.new
        @session[host] = session
      end

      def run(hosts, command, options = Hash.new)
        hosts = [ hosts ] unless hosts.is_a?(Array)

        puts "\nRunning command on #{ hosts.join(", ") }".green.bold
        puts "#{ command }\n".bold

        hosts.peach do |host|
          session = connection(host, options)
          session.exec!(command) do |channel, stream, data|
            data.chomp!

            unless data.empty?
              print "#{ host }:\t ".cyan
              puts "#{ data }"
            end
          end
        end
      end
    end
  end
end
