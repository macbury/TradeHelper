class CreateFundProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :fund_providers, id: :string do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
