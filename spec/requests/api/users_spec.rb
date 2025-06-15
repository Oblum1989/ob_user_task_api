require 'swagger_helper'

RSpec.describe 'api/users', type: :request do
  let!(:authenticated_user) { create(:user) }
  let(:auth_headers) { { 'Accept': 'application/json', 'Authorization': "Bearer #{authenticated_user.auth_token}" } }
  describe "GET /index" do
    let!(:users) { create_list(:user, 3) }
    before do
      get "/api/users", headers: auth_headers
    end

    it { expect(response).to have_http_status(:success) }

    it "returns all users" do
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(4) # 3 created users + authenticated user
      expect(json_response.first.keys).to match_array([ 'id', 'email', 'full_name', 'role', 'tasks' ])
    end
  end

  describe "GET /show" do
    context "With user_id valid" do
      let!(:user) { create(:user) }
      before do
        get "/api/users/#{user.id}", headers: auth_headers
      end

      it { expect(response).to have_http_status(:success) }

      it "returns the user" do
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(user.id)
        expect(json_response['email']).to eq(user.email)
        expect(json_response['full_name']).to eq(user.full_name)
      end
    end

    context "With user_id invalid" do
      before do
        get "/api/users/999999", headers: auth_headers
      end

      it { expect(response).to have_http_status(:not_found) }

      it "returns an error message" do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("User not found")
      end
    end
  end
end
