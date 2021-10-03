class Worker
  extend Usable
  include Sidekiq::Worker

  sidekiq_options backtrace: true, retry: 5
end