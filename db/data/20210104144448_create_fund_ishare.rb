class CreateFundIshare < ActiveRecord::Migration[6.1]
  def up
    FundProvider.create!(
      id: 'ishare',
      name: 'iShare', 
      url: 'https://www.ishares.com/'
    )
  end

  def down
    
  end
end
