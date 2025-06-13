require 'rails_helper'

RSpec.describe "Api::Tasks", type: :request do
  describe "GET /index" do
    let!(:user) { create(:user) }
    let!(:tasks) { create_list(:task, 3, user: user) }

    before do
      get "/api/users/#{user.id}/tasks", headers: { 'Accept': 'application/json' }
    end
    it "returns all tasks for the user" do
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(3)
      expect(json_response.first.keys).to match_array(['id', 'title', 'description', 'status', 'due_date'])
    end
    it { expect(response).to have_http_status(:success) }
  end

  describe "GET /show" do
    let!(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }

    before do
      get "/api/users/#{user.id}/tasks/#{task.id}", headers: { 'Accept': 'application/json' }
    end

    it "returns the task" do
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(task.id)
      expect(json_response['title']).to eq(task.title)
      expect(json_response['description']).to eq(task.description)
      expect(json_response['status']).to eq(task.status)
      expect(json_response['due_date']).to eq(task.due_date.as_json)
    end

    it { expect(response).to have_http_status(:success) }
  end

  describe "POST /create" do
    let!(:user) { create(:user) }
    let(:task_attributes) do
      {
        task: {
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          status: 'pending',
          due_date: Date.tomorrow
        }
      }
    end

    context "with valid attributes" do
      before do
        post "/api/users/#{user.id}/tasks", params: task_attributes, headers: { 'Accept': 'application/json' }
      end

      it { expect(response).to have_http_status(:created) }

      it "creates a new task" do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq(task_attributes[:task][:title])
        expect(json_response['description']).to eq(task_attributes[:task][:description])
        expect(json_response['status']).to eq('pending')
        expect(json_response['due_date']).to eq(Date.tomorrow.as_json)
      end
    end

    context "with invalid attributes" do
      before do
        post "/api/users/#{user.id}/tasks", params: { task: { title: '' } }, headers: { 'Accept': 'application/json' }
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
      delete "/api/users/#{user.id}/tasks/#{task.id}", headers: { 'Accept': 'application/json' }
    end

    it { expect(response).to have_http_status(:no_content) }

    it "deletes the task" do
      expect(Task.exists?(task.id)).to be_falsey
    end
  end
end
