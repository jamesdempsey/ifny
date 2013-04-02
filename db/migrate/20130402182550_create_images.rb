class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :width
      t.integer :height
      t.string :image_type
      t.integer :film_id

      t.timestamps
    end
  end
end
