class AlterRocksAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :rocks, :user_id, :integer
    add_index :rocks, :user_id
  end
end
