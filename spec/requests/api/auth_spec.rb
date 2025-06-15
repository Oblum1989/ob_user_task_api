require 'swagger_helper'

RSpec.describe 'api/auth/login', type: :request do
  describe "POST /login" do
    let!(:user) { create(:user) }
    let(:invalid_credentials) { { email: 'test1@mail.com', password: 'wrongpassword' } }
    let(:headers) { { 'Accept': 'application/json' } }

    context "With valid credentials" do
      before do
        post "/api/auth/login", params: {
          email: user.email,
          password: user.password
        }, headers: headers
      end

      it "returns a success message" do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Login successful")
      end

      it "returns a token" do
        json_response = JSON.parse(response.body)
        expect(json_response['token']).not_to be_nil
      end

      it { expect(response).to have_http_status(:success) }
    end
    context "With invalid credentials" do
      before do
        post "/api/auth/login", params: invalid_credentials, headers: headers
      end

      it "returns an error message" do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Invalid email or password")
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "POST /logout" do
    let!(:user) { create(:user) }
    let(:headers) { { 'Accept': 'application/json', 'Authorization': "Bearer #{user.auth_token}" } }
    context "With valid token" do
      before do
        post "/api/auth/logout", params: { token: user.auth_token }, headers: headers
      end

      it "returns a success message" do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Logout successful")
      end

      it { expect(response).to have_http_status(:success) }
    end
  end

  describe "POST /register" do
    let(:valid_user_params) do
      {
        user: {
          email: 'test@mail.com',
          password: 'password123',
          full_name: 'Test User',
          role: :admin
        }
      }
    end
    let(:headers) { { 'Accept': 'application/json' } }
    context "With valid user params" do
      before do
        post "/api/auth/register", params: valid_user_params, headers: headers
      end

      it "returns a success message" do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Registration successful")
      end

      it "returns the user details" do
        json_response = JSON.parse(response.body)
        expect(json_response['user']['email']).to eq(valid_user_params[:user][:email])
        expect(json_response['user']['full_name']).to eq(valid_user_params[:user][:full_name])
      end

      it { expect(response).to have_http_status(:created) }
    end
  end
end
