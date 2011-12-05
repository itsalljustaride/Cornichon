class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :grouptask_id, :null => false
      t.string :viewable, :default => "none"
      t.string :discussionable, :default => "none"
      t.string :downloadable, :default => "none"

      t.timestamps
    end    
  end

  def self.down
    drop_table :permissions
  end
end
