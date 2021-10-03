module Sync
  class FetchFundDetailsWorker < Worker
    use FundProviders::BuildInstrument, as: :build_instrument
    sidekiq_options backtrace: true, retry: 0

    def perform(fund_provider_id, pending_instrument)
      fund_provider = FundProvider.find(fund_provider_id)
      pending_instrument = PendingInstrument.new(pending_instrument)

      build_instrument(pending_instrument: pending_instrument, fund_provider: fund_provider)
    end
  end
end