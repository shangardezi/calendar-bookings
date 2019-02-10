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

        expect(booking).to_not be_valid
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

    context 'when start and end date are the same' do
      it 'is valid' do
        room = create(:room)
        booking = Booking.new start: '01/02/2019', end: '01/02/2019', room: room

        expect(booking).to be_valid
      end
    end
  end

  describe '#availability' do
    context 'when a booking with the same start date exists' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '02/02/2019', room: room)}

      it 'is not valid' do
        booking = described_class.new start: '01/02/2019', end: '04/02/2019', room_id: room.id 

        expect(booking).to_not be_valid
      end
    end

    context 'when a booking with the same end date exists' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '04/02/2019', room: room) }

      it 'returns a booking conflict error' do
        booking = described_class.new start: '02/02/2019', end: '04/02/2019', room_id: room.id 

        expect(booking).to_not be_valid
      end
    end

    context 'when a booking exists during the duration of another' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '04/02/2019', room: room) }

      it 'returns a booking conflict error' do
        booking = described_class.new start: '02/02/2019', end: '03/02/2019', room_id: room.id 

        expect(booking).to_not be_valid
      end
    end

    context 'when there are no booking conflicts' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '04/02/2019', room: room) }

      it 'returns a booking conflict error' do
        booking = described_class.new start: '05/02/2019', end: '07/02/2019', room_id: room.id       

        expect(booking).to be_valid
      end
    end
  end
end
