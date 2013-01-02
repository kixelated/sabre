require "net/ssh/multi"

class Deploy::Base
  attr_accessor :session

  def initialize(session = nil)
    @session = session || Net::SSH::Multi.start
  end

  def method_missing(method, *args, &block)
    # obj.git = Deploy::Git.new(obj.session)
    new_class_name = method.to_s.capitalize.to_sym
    new_class = Deploy.const_get(new_class_name) rescue nil

    if new_class
      return new_class.new(session)
    end

    # obj.foo = shell.run(obj.foo!)
    new_method = "#{ method }!".to_sym

    if respond_to?(new_method)
      command = send(new_method, *args)

      require "deploy/shell"
      shell = Deploy::Shell.new(session)
      return shell.run(command, &block)
    end

    super
  end

  def gateway(*args)
    session.via(*args)
  end

  def group(*args, &block)
    session.group(*args, &block)
  end

  def server(*args)
    session.use(*args)
  end

  def on(*args)
    temp_session = self.session
    self.session = self.session.with(*args)

    begin
      yield
    ensure
      self.session = temp_session
    end
  end
end

