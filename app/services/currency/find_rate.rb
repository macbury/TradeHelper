module Currency
  class FindRate < Service
    use Fiat, as: :get_fiat
    use Crypto, as: :get_crypto

    def initialize(date:, base:, target:)
      @date = date
      @base = base.upcase
      @target = target.upcase
    end

    def call
      return current_day_rate&.value if current_day_rate

      if Crypto.supported?(target) || Crypto.supported?(base)
        get_crypto(date: date, base: base, target: target)
      else
        get_fiat(date: date, base: base, target: target)
      end

      ExchangeRate
        .where(base: base, currency: target)
        .where('date <= :date', date: date)
        .order('date DESC').first&.value || 0.0
    end

    private

    attr_reader :date, :base, :target

    def current_day_rate
      @current_day_rate ||= ExchangeRate.where(base: base, currency: target, date: date).first
    end
  end
end