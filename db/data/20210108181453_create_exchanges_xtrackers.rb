class CreateExchangesXtrackers < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'hkex',
      name: 'Hong Kong Stock Exchange',
      url: 'https://www.hkex.com.hk/?sc_lang=en'
    })

    Exchange.create!({
      id: 'sgx',
      name: 'Singapore Exchange',
      url: 'https://www.sgx.com/'
    })

    Exchange.create!({
      id: 'enb',
      name: 'Euronext Brussels',
      url: 'https://www.euronext.com/en/markets/brussels'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
