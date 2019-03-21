#!/bin/bash

export MIX_ENV=prod
export PORT=4792
export HOME=/home/hw04

echo "Stopping old copy of memory app, if any..."

/home/hw04/memory/_build/prod/rel/memory/bin/memory stop || true

echo "Starting memory game..."

/home/hw04/memory/_build/prod/rel/memory/bin/memory start
