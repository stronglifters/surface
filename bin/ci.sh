#!/usr/bin/env sh
bin/bundle exec rake default
RAILS_ENV=production bin/rake assets:precompile
bin/rake package:build
