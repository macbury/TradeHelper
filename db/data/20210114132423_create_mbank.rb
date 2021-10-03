class CreateMbank < ActiveRecord::Migration[6.1]
  def up
    Broker.create!(id: 'mbank', name: 'mBank', url: 'https://www.mbank.pl/indywidualny/')
  end

  def down
    
  end
end
