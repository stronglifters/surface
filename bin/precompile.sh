#!/usr/bin/env bash
set -e
RAILS_ENV=production bin/rake assets:precompile package:build
