class RemovePosterFromFilms < ActiveRecord::Migration
  def up
    remove_column :films, :poster
  end

  def down
    add_column :films, :poster, :string
  end
end
