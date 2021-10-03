class CreateLimaExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!(
      id: 'bvl',
      name: 'Lima Stock Exchange', 
      url: 'https://www.bvl.com.pe/'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
