# Connect to Redis
$redis = Redis.new url: ENV['REDIS_URL']

# Change the redis database to test the application
$redis.select(1) if Rails.env == 'test'
