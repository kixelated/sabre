module Sabre::Base
  def echo(string)
    run %{ echo "#{ string }" }
  end

  def cd(directory)
    run %{ cd "#{ directory }" }
  end

  def cp(source, target)
    run %{ cp -R "#{ source }" "#{ target }" }
  end

  def mv(source, target)
    run %{ mv "#{ source }" "#{ target }" }
  end

  def set(name, value)
    run %{ #{ name }="#{ value }" }
  end

  def synchronize
    run %{
      read -n1 -p "Continue? (y/n) " &&
      echo &&
      [[ $REPLY == "y" ]]
    }
  end
end
