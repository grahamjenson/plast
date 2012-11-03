class CreatePlitems < ActiveRecord::Migration
  def change
    create_table :plitems do |t|
      t.string :youtubeid
      t.string :title
      t.string :thumbnail
      t.integer :length
      t.float :rating
      t.integer :playlist_id
      t.timestamps
    end
  end
end
