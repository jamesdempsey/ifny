class AddPosterToImages < ActiveRecord::Migration
  def change
    add_column :images, :poster, :string
  end
end
