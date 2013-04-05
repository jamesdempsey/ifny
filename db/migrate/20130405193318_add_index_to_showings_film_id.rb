class AddIndexToShowingsFilmId < ActiveRecord::Migration
  def change
    add_index :showings, :film_id
  end
end
