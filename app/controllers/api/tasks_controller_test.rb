describe "POST /create" do
  let!(:user) { create(:user) }
  let(:valid_attributes) do
    {
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      status: 'pending',
      due_date: Date.tomorrow
    }
  end

  context "with valid attributes" do
    before do
      post "/api/tasks", params: {
        task: valid_attributes,
        user_id: user.id
      }, headers: { 'Accept': 'application/json' }
    end

    it { expect(response).to have_http_status(:created) }

    it "creates a new task" do
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(valid_attributes[:title])
      expect(json_response['description']).to eq(valid_attributes[:description])
      expect(json_response['status']).to eq(valid_attributes[:status])
      expect(json_response['due_date']).to eq(valid_attributes[:due_date].as_json)
      expect(json_response['user_id']).to eq(user.id)
    end

    it "associates task with correct user" do
      expect(Task.last.user_id).to eq(user.id)
    end
  end

  context "with invalid attributes" do
    before do
      post "/api/tasks", params: {
        task: { title: '' },
        user_id: user.id
      }, headers: { 'Accept': 'application/json' }
    end

    it { expect(response).to have_http_status(:unprocessable_entity) }

    it "returns error messages" do
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to include("Title can't be blank")
    end
  end
end