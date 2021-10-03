class CreateXtbBroker < ActiveRecord::Migration[6.1]
  def up
    Broker.create!(id: 'xtb', name: 'XTB', url: 'https://www.xtb.com/')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
