require "deploy/command"

class Deploy::Release < Deploy::Command
  def make(directory, options = Hash.new, &block)
    current = options[:current] || "#{ directory }/current"
    releases = options[:releases] || "#{ directory }/releases"

    set "RELEASE", "#{ releases }/`date +%s`"
    run %{ mkdir -p "$RELEASE" }

    invoke(&block)
    synchronize

    run %{ rm -f "#{ current }" }
    run %{ ln -s "$RELEASE" "#{ current }" }

    on_error do
      echo "Removing release $RELEASE"
      run %{ rm -rf "$RELEASE" }
    end
  end
end
