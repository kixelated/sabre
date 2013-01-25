{
  if [[ `hostname -f` =~ "^convert" ]] || [[ `hostname -f` == "Luke-Curleys-MacBook-Pro.local" ]]; then
    echo "I am conversion" &&
    false;
  fi &&
  echo "Finished";
} || {
  echo "Error" && false;
}
