require "deploy/command"

module Deploy
  class Git < Command
    def clone(options)
      repository = options[:repository]
      directory = options[:directory]

      branch = options[:branch] || "publish"
      remote = options[:remote] || "origin"

      revision = options[:revision] || "#{ remote }/#{ branch }"

      run "mkdir -p #{ directory }"
      run "git clone -o #{ remote } -b #{ branch } #{ repository } #{ directory }"
    end

    def fetch(options)
      repository = options[:repository]
      directory = options[:directory]

      branch = options[:branch] || "publish"
      remote = options[:remote] || "origin"

      revision = options[:revision] || "#{ remote }/#{ branch }"

      cd directory
      run "git config remote.#{ remote }.url #{ repository }"
      run "git config remote.#{ remote }.fetch +refs/heads/*:refs/remotes/#{ remote }/*"
      run "git fetch #{ remote }"
      run "git fetch --tags #{ remote }"
      run "git checkout -f -q #{ branch }"
      run "git reset --hard #{ revision }"
    end

    def update(options)
      directory = options[:directory]

      fetch_command = Git.new { fetch(options) }
      clone_command = Git.new { clone(options) }

      run %{
        if [ -d "#{ directory }/.git" ]; then
        #{ indent fetch_command }
        else
        #{ indent clone_command }
        fi
      }
    end
  end
end
