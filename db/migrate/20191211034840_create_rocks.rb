class CreateRocks < ActiveRecord::Migration[5.2]
  def change
    create_table :rocks do |t|
      t.string :name
      t.text :description
      t.string :address
      t.text :message
      t.timestamps
    end
  end
end
