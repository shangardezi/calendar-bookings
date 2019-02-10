require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start) }
    it { should validate_presence_of(:end) }
    it { should validate_presence_of(:room) }
  end

  describe '#start_date_is_before_end_date' do
    context 'when start date is after end date' do
      it 'does not create booking' do
        room = create(:room)
        booking = Booking.new start: '03/02/2019', end: '01/02/2019', room: room

        expect(booking).not_to be_valid
        expect(booking.errors.messages[:start]).to include 'cannot be after the end date'
        expect(booking.errors.messages[:end]).to include 'cannot be before the start date'
      end
    end

    context 'when start date is before end date' do
      it 'is valid' do
        room = create(:room)
        booking = Booking.new start: '01/02/2019', end: '02/02/2019', room: room

        expect(booking).to be_valid
      end
    end

    context 'when start date and end date are the same' do
      it 'is valid' do
        room = create(:room)
        booking = Booking.new start: '01/02/2019', end: '01/02/2019', room: room

        expect(booking).to be_valid
      end
    end
  end
end
