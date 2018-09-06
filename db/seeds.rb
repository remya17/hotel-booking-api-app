# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ROOM_TYPE_DATA = [{name: '2 full­size beds with a private bath', description: 'With TV', occupancy_limit: 2},
                  {name: 'King­size bed with a private bath', description: 'Smoking allowed', occupancy_limit: 2},
                  {name: '2 Queen­size beds with a private bath', description: 'With TV', occupancy_limit: 4}]


HOTEL_DATA = [
    {
        name: 'Miyako Hotel',
        location: 'Los Angeles',
        description: 'With luxury amenities',
        room_details: [
            {
                room_type_name: '2 full­size beds with a private bath',
                total_rooms: 3,
                rate: 30,
                rooms: [
                    {
                        name: '101',
                        description: 'Garden view'
                    },
                    {
                        name: '201',
                        description: 'Garden view'
                    },
                    {
                        name: '301',
                        description: 'Garden view'
                    }
                ]
            },
            {
                room_type_name: 'King­size bed with a private bath',
                total_rooms: 2,
                rate: 40,
                rooms: [
                    {
                        name: '102',
                        description: 'Beach view'
                    },
                    {
                        name: '202',
                        description: 'Beach view'
                    }
                ]
            }
        ]
    },
    {
        name: 'Hampton Inn & Suites',
        location: 'Thousand Oaks',
        description: 'With luxury amenities',
        room_details: [
            {
                room_type_name: '2 Queen­size beds with a private bath',
                total_rooms: 3,
                rate: 70,
                rooms: [
                    {
                        name: '101',
                        description: 'Garden view'
                    },
                    {
                        name: '201',
                        description: 'Garden view'
                    },
                    {
                        name: '301',
                        description: 'Garden view'
                    }
                ]
            },
            {
                room_type_name: 'King­size bed with a private bath',
                total_rooms: 2,
                rate: 90,
                rooms: [
                    {
                        name: '102',
                        description: 'Beach view'
                    },
                    {
                        name: '202',
                        description: 'Beach view'
                    }
                ]
            }
        ]
    }
]

def populate_room_types
  ROOM_TYPE_DATA.each { |room_data| RoomType.create!(room_data) }
end

def populate_hotels
  start_date = Date.today
  end_date = start_date + 10.years

  HOTEL_DATA.each do |hotel_data|
    hotel = Hotel.create!(name: hotel_data[:name], description: hotel_data[:description], location: hotel_data[:location])

    hotel_data[:room_details].each do |room_detail|
      room_type = RoomType.find_by_name(room_detail[:room_type_name])
      hotel_room_type = HotelRoomType.create!(hotel: hotel, room_type: room_type, total_rooms: room_detail[:total_rooms])

      HotelRoomTypeRate.create!(hotel_room_type: hotel_room_type, start_date: start_date,
                                end_date: end_date, rate: room_detail[:rate])

      room_detail[:rooms].each do |room|
        Room.create!(room.merge(hotel_room_type: hotel_room_type))
      end
    end
  end
end

def populate_data
  populate_room_types
  populate_hotels
end

populate_data