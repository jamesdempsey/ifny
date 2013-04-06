class RemoveIndexFromFilmsUrl < ActiveRecord::Migration
  def up
    remove_index :films, :url
  end

  def down
    add_index :films, :url
  end
end
