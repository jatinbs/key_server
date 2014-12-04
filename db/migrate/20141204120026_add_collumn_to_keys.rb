class AddCollumnToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :locked, :boolean, :default => false
  end
end
