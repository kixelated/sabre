require 'sabre/command'

class Sabre::Release < Sabre::Command
  def create(directory, options = Hash.new, &block)
    current = options[:current] || "#{ directory }/current"
    releases = options[:releases] || "#{ directory }/releases"

    set "RELEASE", "#{ releases }/`date +%s`"
    run %{ mkdir -p "$RELEASE" }

    run(&block)

    run %{ rm -f "#{ current }" }
    run %{ ln -s "$RELEASE" "#{ current }" }

    on_error do
      run %{ rm -rf "$RELEASE" }
    end
  end
end
