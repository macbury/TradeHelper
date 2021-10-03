module Sync
  # Sync instruments by isin for broker
  class BrokerInstruments < Worker
    use Brokers::Instruments::Fetch::MBank, as: :fetch_mbank
    use Brokers::Instruments::Fetch::Bossa, as: :fetch_bossa
    use Brokers::Instruments::Fetch::Xtb, as: :fetch_xtb
    use Brokers::Instruments::Match::ByIsin, as: :match_by_isin
    use Brokers::Instruments::Match::BySymbol, as: :match_by_symbol

    def perform(broker_id)
      broker = Broker.find(broker_id)

      if broker.id == 'xtb'
        match_by_symbol(broker: broker, pending_etfs: pending_etfs_for(broker))
      else
        match_by_isin(broker: broker, pending_etfs: pending_etfs_for(broker))
      end
    end

    private

    def pending_etfs_for(broker)
      case broker.id
      when 'mbank' then fetch_mbank
      when 'bossa' then fetch_bossa
      when 'xtb' then fetch_xtb
      else
        raise NotImplementedError, "Not supported broker id: #{broker.id}"
      end
    end
  end
end