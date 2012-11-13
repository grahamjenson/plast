class AddSessionVote < ActiveRecord::Migration
  def change
    create_table :plitem_ranks do |t|
      t.integer :session_id, :null => false
      t.integer :plitem_id
      t.integer :rank
    end

    drop_table :playlist_sessions
  end
end
