class CreateCboeExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'cboe',
      name: 'Cboe Europe',
      url: 'https://www.cboe.com/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
