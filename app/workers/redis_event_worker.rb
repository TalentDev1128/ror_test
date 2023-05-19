class RedisEventWorker
  include Sidekiq::Worker

  def perform
    last_request_time = Datetime.last&.last_request_time
    return unless last_request_time

    current_time = Time.now
    return if current_time - last_request_time < 60

    Redis.new.publish('events', last_request_time.to_s)
  end
end