{
  RELEASE="/box/lib/conversion_test/releases/`date +%s`" &&
  mkdir -p "$RELEASE" &&
  if [ -d "$RELEASE/.git" ]; then
    cd "$RELEASE" &&
    git config remote.origin.url ssh://scm.dev.box.net/box/www/conversion &&
    git config remote.origin.fetch +refs/heads/*:refs/remotes/origin/* &&
    git fetch origin &&
    git fetch --tags origin &&
    git checkout -f -q publish &&
    git reset --hard origin/publish
  else
    mkdir -p $RELEASE &&
    git clone -o origin -b publish ssh://scm.dev.box.net/box/www/conversion $RELEASE
  fi &&
  read -n1 -p "Continue? (y/n) " &&
  echo &&
  [[ $REPLY == "y" ]] &&
  rm -f "/box/lib/conversion_test/current" &&
  ln -s "$RELEASE" "/box/lib/conversion_test/current";
} || {
  echo "Removing release $RELEASE" &&
  rm -rf "$RELEASE" && false;
}
