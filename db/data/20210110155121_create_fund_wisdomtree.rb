class CreateFundWisdomtree < ActiveRecord::Migration[6.1]
  def up
    FundProvider.create!(
      id: 'wisdom_tree',
      name: 'WisdomTree', 
      url: 'https://www.wisdomtree.eu/'
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
