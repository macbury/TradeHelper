module Sync
  # Get all instrument urls and fetch their details in separate workers
  class FundWorker < Worker
    use FundProviders::ListOfPendingInstruments, as: :listo_of_pending_instruments

    def perform(fund_provider_id)
      fund_provider = FundProvider.find(fund_provider_id)

      listo_of_pending_instruments(fund_provider).each do |pending_instrument|
        FetchFundDetailsWorker.perform_async(fund_provider_id, pending_instrument.to_h)
      end
    end
  end
end