echo "Starting auto updater script"

PYVER=python3.7
PIPVER=pip3

# Some preconditions first
set -e
$PYVER --version
$PIPVER install -r requirements.txt 2>&1
echo "Tools ok!"

# Prepare...
pkill python || echo "Python was not running."
git pull 2>&1
echo "All ok!"
echo "Starting loop..."

while true
do
  git fetch;
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})

  # If our local revision id doesn't match the remote, we will need to pull the changes
  if [ "{$LOCAL}" != "{$REMOTE}" ]; then
    echo "An update has been noticed"

    echo "Killing Python"
    pkill python  || echo "Python was not running." # Maybe we should kill only lotus.py...

    # pull and merge changes
    echo "Pulling changes"
    git pull origin master

    echo "Starting lotus.py"
    nohup $PYVER lotus.py &

  fi
  sleep 5
done