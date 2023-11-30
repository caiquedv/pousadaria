# API Documentation

## Overview
This API provides access to guesthouse and room data for the Innsight platform. 
It offers endpoints to list active guesthouses, filter them by name, view detailed 
information about a specific guesthouse, list active rooms of a specific guesthouse, 
and verify availability and calculate the total price for a reservation in a specific room.

## Endpoints

### List Active Guesthouses
**GET `/api/v1/guesthouses`**

Retrieves a list of all active guesthouses.

#### Response
- **Status Code**: `200 OK`
- **Content-Type**: `application/json`
- **Body**: A JSON array of guesthouses.

### Filter Guesthouses by Name
**GET `/api/v1/guesthouses?query={name}`**

Retrieves a list of guesthouses that match the search term in their name.

#### Parameters
- `query`: The search term used to filter guesthouses by name.

#### Response
- **Status Code**: `200 OK`
- **Content-Type**: `application/json`
- **Body**: A JSON array of matching guesthouses.

### Guesthouse Details
**GET `/api/v1/guesthouses/:id`**

Retrieves details of a specific guesthouse including its average rating.

#### Parameters
- `id`: The ID of the guesthouse.

#### Response
- **Status Code**: `200 OK` or `404 Not Found`
- **Content-Type**: `application/json`
- **Body**: 
  - On success: Guesthouse details in JSON format.
  - On failure: JSON object with an error message.

### List Active Rooms of a Guesthouse
**GET `/api/v1/guesthouses/:guesthouse_id/rooms`**

Lists all active rooms of a specified guesthouse.

#### Parameters
- `guesthouse_id`: The ID of the guesthouse.

#### Response
- **Status Code**: `200 OK` or `404 Not Found`
- **Content-Type**: `application/json`
- **Body**: 
  - On success: A JSON array of active rooms.
  - On failure: JSON object with an error message.

### Verify Room Availability
**POST `/api/v1/rooms/:room_id/availability`**

Verifies availability for a reservation in a specific room and calculates the total price.

#### Parameters
- `room_id`: The ID of the room.
- `start_date`: Desired start date of the reservation.
- `end_date`: Desired end date of the reservation.
- `guests_number`: Number of guests for the reservation.

#### Response
- **Status Code**: `200 OK`
- **Content-Type**: `application/json`
- **Body**: 
  - On success: JSON object with `total_price`.
  - On failure: JSON object with an error message.