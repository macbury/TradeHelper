class CreateFundLyxor < ActiveRecord::Migration[6.1]
  def up
    FundProvider.create!(
      id: 'lyxor',
      name: 'Lyxor', 
      url: 'https://www.lyxoretf.co.uk/'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
