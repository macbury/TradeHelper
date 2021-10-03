module Sync
  # Add all funds to be synchronized
  class AllFundsWorker < Worker
    def perform
      FundProvider.pluck(:id).each { |fund_provider_id| FundWorker.perform_async(fund_provider_id) }
    end
  end
end