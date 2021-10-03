class CreateOmxEchange < ActiveRecord::Migration[6.1]
  def up
    Exchange.create!({
      id: 'omx',
      name: 'Nasdaq Nordic',
      url: 'http://www.nasdaqomxnordic.com/'
    })
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
