module Currency
  class SyncExchangeRate < Service
    use Fiat, as: :fetch_fiat
    use Crypto, as: :fetch_crypto

    def call
      Fiat::SUPPORTED.each { |fiat| fetch_fiat(base: main_currency, target: fiat, date: today) }
      Crypto::SUPPORTED.each { |crypto| fetch_crypto(base: main_currency, target: crypto, date: today) }
    end

    private

    GRAM_TO_OUNCE = 0.03215 # 1 Gram Weight = 0.03215 Troy Ounce

    METALS = {
      'XAU' => 'GAU',
      'XAG' => 'GAG'
    }.freeze

    def today
      @today ||= Time.zone.today
    end

    def main_currency
      Money.default_currency.iso_code.upcase
    end
  end
end