class CreateRankingCache < ActiveRecord::Migration
  def change
    add_column :plitems, :rating,  :float
    add_column :plitems, :rating_dirty, :boolean
  end
end
