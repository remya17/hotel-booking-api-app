# hotel-booking-api-app

This is a Rails 5 API application for hotel booking.

## Dependencies
This app is built on stable version of Ruby 2.5.0, and uses PostgreSQL for database.

## Configuration
Run following commands
```
bundle install
rails db:setup
```
```rails db:setup``` command will create the database, tables and set the seed data. Please refer ```db/seeds.rb``` for the initial data setup.
  
## API 

All the APIs are scoped under a given hotel and room type.

* ### Availability API

**Description:** Returns information about the availability for the given duration and monthly rent of room.  

**URL:** ```GET   /hotels/:hotel_id/room_types/:room_type_id/room_availabilities```

**Request Parameters**
```
move_in_date: Move in date in mm/dd/yyyy format
move_out_date: Move out date in mm/dd/yyyy format 
```
**Response Parameters**
```
success: TRUE/FALSE
error: Error message if any
status: Shows status of the call
move_in_date: Move in date
move_out_date: Move out date     
available: Room is available or not TRUE/FALSE
number_of_rooms_available: Number of rooms available
available_room_ids: Array of available Room IDs
monthly_rent: Monthly rent for room
formatted_currency_rent: Currency formatted rent eg, $2,700.00
```

* ### Booking API

**Description:** Does the booking for guest user   

**URL:** ```POST  /hotels/:hotel_id/room_types/:room_type_id/bookings```
 
**Request Parameters**
```
{
  "booking": 
    {
      "move_in_date": Move in date mm/dd/yyyy format, 
      "move_out_date": Move out date mm/dd/yyyy format
    },
  "user": 
    {
      "email" : Email ID, 
      "first_name" : First name, 
      "last_name" : Last name
    }
}
```
**Response Parameters**
```
success: TRUE/FALSE
error: Error messages if any
status: Shows status of the call
booking_id: Booking ID
monthly_rent: Monthly rent for room
formatted_currency_rent: Currency formatted rent eg, $2,700.00
```

* ### Rate Update API

**Description:** Using this API, Hotel partners can update the rates for rooms for the given duration    

**URL:** ```PUT   /hotels/:hotel_id/room_types/:room_type_id/rates```
 
**Request Parameters**
```
{
  "rate": 
    {
      "start_date": Start date provided mm/dd/yyyy format, 
      "end_date": End date provided mm/dd/yyyy format,
      "price": Rate for per day
    }
}
```
**Response Parameters**
```
success: TRUE/FALSE
error: Error message if any
status: Shows status of the call
hotel_room_type_rate_id: Hotel Room Type Rate ID
```

## **Response Codes**

```
* 200 - OK
* 402 - Bad request, Parameter missing
* 422 - Unprocessable entity
* 404 - Record not found
* 500 - Internal server error 
```
