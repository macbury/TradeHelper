class RemoveIsinFromInstruments < ActiveRecord::Migration[6.1]
  def change
    remove_column :instruments, :isin
  end
end
