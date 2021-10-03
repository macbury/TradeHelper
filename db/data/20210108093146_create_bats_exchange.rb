class CreateBatsExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'chi-xeu',
      name: 'BATS Chi-X Europe',
      url: 'https://www.interactivebrokers.com/en/index.php?f=2666'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
