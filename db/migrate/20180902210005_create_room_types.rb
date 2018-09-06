class CreateRoomTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :room_types do |t|
      t.string :name, null: false
      t.text :description
      t.integer :occupancy_limit, null: false, default: 0

      t.timestamps
    end
  end
end
