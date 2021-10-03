module Currency
  # Get currency rate for specified date, if rate is missing, try to fetch it from coinbase server
  class Crypto < CurrencyAdapter
    FIRST_BTC_BLOCK = '2013-04-28T00:00:00.000Z'.freeze
    SUPPORTED = [
      'BTC', 'ETH'
    ].freeze

    use TopCryptoCurrencies, as: :top_crypto_currencies

    def call
      rate = rate_by_date[date]
      return unless rate

      add_rate(crypto_currency, fiat_currency, rate.to_f, date)
      add_rate(fiat_currency, crypto_currency, (1.0 / rate.to_f), date)
    end

    def self.supported?(currency)
      SUPPORTED.include?(currency)
    end

    private

    def kind
      :crypto
    end

    def crypto_currency
      currencies.key?(base) ? base : target
    end

    def fiat_currency
      currencies.key?(base) ? target : base
    end

    def url
      "https://web-api.coinmarketcap.com/v1.1/cryptocurrency/quotes/historical?convert=#{fiat_currency},BTC&format=chart_crypto_details&id=#{currency_id}&interval=1d&time_end=#{time_end}&time_start=#{FIRST_BTC_BLOCK}"
    end

    def time_end
      Time.zone.now.end_of_day.to_i
    end

    def currency_id
      @currency_id ||= currencies[crypto_currency]
    end

    def currencies
      @currencies ||= top_crypto_currencies
    end

    def rates
      @rates ||= Rails.cache.fetch(['crypto_rate', url]) do
        JSON.parse(download(url: url))
      end
    end

    def rate_by_date
      @rate_by_date ||= rates.fetch('data').each_with_object({}) do |(date, rates), out|
        out[Time.zone.parse(date).to_date] = rates[fiat_currency].first
      end
    end
  end
end