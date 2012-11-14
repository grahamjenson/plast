class RemoveRating < ActiveRecord::Migration
  def change
    remove_column :plitems, :rating
  end

end
