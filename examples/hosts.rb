require "bundler/setup"

require "deploy"

host = Deploy::Command.new do
  on_hosts /^convert/, "Luke-Curleys-MacBook-Pro.local" do
    echo "I am conversion"
    run "false"
  end

  echo "Finished"

  on_error { echo "Error" }
end

puts host
