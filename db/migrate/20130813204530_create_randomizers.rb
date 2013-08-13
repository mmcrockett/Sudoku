class CreateRandomizers < ActiveRecord::Migration
  def change
    create_table :randomizers do |t|
      t.references :board

      t.timestamps
    end
    add_index :randomizers, :board_id
  end
end
