class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :users, :public, :boolean
  end
end
