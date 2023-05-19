require "#{Rails.root}/app/workers/redis_event_worker.rb"
class TriggerController < ApplicationController
  def index
    render plain: Time.now.to_s
    send_event_to_redis
  end

  private

  def send_event_to_redis
    current_time = Time.now
    last_request_time = Datetime.last&.last_request_time

    if last_request_time.nil? || current_time - last_request_time > 60
      RedisEventWorker.perform_async
      Datetime.create(last_request_time: current_time)
    end
  end
end
