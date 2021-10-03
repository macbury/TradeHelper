class CreateBmeExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'bme',
      name: 'Madrid Stock Exchange',
      url: 'https://www.bolsasymercados.es/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
