class CreateFundVaneck < ActiveRecord::Migration[6.1]
  def up
    FundProvider.create!(
      id: 'vaneck',
      name: 'VanEck', 
      url: 'https://www.vaneck.com/uk/en/'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
