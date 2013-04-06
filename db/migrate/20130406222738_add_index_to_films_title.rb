class AddIndexToFilmsTitle < ActiveRecord::Migration
  def change
    add_index :films, :title
  end
end
