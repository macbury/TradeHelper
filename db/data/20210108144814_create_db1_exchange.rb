class CreateDb1Exchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'db1',
      name: 'Deutsche Börse Group',
      url: 'https://deutsche-boerse.com/dbg-en/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
