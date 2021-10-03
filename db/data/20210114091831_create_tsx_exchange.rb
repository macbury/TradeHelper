class CreateTsxExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'tsx',
      name: 'Toronto stock exchange',
      url: 'https://tsx.com/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
