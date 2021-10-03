require 'sidekiq/web'
require 'sidekiq/cron/web'

Sidekiq::Web.set :session_secret, Rails.application.secret_key_base

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URI') }

  config.on(:startup) do
    broker_sync_schedule = Broker.pluck(:id).each_with_object({}) do |fund_provider_id, schedule|
      schedule["fetch_broker_#{fund_provider_id}"] = {
        cron: "0 2 * * *",
        class: Sync::BrokerInstruments.name,
        args: [fund_provider_id]
      }
    end

    fund_sync_schedule = FundProvider.pluck(:id).each_with_object({}) do |broker_id, schedule|
      schedule["fetch_fund_#{broker_id}"] = {
        cron: "0 2 * * *",
        class: Sync::FundWorker.name,
        args: [broker_id]
      }
    end

    Sidekiq::Cron::Job.load_from_hash fund_sync_schedule.merge(broker_sync_schedule)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URI') }
end
