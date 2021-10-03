class CreateBxSwissExchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'frankfurt',
      name: 'Boerse frankfurt',
      url: 'https://www.boerse-frankfurt.de/en'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
