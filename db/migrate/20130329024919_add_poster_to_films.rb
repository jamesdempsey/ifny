class AddPosterToFilms < ActiveRecord::Migration
  def change
    add_column :films, :poster, :string
  end
end
