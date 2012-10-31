class CreatePlitems < ActiveRecord::Migration
  def change
    create_table :plitems do |t|
      t.string :url

      t.timestamps
    end
  end
end
