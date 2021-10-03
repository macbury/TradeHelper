class CreateExchangesList < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'bit',
      name: 'Borsa Italiana',
      url: 'https://www.borsaitaliana.it/homepage/homepage.htm'
    })

    Exchange.create!({
      id: 'tel-aviv',
      name: 'Tel Aviv',
      url: 'https://www.tase.co.il/en'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
