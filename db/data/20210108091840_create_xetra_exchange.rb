class CreateXetraExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'xetra',
      name: 'Xetra',
      url: 'https://www.xetra.com/xetra-en/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
