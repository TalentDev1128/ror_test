require "#{Rails.root}/app/workers/redis_event_worker.rb"
class TriggerController < ApplicationController
  def index
    Redis.new.lpush('trigger_queue', Time.now.to_s)
    render plain: "Event added to queue at #{Time.now}"
    
  end

  def startRedisWorker
    RedisEventWorker.perform_async
  end
end