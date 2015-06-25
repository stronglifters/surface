#!/usr/bin/env bash
set -e
bundle package --all-platforms
DISABLE_SPRING=true RAILS_ENV=production bin/rake assets:clobber assets:precompile package:build
