class CreateBossaBroker < ActiveRecord::Migration[6.1]
  def up
    Broker.create!(id: 'bossa', name: 'Dom Maklerski Banku Ochrony Środowiska', url: 'https://bossa.pl/')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
