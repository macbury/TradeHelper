module FundProviders
  # Match exchange name with its representation in database
  # It is better when this is done by hand than automatic just to ensure no duplication will appera
  class MatchExchange < Service
    def initialize(exchange_name)
      @exchange_name = exchange_name.strip.downcase
    end

    def call
      Exchange.find(exchange_id)
    rescue ActiveRecord::RecordNotFound
      raise ServiceFailure, "Create exchange for missing id: #{exchange_id}"
    end

    private

    attr_reader :exchange_name

    def exchange_id
      case exchange_name
      when 'lima' then 'bvl'
      when 'bolsa institucional de valores' then 'biva'
      when 'bolsa mexicana de valores' then 'bmv'
      when 'bmv' then 'bmv'
      when 'bx swiss' then 'bx'
      when 'london stock exchange' then 'lse'
      when 'lse' then 'lse'
      when 'bx berne exchange' then 'swiss'
      when 'six' then 'swiss'
      when 'six swiss exchange' then 'swiss'
      when 'six swiss ex' then 'swiss'
      when 'six - swiss exchange' then 'swiss'
      when 'xetra' then 'xetra'
      when 'deutsche börse' then 'db1'
      when 'deutsche börse ag' then 'db1'
      when 'deutsche boerse xetra' then 'xetra'
      when 'borsa italiana' then 'bit'
      when 'borsa' then 'bit'
      when 'tel aviv stock exchange' then 'tel-aviv'
      when 'euronext amsterdam' then 'en'
      when 'euronext' then 'en'
      when 'bats chi-x europe' then 'chi-xeu'
      when 'berne stock exchange' then 'bx'
      when 'cboe europe' then 'cboe'
      when 'bats' then 'cboe'
      when 'chicago board options exchange europe' then 'cboe'
      when 'euronext paris' then 'en'
      when 'euronext(fr)' then 'en'
      when 'cboe cxe' then 'cboe'
      when 'stuttgart stock exchange' then 'swb'
      when 'hong kong stock exchange' then 'hkex'
      when 'sgx – singapore exchange' then 'sgx'
      when 'sgx' then 'sgx'
      when 'euronext brussels' then 'en'
      when 'frankfurt' then 'frankfurt'
      when 'omx' then 'omx'
      when 'tsx' then 'tsx'
      when 'tse' then 'tsx'
      when 'bme' then 'bme'
      when 'wse' then 'gpw'
      else
        raise ServiceFailure, "Could not match exchange with name #{exchange_name}"
      end
    end
  end
end