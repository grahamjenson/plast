class AddSoundcloudSupport < ActiveRecord::Migration
  def change
    rename_column :plitems, :youtubeid, :mediaid
    add_column :plitems, :playername, :string
    Plitem.update_all(:playername => "youtube")
  end
end
