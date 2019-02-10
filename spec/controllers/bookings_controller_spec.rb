require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe '#create' do
    context 'when a booking with the same start date exists' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '02/02/2019', room: room)}

      it 'returns a booking conflict error' do
        post :create, params: { start: '01/02/2019', end: '04/02/2019', room_id: room.id }

        expect(response.status).to eq 422

        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq 'Booking conflicts with an existing booking'
      end
    end

    context 'when a booking with the same end date exists' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '04/02/2019', room: room) }

      it 'returns a booking conflict error' do
        post :create, params: { start: '02/02/2019', end: '04/02/2019', room_id: room.id }

        expect(response.status).to eq 422

        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq 'Booking conflicts with an existing booking'
      end
    end

    context 'when a booking exists during the duration of another' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '04/02/2019', room: room) }

      it 'returns a booking conflict error' do
        post :create, params: { start: '02/02/2019', end: '03/02/2019', room_id: room.id }

        expect(response.status).to eq 422

        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq 'Booking conflicts with an existing booking'
      end
    end

    context 'when there are no booking conflicts' do
      let(:room) { create(:room) }
      let!(:existing_booking) { create(:booking, start: '01/02/2019', end: '04/02/2019', room: room) }

      it 'returns a booking conflict error' do
        post :create, params: { start: '05/02/2019', end: '07/02/2019', room_id: room.id }

        expect(response.status).to eq 200

        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq 'Booking created.'
        expect(Booking.last).to have_attributes(start: Date.parse('05/02/2019'), end: Date.parse('07/02/2019'), room_id: room.id )
      end
    end
  end
end