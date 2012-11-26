require "deploy/ssh"

module Deploy
  class Git
    class << self
      def clone(options)
        source_host, source_dir = options[:source_host], options[:source_dir]
        target_host, target_dir = options[:target_host], options[:target_dir]

        branch = options[:branch] || "publish"
        remote = options[:remote] || "origin"

        revision = options[:revision] || "#{ remote }/#{ branch }"
        source_host = source_host.sample if source_host.is_a?(Array)

        command = "mkdir -p #{ target_dir } && " +
                  "git clone -o #{ remote } -b #{ branch } ssh://#{ source_host }#{ source_dir } #{ target_dir }"

        SSH.run(target_host, command) unless options[:dry]
        command
      end

      def fetch(options)
        source_host, source_dir = options[:source_host], options[:source_dir]
        target_host, target_dir = options[:target_host], options[:target_dir]

        remote = options[:remote] || "origin"
        branch = options[:branch] || "publish"

        revision = options[:revision] || "#{ remote }/#{ branch }"
        source_host = source_host.sample if source_host.is_a?(Array)

        command = "cd #{ target_dir } && " +
                  "git config remote.#{ remote }.url ssh://#{ source_host }#{ source_dir } && " +
                  "git config remote.#{ remote }.fetch +refs/heads/*:refs/remotes/#{ remote }/* && " +
                  "git fetch #{ remote } && " +
                  "git fetch --tags #{ remote } && " +
                  "git checkout -f -q #{ branch } && " +
                  "git reset --hard #{ revision }"

        SSH.run(target_host, command) unless options[:dry]
        command
      end

      def update(options)
        target_host, target_dir = options[:target_host], options[:target_dir]
        dry_options = options.merge(:dry => true)

        command = "if [ -d #{ target_dir }/.git ]; " +
                  "then #{ fetch(dry_options) }; " +
                  "else #{ clone(dry_options) }; fi"

        SSH.run(target_host, command) unless options[:dry]
        command
      end
    end
  end
end
