class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :parent
      t.integer :sessionrecording_id
      t.integer :student_id
      t.integer :kind
      t.text    :body
      
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
