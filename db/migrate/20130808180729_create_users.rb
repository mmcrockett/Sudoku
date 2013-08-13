class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :difficulty, :default => 1
      t.integer :size, :default => 4
      t.string  :indices
      t.string  :preferences

      t.timestamps
    end
  end
end
