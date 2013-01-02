require "net/ssh/multi"

require "deploy/shell"
require "deploy/version"

class Deploy::Session
  include Deploy::Shell

  def session
    sessions.last
  end

  def sessions
    @sessions ||= [ Net::SSH::Multi.start ]
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
    subsession = session.with(*args)
    sessions.push(subsession)

    begin
      yield
    ensure
      sessions.pop
    end
  end

  def method_missing(method, *args, &block)
    new_method = "#{ method }!".to_sym

    if respond_to?(new_method)
      command = send(new_method, *args)
      #return session.exec(command, &block)
      return puts command
    end

    super
  end
end
