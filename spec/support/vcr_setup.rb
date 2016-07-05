VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr"
  config.hook_into :webmock
  config.ignore_hosts "codeclimate.com"
  config.ignore_localhost = true
end
