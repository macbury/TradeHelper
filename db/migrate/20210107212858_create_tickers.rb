class CreateTickers < ActiveRecord::Migration[6.1]
  def change
    create_table :tickers, id: :uuid do |t|
      t.string :isin
      t.string :ticker
      t.string :currency
      t.string :kind
      t.belongs_to :exchange, null: false, foreign_key: true, type: :string
      t.belongs_to :instrument, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
