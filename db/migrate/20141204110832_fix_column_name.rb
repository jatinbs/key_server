class FixColumnName < ActiveRecord::Migration
  def change
    rename_column "keys", "hash", "unique_hash"
  end
end
