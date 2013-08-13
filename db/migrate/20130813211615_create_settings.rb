class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :size, :null => false
      t.integer :min_randomizer_id, :null => false
      t.integer :max_randomizer_id, :null => false

      t.timestamps
    end
  end
end
