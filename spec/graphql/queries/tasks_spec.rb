require 'rails_helper'

RSpec.describe 'Queries::Tasks', type: :request do
  describe 'tasks query' do
    let!(:user) { create(:user) }
    let!(:tasks) { create_list(:task, 3, user: user) }

    describe 'listing tasks' do
      let(:query) do
        <<~GQL
          query {
            tasks {
              id
              title
              description
              status
              user {
                id
              }
              createdAt
              updatedAt
            }
          }
        GQL
      end

      it 'returns all tasks' do
        post '/graphql', params: { query: query }.to_json, headers: { 'Content-Type': 'application/json' }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(json_response['data']['tasks'].length).to eq(3)
        expect(json_response['data']['tasks'].first['title']).to eq(tasks.first.title)
      end

      context 'with user_id filter' do
        let(:query_with_user) do
          <<~GQL
            query($userId: ID!) {
              tasks(userId: $userId) {
                id
                title
                status
                description
              }
            }
          GQL
        end

        it 'returns tasks for specific user' do
          variables = { userId: user.id.to_s }
          post '/graphql', params: { query: query_with_user, variables: variables }.to_json,
               headers: { 'Content-Type': 'application/json' }

          json_response = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(json_response['data']['tasks'].length).to eq(3)
        end
      end

      context 'with status filter' do
        let!(:completed_tasks) { create_list(:task, 2, user: user, status: 'pending') }
        let(:query_with_status) do
          <<~GQL
            query($status: String!) {
              tasks(status: $status) {
                id
                title
                status
              }
            }
          GQL
        end

        it 'returns tasks with specific status' do
          variables = { status: 'pending' }
          post '/graphql', params: { query: query_with_status, variables: variables }.to_json,
               headers: { 'Content-Type': 'application/json' }

          json_response = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          expect(json_response['data']['tasks'].length).to eq(2)
          expect(json_response['data']['tasks'].all? { |t| t['status'] == 'pending' }).to be true
        end
      end

      context 'with both user_id and status filters' do
        let!(:other_user) { create(:user) }
        let!(:other_user_tasks) { create_list(:task, 2, user: other_user, status: 'pending') }

        let(:query_with_filters) do
          <<~GQL
            query($userId: ID!, $status: String!) {
              tasks(userId: $userId, status: $status) {
                id
                title
                status
                description
                createdAt
              }
            }
          GQL
        end

        it 'returns filtered tasks by both user and status' do
          variables = { userId: user.id.to_s, status: 'pending' }
          post '/graphql', params: { query: query_with_filters, variables: variables }.to_json,
               headers: { 'Content-Type': 'application/json' }

          json_response = JSON.parse(response.body)

          expect(response).to have_http_status(:success)
          tasks = json_response['data']['tasks']
          expect(tasks.all? { |t| t['userId'] == user.id.to_s && t['status'] == 'pending' }).to be true
        end
      end
    end
  end
end
