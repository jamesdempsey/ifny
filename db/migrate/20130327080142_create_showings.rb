class CreateShowings < ActiveRecord::Migration
  def change
    create_table :showings do |t|
      t.integer :film_id
      t.datetime :showtime
      t.integer :theater_id

      t.timestamps
    end
  end
end
