class CreatePlitems < ActiveRecord::Migration
  def change
    create_table :plitems do |t|
      t.string :url
      t.integer :playlist_id
      t.timestamps
    end
  end
end
