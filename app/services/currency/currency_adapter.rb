module Currency
  class CurrencyAdapter < Service
    use Download::Get, as: :download

    def initialize(date:, base:, target:)
      @date = date.to_date
      @base = base.upcase
      @target = target.upcase
    end

    def self.supported?(_currency)
      raise NotImplementedError, 'Implement this method'
    end

    private

    attr_reader :date, :base, :target

    def current_rate
      @current_rate ||= ExchangeRate.where(base: base, currency: target, date: date).first
    end

    def add_rate(base, currency, value, date)
      rate = ExchangeRate.find_or_initialize_by(kind: kind, date: date, currency: currency, base: base)
      rate.value = value
      rate.save!
    end

    def kind
      raise NotImplementedError, 'Specify kind of currency. Look into ExchangeRate kind column'
    end
  end
end