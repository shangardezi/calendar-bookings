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
  end
end