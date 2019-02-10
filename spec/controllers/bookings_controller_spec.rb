require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe '#create' do
    context 'with valid attributes' do
      let(:room) { create(:room) }
      let(:valid_attrs) { { start: '01/02/2019', end: '04/02/2019', room_id: room.id } }

      it 'creates a new booking' do
        expect {
          post :create, params: valid_attrs
        }.to change{ Booking.count }.by(1)
      end

      it 'responds with status code 200' do
        post :create, params: valid_attrs

        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['message']).to eq 'Booking created.'
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attrs) { { start: '02/02/2019', end: '04/02/2019', room_id: 999 } }

      it 'does not create a booking' do
        expect {
          post :create, params: invalid_attrs
        }.to_not change { Booking.count }
      end

      it 'responds with status code 422' do
        post :create, params: invalid_attrs

        expect(response.status).to eq 422
      end
    end
  end
end