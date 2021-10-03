class CreateEuronext < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'en',
      name: 'Euronext',
      url: 'https://live.euronext.com/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
