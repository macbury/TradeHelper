module Currency
  # Get top 100 crypto currencies and map their ids with ticker on coinmarketcap
  class TopCryptoCurrencies < Service
    HTTP_ENDPOINT = 'https://web-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?&sort=market_cap&sort_dir=desc&convert=USD&cryptocurrency_type=all'.freeze
    use Download::Get, as: :download

    def call
      currencies.each_with_object({}) do |currency, out|
        out[currency['symbol']] = currency['id']
      end
    end

    private

    def currencies
      @currencies ||= Rails.cache.fetch(['crypto_currencies', HTTP_ENDPOINT], expires_in: 1.day) do
        JSON.parse(download(url: HTTP_ENDPOINT))
      end.fetch('data', [])
    end
  end
end