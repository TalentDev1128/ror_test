class RedisEventWorker
  include Sidekiq::Worker

  def perform
    last_request_time = Datetime.last&.last_request_time
    return unless last_request_time

    while next_event = Redis.new.rpop('trigger_queue')
      if Time.parse(Time.now.to_s) - Time.parse(next_event) >= 60
        Redis.new.publish('events', next_event.to_s)
        last_request_time = Time.parse(next_event)
        Datetime.create(last_request_time: last_request_time)
      else
        Redis.new.lpush('trigger_queue', next_event.to_s)
        break
      end
    end

    self.class.perform_in(3.seconds)
  end
end