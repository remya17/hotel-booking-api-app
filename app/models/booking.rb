class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  scope :in_between_date_range, -> (move_in_date, move_out_date) do
    where('(move_in_date >= ? AND move_in_date <= ?) OR (move_in_date >= ? AND move_out_date <= ?) OR (move_in_date <= ? AND move_out_date >= ?)',
          move_in_date, move_out_date, move_in_date, move_out_date, move_in_date, move_in_date)
  end
end
