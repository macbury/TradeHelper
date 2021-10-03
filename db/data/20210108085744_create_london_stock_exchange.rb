class CreateLondonStockExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'lse',
      name: 'London Stock Exchange',
      url: 'https://www.londonstockexchange.com/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
