require "deploy/base"

class Deploy::Git < Deploy::Base
  def clone_command(options)
    repository = options[:repository]
    directory = options[:directory]

    branch = options[:branch] || "publish"
    remote = options[:remote] || "origin"

    revision = options[:revision] || "#{ remote }/#{ branch }"

    "mkdir -p #{ directory } &&
     git clone -o #{ remote } -b #{ branch } #{ repository } #{ directory }"
  end

  def fetch_command(options)
    repository = options[:repository]
    directory = options[:directory]

    branch = options[:branch] || "publish"
    remote = options[:remote] || "origin"

    revision = options[:revision] || "#{ remote }/#{ branch }"

    "cd #{ directory } &&
     git config remote.#{ remote }.url #{ repository } &&
     git config remote.#{ remote }.fetch +refs/heads/*:refs/remotes/#{ remote }/* &&
     git fetch #{ remote } &&
     git fetch --tags #{ remote } &&
     git checkout -f -q #{ branch } &&
     git reset --hard #{ revision }"
  end

  def update_command(options)
    directory = options[:directory]

    "if [ -d #{ directory }/.git ];
     then #{ fetch_command(options) };
     else #{ clone_command(options) }; fi"
  end
end
