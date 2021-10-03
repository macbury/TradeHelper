class CreateBrokers < ActiveRecord::Migration[6.1]
  def change
    create_table :brokers, id: :uuid do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
