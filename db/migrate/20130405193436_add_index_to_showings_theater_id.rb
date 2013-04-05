class AddIndexToShowingsTheaterId < ActiveRecord::Migration
  def change
    add_index :showings, :theater_id
  end
end
