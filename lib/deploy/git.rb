module Deploy::Git
  def git_clone!(options)
    repository = options[:repository]
    directory = options[:directory]

    branch = options[:branch] || "publish"
    remote = options[:remote] || "origin"

    revision = options[:revision] || "#{ remote }/#{ branch }"

    "mkdir -p #{ directory } &&
     git clone -o #{ remote } -b #{ branch } #{ repository } #{ directory }"
  end

  def git_fetch!(options)
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

  def git_update!(options)
    directory = options[:directory]

    "if [ -d #{ directory }/.git ];
     then #{ git_fetch!(options) };
     else #{ git_clone!(options) }; fi"
  end
end
