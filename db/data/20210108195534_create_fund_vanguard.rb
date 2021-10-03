class CreateFundVanguard < ActiveRecord::Migration[6.1]
  def up
    FundProvider.create!(
      id: 'vanguard',
      name: 'Vanguard', 
      url: 'https://investor.vanguard.com/home'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
