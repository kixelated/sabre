require 'blockenspiel'

require 'sabre/base'

class Sabre::Command
  include Blockenspiel::DSL
  include Sabre::Base

  def initialize(&block)
    @commands = Array.new
    @error_commands = Array.new
    @conditions = Array.new

    Blockenspiel.invoke(block, self) if block
  end

  def run(command = nil, &block)
    if block
      command = Sabre::Command.new(&block)
    elsif command.is_a?(String)
      command = unindent(command)
    end

    @commands << command
    command
  end

  def on(conditions, &block)
    if block
      command = Sabre::Command.new(&block)
      command.on(conditions)

      run(command)
    else
      conditions = Array(conditions)
      @conditions += conditions
    end
  end

  def on_hosts(*hosts, &block)
    conditions = hosts.collect do |h|
      if h.is_a?(Regexp)
        "[[ `hostname -f` =~ \"#{ h.source }\" ]]"
      else
        "[[ `hostname -f` == \"#{ h }\" ]]"
      end
    end

    condition = conditions.join(" || ")
    on(condition, &block)
  end

  def on_error(command = nil, &block)
    if block
      command = Sabre::Command.new(&block)
    elsif command.is_a?(String)
      command = unindent(command)
    end

    @error_commands << command
    command
  end

  def indent(command)
    command.to_s.gsub(/^/, "  ")
  end

  def unindent(command)
    command = command.to_s

    if command =~ /^\n([ \t]+)/
      command = command.gsub(/^#{ $1 }/, '')
    end

    command.strip
  end

  def to_s
    command = @commands.join(" &&\n")

    unless @error_commands.empty?
      error_command = @error_commands.join(" &&\n")
      command = "{\n#{ indent(command) };\n} || {\n#{ indent(error_command) } && false;\n}"
    end

    unless @conditions.empty?
      condition = @conditions.join(" &&\n")

      command = unindent %{
        if #{ condition }; then
        #{ indent(command) };
        fi
      }
    end

    command
  end

  def method_missing(sym, *args, &block)
    # provides "undef.method" -> "run Undef.new.method"
    klass_name = sym.to_s.capitalize
    klass = Sabre.const_get(klass_name) rescue nil

    super unless klass

    command = klass.new(&block)
    run command # note: this object will be modified later!

    command
  end
end
