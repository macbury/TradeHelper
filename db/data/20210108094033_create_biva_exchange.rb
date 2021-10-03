class CreateBivaExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'biva',
      name: 'Bolsa Institucional de Valores',
      url: 'https://www.biva.com/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
