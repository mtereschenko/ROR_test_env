#!/bin/ash
set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

rake db:exists && rake db:migrate || rake db:setup
rails server --environment=development --port=4000 --binding=0.0.0.0