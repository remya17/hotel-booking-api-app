class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.belongs_to :hotel_room_type, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
