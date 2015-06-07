#!/usr/bin/env bash
set -e
bin/rake default
RAILS_ENV=production bin/rake assets:precompile package:build
