class AddComingSoonToFilms < ActiveRecord::Migration
  def change
    add_column :films, :coming_soon, :boolean, default: false
  end
end
