class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :uuid, :limit => 36
      t.timestamps
    end
  end
end
