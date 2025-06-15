require 'swagger_helper'

RSpec.describe 'api/tasks', type: :request do
  let!(:authenticated_user) { create(:user) }
  let(:auth_headers) { { 'Accept': 'application/json', 'Authorization': "Bearer #{authenticated_user.auth_token}" } }

  describe "GET /index" do
    let!(:user) { create(:user) }
    let!(:tasks) { create_list(:task, 3, user: user) }

    context "With valid user" do
      before do
        get "/api/users/#{user.id}/tasks", headers: auth_headers
      end

      it "list tasks" do
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(3)
        expect(json_response.first.keys).to match_array([ 'id', 'title', 'description', 'status', 'due_date' ])
      end

      it { expect(response).to have_http_status(:success) }
    end

    context "With invalid user" do
      before do
        get "/api/users/999999/tasks", headers: auth_headers
      end

      it { expect(response).to have_http_status(:not_found) }

      it "returns an error message" do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Not Found")
      end
    end
  end

  describe "GET /show" do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }

    context "With task_id valid" do
      before do
        get "/api/tasks/#{task.id}", headers: auth_headers
      end

      it "returns the task" do
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(task.id)
        expect(json_response['title']).to eq(task.title)
        expect(json_response['description']).to eq(task.description)
        expect(json_response['status']).to eq(task.status)
        expect(json_response['due_date']).to eq(task.due_date.as_json)
      end
    end

    context "With task_id invalid" do
      before do
        get "/api/tasks/999999", headers: auth_headers
      end

      it { expect(response).to have_http_status(:not_found) }

      it "returns an error message" do
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Not Found")
      end
    end
  end

  describe "POST /create" do
    let!(:user) { create(:user) }
    let(:task_attributes) do
      {
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        status: 'pending',
        due_date: Date.tomorrow
      }
    end

    context "with valid attributes" do
      before do
        post "/api/users/#{user.id}/tasks", params: { task: task_attributes }, headers: auth_headers
      end

      it { expect(response).to have_http_status(:created) }

      it "creates a new task" do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq(task_attributes[:title])
        expect(json_response['description']).to eq(task_attributes[:description])
        expect(json_response['status']).to eq('pending')
        expect(json_response['due_date']).to eq(Date.tomorrow.as_json)
      end
    end

    context "with invalid attributes" do
      before do
        post "/api/tasks", params: {
          task: { title: '' },
          user_id: user.id
        }, headers: auth_headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it "returns error messages" do
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Title can't be blank")
      end
    end
  end

  describe "PUT /update" do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }
    let(:updated_attributes) do
      {
        title: 'Updated Task Title',
        description: 'Updated Task Description',
        status: 'completed',
        due_date: Date.tomorrow
      }
    end

    context "with valid attributes" do
      before do
        put "/api/tasks/#{task.id}", params: {
          task: updated_attributes
        }, headers: auth_headers
      end

      it { expect(response).to have_http_status(:ok) }

      it "updates the task" do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq(updated_attributes[:title])
        expect(json_response['description']).to eq(updated_attributes[:description])
        expect(json_response['status']).to eq(updated_attributes[:status])
        expect(json_response['due_date']).to eq(updated_attributes[:due_date].as_json)
        expect(json_response['id']).to eq(task.id)
      end
    end

    context "with invalid attributes" do
      before do
        put "/api/tasks/#{task.id}", params: {
          task: { title: '' }
        }, headers: auth_headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it "returns error messages" do
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Title can't be blank")
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }

    before do
      delete "/api/tasks/#{task.id}", headers: auth_headers
    end

    it { expect(response).to have_http_status(:no_content) }

    it "deletes the task" do
      expect(Task.exists?(task.id)).to be_falsey
    end
  end
end
