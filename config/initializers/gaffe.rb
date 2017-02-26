Gaffe.configure do |config|
  config.errors_controller = {
    %r[^/api/] => 'Api::ErrorsController',
    %r[^/] => 'ErrorsController',
  }
end
Gaffe.enable!
