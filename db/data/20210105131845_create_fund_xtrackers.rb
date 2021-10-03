class CreateFundXtrackers < ActiveRecord::Migration[6.1]
  def up
    FundProvider.create!(
      id: 'xtrackers',
      name: 'Xtrackers', 
      url: 'https://etf.dws.com/en-gb/'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
