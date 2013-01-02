require "thread"

require "net/ssh/multi"
require "highline"

class Deploy::Base
  extend Forwardable

  attr_accessor :session

  def_delegator :session, :close, :close
  def_delegator :session, :via, :gateway
  def_delegator :session, :group, :group
  def_delegator :session, :servers, :servers
  def_delegator :session, :loop, :sync

  PASSWORD_PROMPT = Mutex.new

  def initialize(session = nil)
    @session = session

    unless session
      try_password = Proc.new do |server|
        throw :go, :raise if server[:retry]
        server[:retry] = true

        PASSWORD_PROMPT.synchronize do
          @@password ||= nil
          unless @@password
            @@password = HighLine.new.ask("Password: ") { |q| q.echo = false }
          end
        end

        server.options[:password] = @@password
        server.options[:auth_methods] = %w(password keyboard-interactive)

        throw :go, :retry
      end

      @session = Net::SSH::Multi::Session.new(:on_error => try_password)
    end
  end

  def on(*args)
    temp_session = session
    @session = session.with(*args)

    begin
      yield
    ensure
      @session = temp_session
    end
  end

  def server(*args, &block)
    options = { :auth_methods => %w(publickey hostbased) }
    options.merge!(args.pop) if args.last.is_a?(Hash)

    session.use(*args, options, &block)
  end

  def method_missing(method, *args, &block)
    # obj.git = Deploy::Git.new(obj.session)
    new_class_name = method.to_s.capitalize.to_sym
    new_class = Deploy.const_get(new_class_name) rescue nil

    if new_class
      return new_class.new(session)
    end

    # obj.foo = shell.run(obj.foo_command)
    new_method = "#{ method }_command".to_sym

    if respond_to?(new_method)
      command = send(new_method, *args)

      require "deploy/shell"
      return shell.run(command, &block)
    end

    super
  end
end

