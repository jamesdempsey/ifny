class AddIndexToFilmsUrl < ActiveRecord::Migration
  def change
    add_index :films, :url, unique: true
  end
end
