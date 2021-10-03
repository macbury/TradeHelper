class CreateBolsaMexicanaExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'bmv',
      name: 'Mexican Stock Exchange',
      url: 'http://www.bmv.com.mx/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
