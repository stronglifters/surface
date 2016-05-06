require "flipper"
require "flipper/adapters/redis"

$flipper = Flipper.new(Flipper::Adapters::Redis.new(Redis.new))
