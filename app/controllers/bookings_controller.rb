class BookingsController < ApplicationController
  def create
    booking = Booking.new(booking_params)
    if booking.save 
      render json: { message: 'Booking created.' }, status: :ok
    else
      render json: { message: 'Booking conflicts with an existing booking' }, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.permit(:start, :end, :room_id)
  end
end
