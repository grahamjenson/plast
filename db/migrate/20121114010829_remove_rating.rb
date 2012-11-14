class RemoveRating < ActiveRecord::Migration
  def up
    remove_column :plitems, :rating
  end

  def down
    add_column :plitems, :rating, :float
  end

end
