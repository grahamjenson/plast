class AddingIndexes < ActiveRecord::Migration
  def change
    add_index :playlists, :uuid
    add_index :plitems, :playlist_id
    add_index :plitem_ranks, :session_id
    add_index :plitem_ranks, :plitem_id
    add_index :plitems, :youtubeid
  end
end
