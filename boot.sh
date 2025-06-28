#!/usr/bin/env bash
exec java -jar server.jar host \
  --autoUpdate=true \
  --autoPause=true \
  --autosave=true --autosaveAmount=64 --autosaveSpacing=1024
