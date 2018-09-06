class CreateHotelRoomTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :hotel_room_types do |t|
      t.belongs_to :hotel, null: false
      t.belongs_to :room_type, null: false
      t.integer :total_rooms, null: false, default: 0

      t.timestamps
    end

    add_index :hotel_room_types, [:hotel_id, :room_type_id], unique: true
  end
end
