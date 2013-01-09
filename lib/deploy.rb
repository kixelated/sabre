require "net/ssh/multi"

require "deploy/base"
require "deploy/version"

module Deploy
  def self.start(*args, &block)
    Deploy::Base.new(*args).instance_eval(&block)
  end
end
