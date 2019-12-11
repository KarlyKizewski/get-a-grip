class AddPictureToRocks < ActiveRecord::Migration[5.2]
  def change
    add_column :rocks, :picture, :string
  end
end
