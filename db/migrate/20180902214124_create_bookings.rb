class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.belongs_to :user, null: false
      t.belongs_to :room, null: false
      t.date :move_in_date, null: false
      t.date :move_out_date, null: false
      t.decimal :monthly_rent, precision: 12, scale: 2, default: 0.0, null: false
      t.string :payment_transaction_id, limit: 200

      t.timestamps
    end

    add_index :bookings, :move_in_date
    add_index :bookings, :move_out_date
  end
end
