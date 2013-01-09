require "deploy/base"

class Deploy::Release < Deploy::Base
  def make(directory, options, &block)
    base = options[:base] # optional

    current = options[:current] || "#{ directory }/current"
    releases = options[:releases] || "#{ directory }/releases"

    directory = "#{ releases }/#{ Time.now.to_i }"

    begin
      if base
        run "mkdir -p '#{ releases }' &&
             cp -R '#{ base }' '#{ directory }'"
      else
        run "mkdir -p '#{ directory }'"
      end

      yield(directory)

      run "rm -f '#{ current }' &&
           ln -s '#{ directory }' '#{ current }'"

      run "ask 'Continue? (y/n) '"
    rescue
      run "echo 'Removing release #{ directory }' &&
           rm -rf '#{ directory }'"
      raise
    end
  end
end
