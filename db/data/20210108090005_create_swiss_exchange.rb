class CreateSwissExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'swiss',
      name: 'SIX Swiss Exchange',
      url: 'https://www.six-group.com/en/products-services/the-swiss-stock-exchange.html'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
