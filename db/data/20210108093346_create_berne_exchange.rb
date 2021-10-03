class CreateBerneExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'bx',
      name: 'Berne eXchange',
      url: 'https://www.bxswiss.com/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
