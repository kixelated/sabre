{
  {
    echo "step 1" &&
    read -n1 -p "Continue? (y/n) " &&
    echo &&
    [[ $REPLY == "y" ]];
  } || {
    echo "step 1 failed" && false;
  } &&
  {
    echo "step 2" &&
    read -n1 -p "Continue? (y/n) " &&
    echo &&
    [[ $REPLY == "y" ]];
  } || {
    echo "step 2 failed" && false;
  } &&
  echo "finished";
} || {
  echo "something failed" && false;
}
