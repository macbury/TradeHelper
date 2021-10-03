class CreateBrokerInstruments < ActiveRecord::Migration[6.1]
  def change
    create_table :broker_instruments, id: :uuid do |t|
      t.belongs_to :broker, null: false, foreign_key: true, type: :uuid
      t.belongs_to :instrument, null: true, foreign_key: true, type: :uuid
      t.string :match
      t.string :matched_by

      t.timestamps
    end
  end
end
