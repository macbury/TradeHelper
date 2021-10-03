module FundProviders
  # Get list of urls that need to be scrapped for passed fund
  class ListOfPendingInstruments < Service
    def initialize(fund_provider)
      @fund_provider = fund_provider
    end

    def call
      fetch_service.call.shuffle
    end

    private

    attr_reader :fund_provider

    def fetch_service
      case fund_provider.id
      when 'ishare' then Ishare::FetchAll
      when 'xtrackers' then XTrackers::FetchAll
      when 'ssga' then Spdr::FetchAll
      when 'lyxor' then Lyxor::FetchAll
      when 'vaneck' then Vaneck::FetchAll
      when 'vanguard' then Vanguard::FetchAll
      when 'wisdom_tree' then WisdomTree::FetchAll
      else
        raise ServiceFailure, "Create missing class for fetching list of instrument urls for #{provider.id}"
      end
    end
  end
end