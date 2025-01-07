#!/user/bin/env bash

# Terminate already running bars
polybar-msg cmd quit

# Wait until termination is successful
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar main &

echo "Polybar launched."
