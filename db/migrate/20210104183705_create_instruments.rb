class CreateInstruments < ActiveRecord::Migration[6.1]
  def change
    create_table :instruments, id: :uuid do |t|
      t.string :name
      t.string :product_identifier # unique id that helps matching instrument even when url would change
      t.string :details_url
      t.belongs_to :fund_provider, null: false, foreign_key: true, type: :string
      t.string :isin
      t.string :description
      t.string :asset
      t.string :profit
      t.string :replication
      t.float :provision, description: 'Provision taken by etf in percent(1.0 means 100%)'
      t.string :currency
      t.string :residence, description: 'ISO code of the country'

      t.timestamps
    end
  end
end
