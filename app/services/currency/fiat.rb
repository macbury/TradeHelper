module Currency
  # Get currency rate for specified date, if rate is missing, try to fetch it from openrates server
  class Fiat < CurrencyAdapter
    SUPPORTED = [
      'GBP', 'HKD', 'IDR', 'ILS', 'DKK', 'INR', 'CHF', 'MXN', 'CZK', 'SGD', 'THB', 'HRK', 'EUR',
      'MYR', 'NOK', 'CNY', 'BGN', 'PHP', 'PLN', 'ZAR', 'CAD', 'ISK', 'BRL', 'RON', 'NZD', 'TRY',
      'JPY', 'RUB', 'KRW', 'USD', 'AUD', 'HUF', 'SEK'
    ].freeze

    def call
      return if current_rate
      return unless success?

      rates['rates'].each do |currency, rate|
        add_rate(base, currency, rate.to_f, date)
        add_rate(currency, base, (1.0 / rate.to_f), date)
      end
    end

    def self.supported?(currency)
      SUPPORTED.include?(currency)
    end

    private

    def kind
      :fiat
    end

    def url
      "https://api.openrates.io/#{date.strftime('%Y-%m-%d')}?base=#{base.upcase}"
    end

    def rates
      @rates ||= Rails.cache.fetch(['fiat_rate', url]) do
        JSON.parse(download(url: url))
      end
    end

    def success?
      rates.dig('error').blank?
    end
  end
end