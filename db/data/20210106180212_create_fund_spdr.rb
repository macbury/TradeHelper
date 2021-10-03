class CreateFundSpdr < ActiveRecord::Migration[6.1]
  def up
    FundProvider.create!(
      id: 'ssga',
      name: 'State Street Global Advisors', 
      url: 'https://www.ssga.com/uk/en_gb/institutional/etfs'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
