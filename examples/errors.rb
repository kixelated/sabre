require "bundler/setup"
require "sabre"

errors = Sabre::Command.new do
  run do
    echo "step 1"
    synchronize

    on_error { echo "step 1 failed" }
  end

  run do
    echo "step 2"
    synchronize

    on_error { echo "step 2 failed" }
  end

  echo "finished"

  on_error { echo "something failed" }
end

puts errors
