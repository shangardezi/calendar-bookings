class BookingsController < ApplicationController
  def create
    if booking.save 
      render json: { message: 'Booking created.' }, status: :ok
    else
      render json: { message: booking.errors.full_messages.join('\n') }, status: :unprocessable_entity
    end
  end

  private

  def booking
    @booking = Booking.new(booking_params)
  end

  def booking_params
    params.permit(:start, :end, :room_id)
  end
end
