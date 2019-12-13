class AlterRocksAddLatAndLng < ActiveRecord::Migration[5.2]
  def change
    add_column :rocks, :latitude, :float
    add_column :rocks, :longitude, :float
  end
end
