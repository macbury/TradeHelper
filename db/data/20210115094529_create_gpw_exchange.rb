class CreateGpwExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'gpw',
      name: 'Giełda Papierów Wartościowych',
      url: 'https://www.gpw.pl/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
