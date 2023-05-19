class TriggerController < ApplicationController
  def index
    render plain: Time.now.to_s
    save_datetime_to_database
    send_event_to_redis
  end

  private

  def save_datetime_to_database
    Datetime.create(last_request_time: Time.now)
  end

  def send_event_to_redis
    RedisEventWorker.perform_async
  end
end

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
