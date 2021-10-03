class UpdateBroker < ActiveRecord::Migration[6.1]
  def change
    drop_table :broker_instruments
    drop_table :brokers

    create_table :brokers, id: :string do |t|
      t.string :name
      t.string :url

      t.timestamps
    end

    create_table :broker_instruments, id: :uuid do |t|
      t.belongs_to :broker, null: false, foreign_key: true, type: :string
      t.belongs_to :instrument, null: true, foreign_key: true, type: :uuid
      t.string :match
      t.string :matched_by

      t.timestamps
    end
  end
end
