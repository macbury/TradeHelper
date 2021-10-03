class CreateStuggardExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'swb',
      name: 'Börse Stuttgart',
      url: 'https://www.boerse-stuttgart.de/en/s'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
