class AddIndexToTheatersUrl < ActiveRecord::Migration
  def change
    add_index :theaters, :url, unique: true
  end
end
