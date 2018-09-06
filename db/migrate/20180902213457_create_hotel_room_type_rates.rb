class CreateHotelRoomTypeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :hotel_room_type_rates do |t|
      t.belongs_to :hotel_room_type, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.decimal :rate, precision: 12, scale: 2, default: 0.0, null: false

      t.timestamps
    end

    add_index :hotel_room_type_rates, :start_date
    add_index :hotel_room_type_rates, :end_date
  end
end
