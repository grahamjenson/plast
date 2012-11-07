class AddPlaylistSessionsAndOrder < ActiveRecord::Migration
  def change
    create_table :playlist_sessions do |t|
      t.integer :playlist_id
      t.integer :session_id
      t.timestamps
    end
  end
end
[]