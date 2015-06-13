#!/usr/bin/env bash
set -e
DISABLE_SPRING=true RAILS_ENV=production bin/rake assets:precompile package:build
