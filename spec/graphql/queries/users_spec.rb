require 'rails_helper'

RSpec.describe 'Queries::Users', type: :request do
  describe 'users query' do
    let!(:users) { create_list(:user, 3) }

    describe 'single user query' do
      let!(:user) { users.first }

      let(:query) do
        <<~GQL
          query($id: ID!) {
            user(id: $id) {
              id
              fullName
              email
              tasks {
                title
                status
              }
            }
          }
        GQL
      end
      let(:variables) { { id: user.id.to_s } }
      it 'returns the user with tasks' do
        post '/graphql', params: { query: query, variables: variables }.to_json, headers: { 'Content-Type' => 'application/json' }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(json_response['data']['user']['id']).to eq(user.id.to_s)
        expect(json_response['data']['user']['fullName']).to eq(user.full_name)
        expect(json_response['data']['user']['email']).to eq(user.email)
        expect(json_response['data']['user']['tasks']).to be_an(Array)
      end
    end
  end
end
