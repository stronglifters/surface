#!/usr/bin/env sh
bin/rake default
RAILS_ENV=production bin/rake package:build
