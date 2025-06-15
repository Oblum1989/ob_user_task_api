require 'swagger_helper'

RSpec.describe 'api/users', type: :request do
  describe "GET /index" do
    let!(:users) { create_list(:user, 3) }
    before do
      get "/api/users", headers: { 'Accept': 'application/json' }
    end

    it { expect(response).to have_http_status(:success) }

    it "returns all users" do
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(3)
      expect(json_response.first.keys).to match_array([ 'id', 'email', 'full_name', 'role', 'tasks' ])
    end
  end

  describe "GET /show" do
    context "Whit user_id valid" do
      let!(:user) { create(:user) }
      before do
        get "/api/users/#{user.id}", headers: { 'Accept': 'application/json' }
      end

      it { expect(response).to have_http_status(:success) }

      it "returns the user" do
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(user.id)
        expect(json_response['email']).to eq(user.email)
        expect(json_response['full_name']).to eq(user.full_name)
      end
    end
    context "Whit user_id invalid" do
      before do
        get "/api/users/999999", headers: { 'Accept': 'application/json' }
      end

      it { expect(response).to have_http_status(:not_found) }

      it "returns an error message" do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("User not found")
      end
    end
  end

  describe "POST /create" do
    let(:user_attributes) do
      {
        user: {
          email: Faker::Internet.email,
          full_name: Faker::Name.name,
          role: 'admin'
        }
      }
    end
    context "with valid attributes" do
      before do
        post "/api/users", params: user_attributes, headers: { 'Accept': 'application/json' }
      end

      it { expect(response).to have_http_status(:created) }

      it "creates a new user" do
        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq(user_attributes[:user][:email])
        expect(json_response['full_name']).to eq(user_attributes[:user][:full_name])
        expect(json_response['role']).to eq('admin')
      end
    end
    context "with invalid attributes" do
      before do
        post "/api/users", params: { user: { email: '', full_name: '', role: '' } }, headers: { 'Accept': 'application/json' }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it "returns error messages" do
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Email can't be blank", "Full name can't be blank", "Role can't be blank")
      end
    end
  end
end
